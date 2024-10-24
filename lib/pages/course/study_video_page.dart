import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yibei_app/routes/index.dart';
import './components/study_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:pod_player/pod_player.dart';

import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/utils/tools_util.dart';
import 'package:yibei_app/utils/routes_util.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/config/config.dart';
import 'package:yibei_app/components/common/yb_button.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/course/study_const/study_const.dart';
import 'package:yibei_app/models/course/user_progress/progress.dart';
import 'package:yibei_app/models/course/course_chapter_step/course_chapter_step.dart';
import 'package:yibei_app/models/course/current_chapter_progress/current_chapter_progress.dart';
import 'package:yibei_app/models/course/course_chapter_data/course_chapter_data_item.dart';
import 'package:yibei_app/models/common/common_return_states/common_return_states.dart';
import 'package:yibei_app/models/course/course_chapter_set_next/course_chapter_set_next.dart';

import 'package:yibei_app/provider/user_progress_model.dart';
import 'package:yibei_app/provider/course_chapter_data_model.dart';

import 'package:yibei_app/api/course.dart';
import 'package:yibei_app/api/user.dart';

/// 视频学习
class StudyVideoPage extends StatefulWidget {
  /// 课程id
  late int courseId;

  /// 章节id
  late int chapterId;

  /// 是否通过了，步骤5 英文关键词测试
  late int? isReviewWordTest;

  /// 是否复习
  late int? isReview;

  // 课程类型
  int? courseType;

  StudyVideoPage(this.courseId, this.chapterId, this.isReviewWordTest,
      this.isReview, this.courseType,
      {Key? key})
      : super(key: key);

  @override
  State<StudyVideoPage> createState() => _StudyVideoPageState();
}

class _StudyVideoPageState extends State<StudyVideoPage> {
  /// 课程章节详情信息
  late CourseChapterDataItem? _courseChapterInfo;

  /// 用户的学习进度
  late Progress _userProgress = Progress();

  // 步骤列表
  List<CourseChapterStep> _stepData = [];

  // 视频控制器
  late final PodPlayerController _videoController;

  // 视频加载
  bool _videoLoading = true;

  // 是否可以弹框的标识
  bool isShowDialog = true;

  // 当前步骤的进度
  late int courseProgressStatus;

  /// 学习时长累计-定时器对象
  Timer? _studyTotalTimer;

  /// 学习历史-定时器对象
  Timer? _studyHistoryTimer;

  /// 学习历史id
  int? _studyHistoryId;

  // 下一节的课程id
  int? _nextCourseId;

  // 下一节的章节id
  int? _nextChapterId;

  /// 获取课程详情
  Future<bool> _queryCourseInfo() async {
    // 如果provider中没有课程详情，就从接口用去获取
    if (_courseChapterInfo == null) {
      // 设置值详情
      await Provider.of<CourseChapterDataModel>(context, listen: false)
          .setCourseChapterDataItem(chapterId: widget.chapterId);

      // 再次查询课程详情
      CourseChapterDataItem? courseChapterDetails =
          Provider.of<CourseChapterDataModel>(context, listen: false)
              .getCourseChapterDataItem(widget.chapterId);

      // final章节无视频时，直接跳转到final的关键词测试
      if (courseChapterDetails?.isfinal == 1 &&
          courseChapterDetails?.videopath == null) {
        _handleFinalGoto(AppRoutes.studyWordFinalTest);
        return false;
      }

      // 设置值
      setState(() {
        _courseChapterInfo = courseChapterDetails;
      });
    }

    // 初始化视频
    videoPlayInit(videoUrl: _courseChapterInfo!.videopath!);
    return true;
  }

