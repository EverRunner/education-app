import 'dart:async';
import 'package:flutter/material.dart';
import './components/study_word.dart';
import 'package:provider/provider.dart';
import './components/study_scaffold.dart';

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
import 'package:yibei_app/models/course/course_chapter_word_list/course_chapter_word_list.dart';
import 'package:yibei_app/models/course/course_chapter_word_list/course_chapter_word_list_item.dart';

import 'package:yibei_app/provider/user_progress_model.dart';
import 'package:yibei_app/provider/course_chapter_data_model.dart';

import 'package:yibei_app/api/course.dart';
import 'package:yibei_app/api/user.dart';
import 'package:pod_player/pod_player.dart';

/// 单词卡（英）
class StudyWordEnPage extends StatefulWidget {
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

  StudyWordEnPage(this.courseId, this.chapterId, this.isReviewWordTest,
      this.isReview, this.courseType,
      {Key? key})
      : super(key: key);

  @override
  State<StudyWordEnPage> createState() => _StudyWordEnPageState();
}

class _StudyWordEnPageState extends State<StudyWordEnPage> {
  /// 课程章节详情信息
  late CourseChapterDataItem? _courseChapterInfo;

  /// 用户的学习进度
  late Progress _userProgress = Progress();

  // 步骤列表
  late List<CourseChapterStep> _stepData = [];

  // 是否可以弹框的标识
  late bool isShowDialog = true;

  // 当前步骤的进度
  late int courseProgressStatus;

  /// 学习时长累计-定时器对象
  late Timer? _studyTotalTimer;

  /// 学习历史-定时器对象
  late Timer? _studyHistoryTimer;

  /// 学习历史id
  int? _studyHistoryId;

  late List<CourseChapterWordListItem> _courseWordList = [];

  /// 获取课程详情
  _queryCourseInfo() async {
    // 如果provider中没有课程详情，就从接口用去获取
    if (_courseChapterInfo == null) {
      // 设置值详情
      await Provider.of<CourseChapterDataModel>(context, listen: false)
          .setCourseChapterDataItem(chapterId: widget.chapterId);

      // 设置值
      setState(() {
        // 再次课程详情
        _courseChapterInfo =
            Provider.of<CourseChapterDataModel>(context, listen: false)
                .getCourseChapterDataItem(widget.chapterId);
      });
    }
  }

  /// 处理添加学习时（10秒执行一次）
  _handleAddStudyTime() {
    _studyTotalTimer =
        Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      addStudyTime(limit: 10);
    });
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
        category: 4, // 记单词（英）
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

  /// 完成关键词（中英）学习，进入下一步
  _handleStudyNext() async {
    // 5: 关键词（中英）测试
    const int step = 6;

    if (courseProgressStatus > 3) {
      _handleGoto(step);
    } else {
      final bool status = await _handleUpdateCourseChapterStep(step);
      if (status) {
        _handleGoto(step);
        updateUserProgressModel(); // provider 学习进度更新通知
      }
    }
  }

// 跳转页面
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
      'courseId': widget.courseId,
      'chapterId': widget.chapterId,
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

  /// 获取关键词列表
  /// [index] 0：中英文单词  1：英文单词
  _queryCourseWordList(int index) async {
    if (_courseChapterInfo?.dcwordsList?[index]?.dcwordspaperid == null) {
      return;
    }
    BaseEntity<CourseChapterWordList> entity = await getCourseChapterWordList(
      paperId: _courseChapterInfo!.dcwordsList![index].dcwordspaperid!,
    );
    if (entity.data?.status != true || entity.data?.data == null) {
      return;
    }
    setState(() {
      _courseWordList = entity.data!.data!;
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
      await _queryCourseInfo();
      await _queryCourseWordList(1);
      _queryChapterProgress();
      _handleAddStudyTime();
      _handleCreateStudyConst();
    }();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StudyScaffold(
        appBarTitle: '英文关键词卡',
        courseChapterName: _courseChapterInfo?.title ?? '-',
        drawerStepData: _stepData,
        body: StudyWord(
          courseWordList: _courseWordList,
          onFinish: _handleStudyNext,
        ));
  }

  @override
  void dispose() {
    // 取消学习时长累计-定时器
    _studyTotalTimer?.cancel();

    // 取消学习历史-定时器
    _studyHistoryTimer?.cancel();

    // 更新学习历史
    _handleUpdateStudyConst();
    super.dispose();
  }
}
