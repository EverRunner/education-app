import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/utils/tools_util.dart';
import 'package:yibei_app/utils/routes_util.dart';
import 'components/study_scaffold.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'components/study_test.dart';
import 'package:yibei_app/utils/cache_util.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/course/study_const/study_const.dart';
import 'package:yibei_app/models/course/user_progress/progress.dart';
import 'package:yibei_app/models/course/course_chapter_step/course_chapter_step.dart';
import 'package:yibei_app/models/course/current_chapter_progress/current_chapter_progress.dart';
import 'package:yibei_app/models/course/course_chapter_data/course_chapter_data_item.dart';
import 'package:yibei_app/models/common/common_return_states/common_return_states.dart';
import 'package:yibei_app/models/course/course_test_list/course_test_list.dart';
import 'package:yibei_app/models/course/course_test_list/course_test_list_item.dart';
import 'package:yibei_app/models/course/submit_request_list/submit_request_list.dart';
import 'package:yibei_app/models/course/course_submit_test/course_submit_test.dart';
import 'package:yibei_app/models/course/course_request_info/course_request_info.dart';
import 'package:yibei_app/models/course/course_request_info/course_request_info_data.dart';
import 'package:yibei_app/models/course/course_chapter_set_next/course_chapter_set_next.dart';
import 'package:yibei_app/models/course/course_test_count/course_test_count.dart';
import 'package:yibei_app/models/course/course_test_list/course_test_list.dart';

import 'package:yibei_app/provider/user_progress_model.dart';
import 'package:yibei_app/provider/course_chapter_data_model.dart';

import 'package:yibei_app/api/course.dart';
import 'package:yibei_app/api/user.dart';

// 单元测试
class StudyTestPage extends StatefulWidget {
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

  StudyTestPage(this.courseId, this.chapterId, this.isReviewWordTest,
      this.isReview, this.courseType,
      {Key? key})
      : super(key: key);

  @override
  State<StudyTestPage> createState() => _StudyVideoPageState();
}

class _StudyVideoPageState extends State<StudyTestPage> {
  /// 课程章节详情信息
  late CourseChapterDataItem? _courseChapterInfo;

  /// 用户的学习进度
  late Progress _userProgress = Progress();

  // 步骤列表
  late List<CourseChapterStep> _stepData = [];

  // 当前步骤的进度
  late int _courseProgressStatus;

  /// 学习时长累计-定时器对象
  late Timer? _studyTotalTimer;

  /// 学习历史-定时器对象
  late Timer? _studyHistoryTimer;

  /// 学习历史id
  int? _studyHistoryId;

  // 单元测试列表
  List<CourseTestListItem> _courseTestList = [];

  // 课程详情
  late CourseRequestInfoData _courseTestInfo;

  // 下一节的课程id
  int _nextCourseId = 0;

  // 下一节的章节id
  int _nextChapterId = 0;

  /// 获取课程详情
  _queryCourseInfo() async {
    // 如果provider中没有课程详情，就从接口用去获取
    if (_courseChapterInfo == null) {
      // 设置值详情
      await Provider.of<CourseChapterDataModel>(context, listen: false)
          .setCourseChapterDataItem(chapterId: widget.chapterId);
      _queryChapterInfo();
    }
  }