  /// 获取章节的学习进度
  _queryChapterProgress() async {
    BaseEntity<CurrentChapterProgress> entity = await getCurrentChapterProgress(
      progressId: _userProgress.id ?? 0,
      courseId: widget.courseId,
      chapterId: widget.chapterId,
    );
    if (entity.data?.status != true) {
      return;
    }

    // 实例化工具类
    ToolsUtil toolsUtil = ToolsUtil();

    // 过滤出存在的步骤列表
    List<CourseChapterStep> stepData = toolsUtil.courseChapterStepData
        .map((stepDataItem) {
          if (_courseChapterInfo!.studystep!
              .contains(stepDataItem.index.toString())) {
            return stepDataItem;
          }
        })
        .whereType<CourseChapterStep>()
        .toList();

    setState(() {
      // 步骤列表
      _stepData = ToolsUtil.courseChapterStep(
        stepData: stepData,
        chapterProgress: entity.data?.data?.status == 4 ? 100 : 0,
        chapterId: widget.chapterId,
        currentCourseChapterId: widget.chapterId ?? 0,
        stepFlag: entity.data?.data?.status ?? 0,
      );
    });

    // 调整步骤顺序
    courseProgressStatus =
        ToolsUtil.adjustmentStepSort(step: entity.data?.data?.status ?? 0);

    // 如果只有视频时，并且进度超过视频学习，获取下一节的章节信息
    if (_courseChapterInfo?.studystep == "0" &&
        entity.data!.data!.status! > 0) {
      await _handleNextProgress(isUpdate: 0);
    }

    // 是否已经学习过
    if (entity.data!.data!.status! > 0) {
      _handleShowVideoDialog(barrierDismissible: true);
      return;
    }

    // 本章节是否第一次学习
    if (entity.data!.data!.status! == -1) {
      _handleStartStudyCourse();
      _handleUpdateCourseStatus(0);
      _handleUpdateCourseChapterStep(0);
    }
  }

  /// 开始学习某个课程
  _handleStartStudyCourse() async {
    await startStudyCourse(
      progressId: _userProgress.id ?? 0,
      courseId: widget.courseId,
    );
  }

  /// 修改课程进度状态
  /// -1:未开始 0：进行中 1：已完成
  _handleUpdateCourseStatus(int status) async {
    await updateProgressCourseStatus(
      progressId: _userProgress.id ?? 0,
      courseId: widget.courseId,
      chapterId: widget.chapterId,
      status: status,
    );
  }

  /// 更新学习的步骤
  /// -1:未开始  0：观看视频中  1：单词中英  2：单词英  3：单元测试中  4：完成  5：单词中英（测试） 6：单词英（测试）
  Future<bool> _handleUpdateCourseChapterStep(int status) async {
    BaseEntity<CommonReturnStates> entity =
        await updateProgressCourseChapterStep(
      progressId: _userProgress.id ?? 0,
      courseId: widget.courseId,
      chapterId: widget.chapterId,
      status: status,
    );
    return entity.data?.status ?? false;
  }

  /// 创建学习页面的停留信息及时间等
  /// 1:视频  2:记单词（中英） 3:记单词（中英）测试   4:记单词（英）  5：记单词（中英）测试   6:单元测试   7.单元测试前关键词
  /// 8:我的错题（测前单词） 9:我的错题测试   10:高频错题（测前单词）  11:高频错题测试  12:综合题（测前单词）  13:综合题测试  14:应变测试（测前单词）  15:应变测试
  _handleCreateStudyConst() {
    _studyHistoryTimer = Timer(const Duration(seconds: 20), () async {
      // 取消延时时
      _studyHistoryTimer?.cancel();

      BaseEntity<StudyConst> entity = await createStudyConst(
        courseId: widget.courseId,
        chapterId: widget.chapterId,
        category: 1, // 学习视频
      );
      if (entity.data?.status == true && entity.data?.id != null) {
        _studyHistoryId = entity.data?.id;
      }
    });
  }

  /// 更新学习页面的停留信息及时间等
  _handleUpdateStudyConst() {
    if (_studyHistoryId == null) return;

    updateStudyConst(
      studyId: _studyHistoryId!,
    );
  }

