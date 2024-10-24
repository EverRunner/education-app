import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/utils/tools_util.dart';
import 'package:yibei_app/utils/routes_util.dart';
import 'package:yibei_app/utils/cache_util.dart';
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
import 'package:yibei_app/models/course/course_test_list/course_test_list.dart';
import 'package:yibei_app/models/course/word_test_question_answer/word_test_question_answer.dart';
import 'package:yibei_app/models/course/submit_test_before_word/submit_test_before_word.dart';
import 'package:yibei_app/models/course/course_chapter_word_list/answer_list_item.dart';
import 'package:yibei_app/models/course/test_before_word/test_before_word.dart';
import 'package:yibei_app/models/course/test_before_word/answer_list.dart';

import 'package:yibei_app/provider/user_progress_model.dart';
import 'package:yibei_app/provider/course_chapter_data_model.dart';

import 'package:yibei_app/api/course.dart';
import 'package:yibei_app/api/user.dart';

/// final单词测试
class StudyWordFinalTestPage extends StatefulWidget {
  /// 课程id
  final int courseId;

  /// 章节id
  final int chapterId;

  // 课程类型
  final int? courseType;

  const StudyWordFinalTestPage({
    super.key,
    required this.courseId,
    required this.chapterId,
    this.courseType,
  });

  @override
  State<StudyWordFinalTestPage> createState() => _StudyWordFinalTestPageState();
}

class _StudyWordFinalTestPageState extends State<StudyWordFinalTestPage> {
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

    setState(() {
      // 步骤列表
      _stepData = toolsUtil.courseChapterFinalStepData;
    });

    // 调整步骤顺序
    _courseProgressStatus =
        ToolsUtil.adjustmentStepSort(step: entity.data?.data?.status ?? 0);
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
        category: 7, // 单元测试前关键词
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

  /// 完成final测试，进入下一步
  _handleStudyNext() async {
    // 3: 单元测试
    const int step = 3;
    _handleGoto(step);
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
      'courseType': widget.courseType ?? 1,
    };
    RoutesUtil.pushReplacement(
      context: context,
      routeName: courseChapterStepItem.route!,
      arguments: args,
    );
  }

  /// 获取关键词列表
  _queryCourseWordList() async {
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
    List<CourseChapterWordListItem> wordList = [];
    for (var item in entity.data?.dataList ?? []) {
      if (item.yibeiNewdcwordPaperConst.isNotEmpty &&
          item.yibeiNewdcwordPaperConst[0].yibeiNewdcwordPaperConstItem !=
              null) {
        var option =
            item.yibeiNewdcwordPaperConst[0].yibeiNewdcwordPaperConstItem;
        wordList.add(CourseChapterWordListItem(
          id: option.id,
          atitle: option.atitle,
          btitle: option.btitle,
        ));
      }
    }
    setState(() {
      _courseWordList = wordList;
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
    if (wordTestData == null || allAnswerData == null) return 1;

    // 整生成的关键词和答案
    List<TestBeforeWord> testBeforeList = [];
    wordTestData.asMap().forEach((index, topicItem) {
      List<AnswerList> answerList = [];
      for (var answerItem in topicItem.answerList ?? []) {
        answerList.add(
          AnswerList(
            id: answerItem.id,
            title: answerItem.title,
            iscorrectoption: answerItem.iscorrectoption,
          ),
        );
      }
      testBeforeList.add(
        TestBeforeWord(
          answer: allAnswerData[index],
          atitle: topicItem.atitle,
          btitle: topicItem.btitle,
          answerList: answerList,
        ),
      );
    });

    // 提交测前关键词及答题
    BaseEntity<WordTestQuestionAnswer> entityWord =
        await submitWordTestQuestionAnswer(
      title: '章节试题，测试前关键词',
      jsonString: json.encode(testBeforeList),
    );
    if (entityWord.data?.status != true || entityWord.data?.ordercode == null) {
      return 1;
    }

    // 提交final测前单词
    BaseEntity<SubmitTestBeforeWord> entity = await submitFinalTestWord(
      courseId: widget.courseId,
      chapterId: widget.chapterId,
      correctCount: correctCount,
      errorCount: allWordCount - correctCount,
      startDate: startDate,
      endTime: endTime,
      orderCode: entityWord.data!.ordercode!,
    );
    if (entity.data?.status != true) {
      return 1;
    }
    // 弹窗
    _handleShowWordTestDialog(
      correctCount: correctCount,
      allWordCount: allWordCount,
      rightLv: rightLv,
    );
    _handleUpdateStudyConst(
      testScore: rightLv,
      testFinishTime: endTime,
    );

    // final关键词测试通过时，写记录
    if (rightLv >= 90) {
      String? chapterPassIds =
          CacheUtils.instance.get<String>('finalWordPassIds');

      // 章节id集合
      List<String> chapterIds =
          chapterPassIds != null ? chapterPassIds.split(',') : [];
      chapterIds.add(widget.chapterId.toString());

      // 缓存数据
      CacheUtils.instance.set<String>('finalWordPassIds', chapterIds.join(','));
    }

    updateWordTime();
    updateUserProgressModel(); // provider 学习进度更新通知
  }

  /// 弹出结果
  _handleShowWordTestDialog({
    required int correctCount,
    required int allWordCount,
    required double rightLv,
  }) {
    onShowWordTestDialog(
      context: context,
      correctCount: correctCount,
      allWordCount: allWordCount,
      rightLv: rightLv,
      isFinal: true,
      onResetTest: () {
        _handleCreateStudyConst();
        _studyWordTestGlobalKey.currentState?.handleResetTest();
      },
      onGotoNext: () {
        _handleStudyNext();
      },
      onResetVideo: () {},
      onResetWord: () {},
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
      await _queryCourseWordList();
      _queryChapterProgress();
      _handleAddStudyTime();
      _handleCreateStudyConst();
    }();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StudyScaffold(
      appBarTitle: '关键词测试${_courseChapterInfo?.isfinal == 1 ? '(Final)' : ''}',
      courseChapterName: _courseChapterInfo?.title ?? '-',
      drawerStepData: _stepData,
      bodyPadding: 0,
      body: _courseWordList.isNotEmpty
          ? StudyWordTest(
              key: _studyWordTestGlobalKey,
              courseWordTestList: _courseWordList,
              courseWordCategory: 3, // 测前单词
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