  /// 章节详情
  _queryChapterInfo() {
    CourseChapterDataItem? chapterInfo =
        Provider.of<CourseChapterDataModel>(context, listen: false)
            .getCourseChapterDataItem(widget.chapterId);

    setState(() {
      _courseChapterInfo = chapterInfo;
    });
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

    setState(() {
      // 步骤列表
      _stepData = ToolsUtil.courseChapterStep(
        stepData: toolsUtil.courseChapterStepData,
        chapterProgress: entity.data?.data?.status == 4 ? 100 : 0,
        chapterId: widget.chapterId,
        currentCourseChapterId: widget.chapterId ?? 0,
        stepFlag: entity.data?.data?.status ?? 0,
      );
    });

    // 调整步骤顺序
    _courseProgressStatus =
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
        category: 6, // 单元测试
      );
      if (entity.data?.status == true && entity.data?.id != null) {
        _studyHistoryId = entity.data?.id;
      }
    });
  }

  /// 更新学习页面的停留信息及时间等
  _handleUpdateStudyConst({
    double? testScore,
    DateTime? testFinishTime,
  }) {
    if (_studyHistoryId == null) return;

    updateStudyConst(
      studyId: _studyHistoryId!,
      testScore: testScore,
      testFinishTime: testFinishTime,
    );
  }

  /// 获取测试信息
  Future<void> _queryCourseTestInfo() async {
    const int index = 0;
    if (_courseChapterInfo?.requestPaperList?[index].requestpaperid == null) {
      return;
    }
    BaseEntity<CourseRequestInfo> entity = await getCourseTestInfo(
      paperId: _courseChapterInfo!.requestPaperList![index].requestpaperid!,
    );
    if (entity.data?.status != true || entity.data?.data == null) {
      return;
    }
    setState(() {
      _courseTestInfo = entity.data!.data!;
    });
  }

  /// 删除Final章节的关键词是否己学习过
  Future<void> _handleFinalWordDelStudy() async {
    deleteCourseChapterOther(
      courseId: widget.courseId,
      chapterId: widget.chapterId,
    );
  }

  /// 更新用户的付费学习进度（通知所有的provider）
  _updateUserProgressModel() {
    Provider.of<UserProgressModel>(context, listen: false).setUserProgress(
      widget.courseType ?? 1,
    );
  }

  /// 获取单元测试列表
  _queryCourseTestList() async {
    const int index = 0;
    if (_courseChapterInfo?.requestPaperList?[index]?.requestpaperid == null) {
      return;
    }
    BaseEntity<CourseTestList> entity = await getCourseTestList(
      requestPaperId:
          _courseChapterInfo!.requestPaperList![index].requestpaperid!,
    );
    if (entity.data?.status != true || entity.data?.dataList == null) {
      return;
    }
    setState(() {
      _courseTestList = entity.data!.dataList!;
    });
  }

  /// 获取final 测试次数
  _queryCourseTestCount() async {
    BaseEntity<CourseTestCount> entity = await getCourseTestCount(
      courseId: widget.courseId,
      chapterId: widget.chapterId,
      progressId: _userProgress.id ?? 0,
    );

    // 三次没有通过“Final” 的提示
    if (_courseChapterInfo?.isfinal == 1) {
      _handleShowWordTestDialog(
        count: entity.data!.lefttestcount ?? 0,
      );
    }
  }

  /// 弹出结果
  _handleShowWordTestDialog({
    required int count,
  }) {
    onShowAlertDialog(
      context: context,
      title: '重要提示',
      detail: Column(
        mainAxisSize: MainAxisSize.min, // 垂直方向上自适应文本内容高度
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16.0, color: Colors.black),
              children: <TextSpan>[
                const TextSpan(
                  text: '请尽量在三次以内通过Final测试！您剩余',
                ),
                TextSpan(
                  text: '$count次',
                  style: const TextStyle(fontSize: 20.0, color: Colors.red),
                ),
                const TextSpan(
                  text: '机会！',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 修改课程进度状态
  /// -1:未开始 0：进行中 1：已完成
  Future<void> _handleUpdateCourseStatus(int status) async {
    await updateProgressCourseStatus(
      progressId: _userProgress.id ?? 0,
      courseId: widget.courseId,
      chapterId: widget.chapterId,
      status: status,
    );
  }

  /// 测试成功时，重置进度为下一章
  Future<void> _handleNextProgress() async {
    BaseEntity<CourseChapterSetNext> entity = await setNextCourseChapter(
      progressId: _userProgress.id ?? 0,
      courseId: widget.courseId,
      chapterId: widget.chapterId,
      isUpdateProgress: 1,
    );
    if (entity.data?.status != true) return;
    _nextCourseId = entity.data?.nextCourseid ?? 0;
    _nextChapterId = entity.data?.nextChapterid ?? 0;
  }

  /// 三次final不过，写记录
  Future<void> _handleThreeNoPassFinal() async {
    await updateThreeNoPassFinal(
      progressId: _userProgress.id ?? 0,
      courseId: widget.courseId,
      chapterId: widget.chapterId,
    );
  }

  /// 移除三次flnal不过记录
  // Future<void> _handleRemoveFinalError() async {
  //   await removeFinalError(
  //     courseId: widget.courseId,
  //     chapterId: widget.chapterId,
  //   );
  // }

  /// 重置本章所有学习-三次final不过写记录
  // Future<void> _handleSetCourseChapterStudy() async {
  //   await setCourseChapterStudy(
  //     courseId: widget.courseId,
  //     chapterId: widget.chapterId,
  //   );
  // }

  /// 3次final不过，将进度重置到某一课程的第一章
  // Future<void> _handleResetProgressToCourse() async {
  //   // 总学习进度中的课程id 大于 当前课程id时，直接return
  //   if ((_userProgress.currentcourseid ?? 0) > widget.courseId) {
  //     return;
  //   }

  //   await resetProgressToCourse(
  //     progressId: _userProgress.id ?? 0,
  //     courseId: widget.courseId,
  //   );
  // }

  /// 提交测试成绩
  Future<int?> _handleSubmit({
    required int correctCount,
    required int errorCount,
    required double score,
    required DateTime startDate,
    required List<SubmitRequestList> requestList,
  }) async {
    // 结束时间
    final DateTime endTime = DateTime.now();

    // 测试通过状态
    final double passScore = _courseTestInfo.qualifiedproportion! * 100; // 通过分数
    final int status = (score >= passScore ? 1 : 2); // 1：测试通过 2：测试不通过

    _handleUpdateStudyConst(
      testScore: score,
      testFinishTime: endTime,
    );

    BaseEntity<CourseSubmitTest> entity = await courseSubmitTest(
      progressId: _userProgress.id ?? 0,
      courseId: widget.courseId,
      chapterId: widget.chapterId,
      requestPaperId: _courseTestInfo.id ?? 0,
      correctCount: correctCount,
      errorCount: errorCount,
      score: score,
      startDate: startDate,
      endTime: endTime,
      isFinal: _courseChapterInfo?.isfinal ?? 0,
      requestList: requestList,
      status: status,
    );
    if (entity.data?.status != true) return 1;

    // 删除关键词记录
    await _handleFinalWordDelStudy();

    // 删除缓存的关键词测试记录
    _handleFinalWordTestRecordsRovme();

    if (status == 1) {
      // 测试通过
      await _handleStudyPass();
      // if (_courseChapterInfo?.isfinal == 1) await _handleRemoveFinalError();
    } else {
      // 如果是final章节
      if (_courseChapterInfo?.isfinal == 1) {
        // 答错3次，并且是final章节
        if (entity.data?.lefttestcount == 0) {
          // await _handleSetCourseChapterStudy();
          // await _handleResetProgressToCourse();
          // 三次final章节不过，写记录
          await _handleThreeNoPassFinal();
          // 学习通过
          await _handleStudyPass();
        }
      } else {
        // 答错2次，进度跳到单词
        if (entity.data?.lefttestcount == 1) {
          await _handleUpdateCourseChapterStep(1);
        }
        // 答错3次，进度跳到视频
        if (entity.data?.lefttestcount == 0) {
          await _handleUpdateCourseChapterStep(0);
        }
      }
    }

    // provider 学习进度更新通知
    await _updateUserProgressModel();

    // 跳转
    _handleGoto(
      leftTestCount: entity.data!.lefttestcount!,
      rank: entity.data!.rank!,
      isThreeErrorCount: entity.data!.isthreeerrorcount!,
      testRequestId: entity.data!.requestid!,
      passScore: passScore,
    );
  }

  /// 处理学习通过
  Future<void> _handleStudyPass() async {
    // 更新学习进度
    await _handleUpdateCourseChapterStep(4);

    // 下移章节，后台接口判断了是否下移，这里，在通过时调用就行了
    await _handleNextProgress();

    // 修改本节课程状态为完成
    await _handleUpdateCourseStatus(1);
  }

  /// 处理缓存中Fina关键词测试记录删险
  _handleFinalWordTestRecordsRovme() {
    String? chapterPassIds =
        CacheUtils.instance.get<String>('finalWordPassIds');

    // 章节id集合
    List<String> chapterIds =
        chapterPassIds != null ? chapterPassIds.split(',') : [];

    // 过滤数组中不等当前章节id的数据
    List<String> filteredChapterIds = chapterIds
        .where((number) => number != widget.chapterId.toString())
        .toList();

    // 缓存数据
    CacheUtils.instance
        .set<String>('finalWordPassIds', filteredChapterIds.join(','));
  }

  /// 跳转页面
  /// [leftTestCount] 剩余机会
  /// [rank] 排名
  /// [isThreeErrorCount] 是否答错3次及以上了 true：已错3次，false：还没有，可以继续测试
  /// [testRequestId] 测试记录的id
  /// [passScore] 通关分数
  _handleGoto({
    required int leftTestCount,
    required int rank,
    required bool isThreeErrorCount,
    required double passScore,
    required int testRequestId,
  }) {
    // 跳转函数及参数
    Map<String, dynamic> args = {
      'courseId': widget.courseId,
      'chapterId': widget.chapterId,
      'requestPaperId': _courseTestInfo.id,
      'leftTestCount': leftTestCount,
      'rank': rank,
      'isThreeErrorCount': isThreeErrorCount,
      'progressStatus': _userProgress.status ?? 0,
      'isFinal': _courseChapterInfo?.isfinal ?? 0,
      'passScore': passScore,
      'testRequestId': testRequestId,
      'isReview': widget.isReview,
      'isReviewWordTest': widget.isReviewWordTest,
      'nextCourseId': _nextCourseId,
      'nextChapterId': _nextChapterId,
    };
    RoutesUtil.pushReplacement(
      context: context,
      routeName: AppRoutes.studyTestResult,
      arguments: args,
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
      await _queryChapterProgress();
      await _queryCourseInfo();
      await _queryCourseTestInfo();
      await _queryCourseTestList();
      await _queryCourseTestCount();

      _handleAddStudyTime();
      _handleCreateStudyConst();
    }();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StudyScaffold(
      appBarTitle: '章节测试',
      bodyPadding: 0,
      body: _courseTestList.isNotEmpty && _courseTestInfo.timelimit != null
          ? StudyTest(
              courseTestList: _courseTestList,
              testTime: _courseTestInfo.timelimit! == 0
                  ? 15 * 60
                  : _courseTestInfo.timelimit! * 60,
              onSubmit: _handleSubmit,
            )
          : const Text(''),
      drawerStepData: _stepData,
    );
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
