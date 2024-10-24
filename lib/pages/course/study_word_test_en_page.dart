import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/utils/tools_util.dart';
import 'package:yibei_app/utils/routes_util.dart';
import './components/study_scaffold.dart';
import './components/study_word_test.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/course/study_const/study_const.dart';
import 'package:yibei_app/models/course/user_progress/progress.dart';
import 'package:yibei_app/models/course/course_chapter_step/course_chapter_step.dart';
import 'package:yibei_app/models/course/current_chapter_progress/current_chapter_progress.dart';
import 'package:yibei_app/models/course/course_chapter_data/course_chapter_data_item.dart';
import 'package:yibei_app/models/common/common_return_states/common_return_states.dart';
import 'package:yibei_app/models/course/course_chapter_word_list/course_chapter_word_list.dart';
import 'package:yibei_app/models/course/course_chapter_word_list/course_chapter_word_list_item.dart';
import 'package:yibei_app/models/course/course_chapter_word_test_result/course_chapter_word_test_result.dart';

import 'package:yibei_app/provider/user_progress_model.dart';
import 'package:yibei_app/provider/course_chapter_data_model.dart';

import 'package:yibei_app/api/course.dart';
import 'package:yibei_app/api/user.dart';

/// 关键词测试（英）
class StudyWordTestEnPage extends StatefulWidget {
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

  StudyWordTestEnPage(this.courseId, this.chapterId, this.isReviewWordTest,
      this.isReview, this.courseType,
      {Key? key})
      : super(key: key);

  @override
  State<StudyWordTestEnPage> createState() => _StudyWordTestEnPageState();
}

class _StudyWordTestEnPageState extends State<StudyWordTestEnPage> {
  /// 关键词测试
  GlobalKey<StudyWordTestState> _studyWordTestGlobalKey = GlobalKey();

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

  // 单词卡列表
  List<CourseChapterWordListItem> _courseWordList = [];

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
        category: 5, // 记单词（英）测试
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

  /// 完成关键词（英）测试，进入下一步
  _handleStudyNext() async {
    // 3: 单元测试
    const int step = 3;

    if (_courseProgressStatus > 4) {
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

  /// 提交单词测试
  Future<int?> _handleSubmit({
    required int useTime,
    required int correctCount,
    required int allWordCount,
    required double rightLv,
    required DateTime startDate,
    required DateTime endTime,
    List<CourseChapterWordListItem>? wordTestData,
    List<int>? allAnswerData,
  }) async {
    BaseEntity<CourseChapterWordTestResult> entity = await submitWordsTest(
      progressId: _userProgress.id ?? 0,
      courseId: widget.courseId,
      chapterId: widget.chapterId,
      category: 1, // 英文
      useTime: useTime,
      correctCount: correctCount,
      errorCount: allWordCount - correctCount,
      allWordCount: allWordCount,
      rightLv: rightLv,
      startDate: startDate,
      endTime: endTime,
    );
    if (entity.data?.status != true || entity.data?.errorCount == null) {
      return 1;
    }
    // 弹窗
    _handleShowWordTestDialog(
      testErrorCount: entity.data!.errorCount!,
      correctCount: correctCount,
      allWordCount: allWordCount,
      rightLv: rightLv,
      wordCategory: 1, // 英文
    );
    _handleUpdateStudyConst(
      testScore: rightLv,
      testFinishTime: endTime,
    );
    updateWordTime();
    updateUserProgressModel();
  }

  /// 弹出结果
  _handleShowWordTestDialog({
    required int testErrorCount,
    required int correctCount,
    required int allWordCount,
    required int wordCategory,
    required double rightLv,
  }) {
    onShowWordTestDialog(
      context: context,
      testErrorCount: testErrorCount,
      correctCount: correctCount,
      allWordCount: allWordCount,
      rightLv: rightLv,
      wordCategory: wordCategory,
      onResetTest: () {
        _handleCreateStudyConst();
        _studyWordTestGlobalKey.currentState?.handleResetTest();
      },
      onResetVideo: () async {
        // 重学视频
        if (_courseProgressStatus <= 4) {
          await _handleUpdateCourseChapterStep(0);
        }
      },
      onResetWord: () async {
        // 重学关键词（英）学习
        if (_courseProgressStatus <= 4) {
          await _handleUpdateCourseChapterStep(2);
        }
        _handleGoto(1);
      },
      onGotoNext: () {
        _handleStudyNext();
      },
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
      appBarTitle: '英文关键词测试',
      courseChapterName: _courseChapterInfo?.title ?? '-',
      drawerStepData: _stepData,
      bodyPadding: 0,
      body: _courseWordList.isNotEmpty
          ? StudyWordTest(
              key: _studyWordTestGlobalKey,
              courseWordTestList: _courseWordList,
              courseWordCategory: 1, // 英文
              onSubmit: _handleSubmit,
            )
          : const Text(''),
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