  /// 完成视频学习，进入下一步
  _handleStudyNext() async {
    // 1: 中英文关键词卡
    const int step = 1;

    // 如果是全屏时，先退出全屏
    if (_videoController.isFullScreen == true) {
      _videoController.disableFullScreen(context);
    }

    if (courseProgressStatus > 0) {
      if (_courseChapterInfo!.studystep == '0') {
        // 跳转到下一章的视频学习
        _handleGoto(0);
      } else {
        _handleGoto(step);
      }
    } else {
      if (_courseChapterInfo!.studystep == '0') {
        final bool status = await _handleUpdateCourseChapterStep(4);
        await _handleNextProgress(isUpdate: 1);
        // 跳转到下一章的视频学习
        if (status) {
          _handleGoto(0);
        }
      } else {
        final bool status = await _handleUpdateCourseChapterStep(step);
        if (status) {
          // 跳转页面
          _handleGoto(step);
        }
      }
      updateUserProgressModel(); // provider 学习进度更新通知
    }
  }

  /// 测试成功时，重置进度为下一章
  Future<void> _handleNextProgress({
    required int isUpdate,
  }) async {
    BaseEntity<CourseChapterSetNext> entity = await setNextCourseChapter(
      progressId: _userProgress.id ?? 0,
      courseId: widget.courseId,
      chapterId: widget.chapterId,
      isUpdateProgress: isUpdate,
    );
    if (entity.data?.status != true) return;
    _nextCourseId = entity.data?.nextCourseid;
    _nextChapterId = entity.data?.nextChapterid;
  }

  /// 跳转页面
  _handleGoto(int stepIndex) {
    // 调整步骤顺序
    final stepSort = ToolsUtil.adjustmentStepSort(step: stepIndex);

    // 实例化工具类
    ToolsUtil toolsUtil = ToolsUtil();

    // 查找学习步骤=>对应的页面
    final CourseChapterStep courseChapterStepItem =
        toolsUtil.courseChapterStepData.firstWhere((stepItem) {
      return stepItem.index == stepSort;
    }, orElse: () => CourseChapterStep());
    if (courseChapterStepItem.route == null) return;

    // 跳转函数及参数
    Map<String, dynamic> args = {
      'courseId': _nextCourseId ?? widget.courseId,
      'chapterId': _nextChapterId ?? widget.chapterId,
      'isReviewWordTest': widget.isReviewWordTest,
      'isReview': widget.isReview,
      'courseType': widget.courseType ?? 1,
    };

    RoutesUtil.pushReplacement(
      context: context,
      routeName: courseChapterStepItem.route!,
      arguments: args,
    );
  }

  /// 跳转final页面
  _handleFinalGoto(String routeName) {
    // 跳转函数及参数
    Map<String, dynamic> args = {
      'courseId': _nextCourseId ?? widget.courseId,
      'chapterId': _nextChapterId ?? widget.chapterId,
      'isReviewWordTest': widget.isReviewWordTest,
      'isReview': widget.isReview,
      'courseType': widget.courseType ?? 1,
    };
    RoutesUtil.pushReplacement(
      context: context,
      routeName: routeName,
      arguments: args,
    );
  }

  /// 处理播放完成后的弹窗
  _handleShowVideoDialog({
    bool barrierDismissible = false,
  }) {
    if (_videoController == null) return;

    onShowVideoDialog(
      context: context,
      isHorizontal: _videoController.isFullScreen,
      barrierDismissible: barrierDismissible,

      // 退出全屏
      onExitFullScreen: () {
        _videoController.disableFullScreen(context);
        // 2秒后现调用弹窗
        Future.delayed(const Duration(seconds: 2), () {
          _handleShowVideoDialog();
        });
      },

      // 完成，下一步
      onFinish: () {
        _handleStudyNext();
      },

      // 重新播放
      onReplay: () {
        isShowDialog = false;
        // 视频播放重置
        _videoController.videoSeekTo(const Duration(seconds: 1));
        // 视频暂停
        _videoController.pause();
        // 视频播放
        _videoController.play();
        Future.delayed(const Duration(seconds: 2), () {
          isShowDialog = true;
        });
      },
    );
  }

  /// 处理添加学习时（10秒执行一次）
  _handleAddStudyTime() {
    _studyTotalTimer =
        Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      addStudyTime(limit: 10);
    });
  }

  /// 视频播放初始化
  /// [videoUrl] 视频的地址
  videoPlayInit({
    required String videoUrl,
  }) {
    // 使用正则获取视频的id
    final pattern = RegExp(r'\/video\/(\d+)');
    final match = pattern.firstMatch(videoUrl);
    final videoId = match?.group(1);
    if (videoId == null || videoId == '') return;

    final Map<String, String> headers = <String, String>{};
    headers['Authorization'] = 'Bearer ${Config.vimeo_access_token}';
    setState(() {
      _videoController = PodPlayerController(
        playVideoFrom: PlayVideoFrom.vimeoPrivateVideos(
          videoId,
          httpHeaders: headers,
        ),
      )..initialise();
      _videoLoading = false;
    });

    /// 节流 3秒钟只执行一次
    final throttledDoSomething = ToolsUtil.throttle(
      _handleShowVideoDialog,
      const Duration(seconds: 3),
    );

    // 视频监听函数（判断是否播放完成）
    const oneSecond = Duration(seconds: 1); // 1秒钟
    _videoController.addListener(() {
      // 剩余时间
      final timeRemaining = _videoController.totalVideoLength -
          _videoController.currentVideoPosition;
      if (timeRemaining <= oneSecond && isShowDialog) {
        throttledDoSomething();
      }
    });
  }

  /// 更新用户的付费学习进度（通知所有的provider）
  updateUserProgressModel() {
    Provider.of<UserProgressModel>(context, listen: false).setUserProgress(
      widget.courseType ?? 1,
    );
  }

  @override
  void initState() {
    super.initState();

    // 设置值
    setState(() {
      // 学习进度
      _userProgress = Provider.of<UserProgressModel>(context, listen: false)
          .getUserProgressData;
      // 课程章节详情信息
      _courseChapterInfo =
          Provider.of<CourseChapterDataModel>(context, listen: false)
              .getCourseChapterDataItem(widget.chapterId);
    });

    () async {
      bool isNoGoto = await _queryCourseInfo();
      if (isNoGoto) {
        _queryChapterProgress();
        _handleAddStudyTime();
        _handleCreateStudyConst();
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return StudyScaffold(
      appBarTitle: '视频课程${_courseChapterInfo?.isfinal == 1 ? '(Final)' : ''}',
      courseChapterName: _courseChapterInfo?.title ?? '-',
      drawerStepData: _stepData,
      bodyCenter: true,
      body: Container(
        color: AppColors.blackColor,
        child: _videoLoading == false
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PodVideoPlayer(controller: _videoController),
                  const SizedBox(height: 40),
                  YbButton(
                    text: '横向全屏播放',
                    icon: Icons.open_in_full,
                    borderColor: AppColors.whiteColor,
                    backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
                    circle: 50,
                    onPressed: () {
                      // 全屏
                      if (_videoController != null) {
                        _videoController.enableFullScreen();
                      }
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              )
            : const Text('视频加载中...'),
      ),
    );
  }

  @override
  void dispose() {
    // 如果视频控制器已经初始化，则释放资源
    if (_videoLoading == false) {
      _videoController?.dispose();
    }

    // 取消学习时长累计-定时器
    _studyTotalTimer?.cancel();

    // 取消学习历史-定时器
    _studyHistoryTimer?.cancel();

    // 更新学习历史
    _handleUpdateStudyConst();
    super.dispose();
  }
}
