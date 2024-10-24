import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/config/config.dart';
import 'package:yibei_app/utils/routes_util.dart';
import 'package:yibei_app/utils/tools_util.dart';
import './components/study_scaffold.dart';
import './components/study_word_test.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/course/study_const/study_const.dart';
import 'package:yibei_app/models/course/course_chapter_step/course_chapter_step.dart';
import 'package:yibei_app/models/course/course_chapter_word_list/course_chapter_word_list_item.dart';
import 'package:yibei_app/models/course/my_error_questtest/my_error_questtest.dart';
import 'package:yibei_app/models/course/test_before_word/test_before_word.dart';
import 'package:yibei_app/models/course/test_before_word/answer_list.dart';
import 'package:yibei_app/models/course/word_test_question_answer/word_test_question_answer.dart';
import 'package:yibei_app/models/course/submit_test_before_word/submit_test_before_word.dart';
import 'package:yibei_app/models/course/course_request_info/course_request_info.dart';
import 'package:yibei_app/models/course/course_test_list/course_test_list.dart';
import 'package:yibei_app/models/course/course_test_list/course_test_list_item.dart';
import 'package:yibei_app/models/user/member_test_detail_log/member_test_detail_log_datum.dart';

import 'package:yibei_app/provider/test_detail_logs_model.dart';

import 'package:yibei_app/api/course.dart';
import 'package:yibei_app/api/user.dart';

/// 综合测试、我的错题、高频测试、应变测试，关键词测试
class StudyCompoundWordTestPage extends StatefulWidget {
  /// 类型 1：我的错题测试  2：高频错题测试  3：综合测试
  late int type;

  StudyCompoundWordTestPage(this.type, {Key? key}) : super(key: key);

  @override
  State<StudyCompoundWordTestPage> createState() =>
      _StudyCompoundWordTestPageState();
}

class _StudyCompoundWordTestPageState extends State<StudyCompoundWordTestPage> {
  /// 关键词测试
  GlobalKey<StudyWordTestState> _studyWordTestGlobalKey = GlobalKey();

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

  /// 学习类型
  late int _studyType;

  /// 名称
  late String _chapterName;

  /// 提交的名称
  late String _submitTypeTitle;

  /// 应变测试id
  int _strainsTestId = 138;

  /// 处理添加学习时（10秒执行一次）
  _handleAddStudyTime() {
    _studyTotalTimer =
        Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      addStudyTime(limit: 10);
    });
  }

  /// 创建学习页面的停留信息及时间等
  /// 1:视频  2:记单词（中英） 3:记单词（中英）测试   4:记单词（英）  5：记单词（中英）测试   6:单元测试   7.单元测试前关键词
  /// 8:我的错题（测前单词） 9:我的错题测试   10:高频错题（测前单词）  11:高频错题测试  12:综合题（测前单词）  13:综合题测试  14:应变测试（测前单词）  15:应变测试
  _handleCreateStudyConst() {
    _studyHistoryTimer = Timer(const Duration(seconds: 20), () async {
      // 取消延时时
      _studyHistoryTimer?.cancel();

      BaseEntity<StudyConst> entity = await createStudyConst(
        courseId: 0,
        chapterId: 0,
        category: _studyType,
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

  /// 完成关键词测试，
  _handleStudyNext() async {
    // 跳转函数及参数
    Map<String, dynamic> args = {
      'type': widget.type,
    };
    RoutesUtil.pushReplacement(
      context: context,
      routeName: AppRoutes.studyCompoundTestPage,
      arguments: args,
    );
  }

  /// 获取关键词列表 - 我的错题
  _queryMyErrorTestList() async {
    BaseEntity<MyErrorQuesttest> entity = await getErrorTestList(
      randomCount: Config.ERROR_RANDOM_TOPIC,
    );
    if (entity.data?.status != true || entity.data?.data == null) {
      return;
    }

    List<CourseChapterWordListItem> wordList = [];
    for (var item in entity.data?.data ?? []) {
      if (item.yibeiNewdcwordPaperConst.isNotEmpty &&
          item.yibeiNewdcwordPaperConst.length >= 1 &&
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

  /// 获取关键词列表 - 高频错题
  _queryHighErrorTestList() async {
    BaseEntity<MyErrorQuesttest> entity = await getHighErrorTestList(
      randomCount: Config.ERROR_RANDOM_TOPIC,
    );
    if (entity.data?.status != true || entity.data?.data == null) {
      return;
    }

    List<CourseChapterWordListItem> wordList = [];
    for (var item in entity.data?.data ?? []) {
      if (item.yibeiNewdcwordPaperConst.isNotEmpty &&
          item.yibeiNewdcwordPaperConst.length >= 1 &&
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

  /// 获取关键词列表 - 综合测试
  _queryCompositeTestList() async {
    BaseEntity<MyErrorQuesttest> entity = await getCompositeTestList(
      randomCount: Config.ERROR_RANDOM_TOPIC,
    );
    if (entity.data?.status != true || entity.data?.data == null) {
      return;
    }

    List<CourseChapterWordListItem> wordList = [];
    for (var item in entity.data?.data ?? []) {
      if (item.yibeiNewdcwordPaperConst.isNotEmpty &&
          item.yibeiNewdcwordPaperConst.length >= 1 &&
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

  /// 获取信息 - 应变测试
  Future<void> _queryStrainsTestInfo() async {
    BaseEntity<CourseRequestInfo> entity = await getCourseTestInfo(
      paperId: _strainsTestId,
    );
    if (entity.data?.status != true || entity.data?.data == null) {
      return;
    }

    _queryStrainsTestList();
  }

  /// 获取关键词列表 - 应变测试
  _queryStrainsTestList() async {
    BaseEntity<CourseTestList> entity = await getCourseTestList(
      requestPaperId: _strainsTestId,
    );
    if (entity.data?.status != true || entity.data?.dataList == null) {
      return;
    }

    List<CourseTestListItem> anatomyArr = entity.data!.dataList!
        .where((item) =>
            item.yibeiRequestionConst?.title?.contains("解剖与机能") ?? false)
        .toList()
      ..shuffle();
    List<CourseTestListItem> treatmentArr = entity.data!.dataList!
        .where((item) =>
            item.yibeiRequestionConst?.title?.contains("评估与治疗") ?? false)
        .toList()
      ..shuffle();
    List<CourseTestListItem> practiceArr = entity.data!.dataList!
        .where((item) =>
            item.yibeiRequestionConst?.title?.contains("手法与实践") ?? false)
        .toList()
      ..shuffle();
    List<CourseTestListItem> pathologyArr = entity.data!.dataList!
        .where((item) =>
            item.yibeiRequestionConst?.title?.contains("病理与禁忌") ?? false)
        .toList()
      ..shuffle();
    List<CourseTestListItem> ethicsArr = entity.data!.dataList!
        .where((item) =>
            item.yibeiRequestionConst?.title?.contains("专业与道德") ?? false)
        .toList()
      ..shuffle();
    // List<CourseTestListItem> captionArr = entity.data!.dataList!
    //     .where(
    //         (item) => item.yibeiRequestionConst?.title?.contains("图题") ?? false)
    //     .toList()
    //   ..shuffle();

    // 按一比例取出每个章节的题 (单词比较少，所有给了150道)
    List<CourseTestListItem> resultList = [
      ...anatomyArr.take(30).toList(),
      ...treatmentArr.take(30).toList(),
      ...practiceArr.take(30).toList(),
      ...pathologyArr.take(30).toList(),
      ...ethicsArr.take(30).toList(),
      // ...captionArr.take(10).toList(),
    ];

    List<CourseChapterWordListItem> wordList = [];
    for (var item in resultList ?? []) {
      if (item.yibeiNewdcwordPaperConst.isNotEmpty &&
          item.yibeiNewdcwordPaperConst.length >= 1 &&
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

  /// 更新综合测试、我的、高频错题测试记录（通知所有的provider）
  _updateUserProgressModel() {
    Provider.of<TestDetailLogsModel>(context, listen: false)
        .setTestDetailLogs();
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
      title: _submitTypeTitle,
      jsonString: json.encode(testBeforeList),
    );
    if (entityWord.data?.status != true || entityWord.data?.ordercode == null) {
      return 1;
    }

    switch (widget.type) {
      case 1:
        // 提交测前单词 - 我的错题
        BaseEntity<SubmitTestBeforeWord> entity = await submitMyErrorWordsTest(
          correctCount: correctCount,
          errorCount: allWordCount - correctCount,
          startDate: startDate,
          endTime: endTime,
          score: rightLv,
          orderCode: entityWord.data!.ordercode!,
        );
        if (entity.data?.status != true) {
          return 1;
        }
        break;
      case 2:
        // 提交测前单词 - 高频错题
        BaseEntity<SubmitTestBeforeWord> entity =
            await submitHighErrorWordsTest(
          correctCount: correctCount,
          errorCount: allWordCount - correctCount,
          startDate: startDate,
          endTime: endTime,
          score: rightLv,
          orderCode: entityWord.data!.ordercode!,
        );
        if (entity.data?.status != true) {
          return 1;
        }
        break;
      case 3:
        // 提交测前单词 - 综合测试
        BaseEntity<SubmitTestBeforeWord> entity =
            await submitCompositeWordsTest(
          correctCount: correctCount,
          errorCount: allWordCount - correctCount,
          startDate: startDate,
          endTime: endTime,
          score: rightLv,
          orderCode: entityWord.data!.ordercode!,
        );
        if (entity.data?.status != true) {
          return 1;
        }
        break;
      case 5:
        // 提交测前单词 - 应变测试
        BaseEntity<SubmitTestBeforeWord> entity = await submitStrainsWordsTest(
          correctCount: correctCount,
          errorCount: allWordCount - correctCount,
          startDate: startDate,
          endTime: endTime,
          score: rightLv,
          orderCode: entityWord.data!.ordercode!,
        );
        if (entity.data?.status != true) {
          return 1;
        }
        break;
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
    updateWordTime();
    _updateUserProgressModel();
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
      buttonText: '前往$_chapterName',
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

  /// 处理步骤列表
  List<CourseChapterStep> _handleStepList(MemberTestDetailLogDatum result) {
    // 实例化工具类
    ToolsUtil toolsUtil = ToolsUtil();

    return toolsUtil.courseCompoundStepData.map((item) {
      // ---关键词---
      if (item.index == 4) {
        item.title = _submitTypeTitle;
        // 我的错误题
        if (widget.type == 1) {
          if (result.errorTestbeforekeywordTime != null) {
            item.progress = 100;
          }
        }
        // 高频错题
        if (widget.type == 2) {
          if (result.gaopingTestbeforekeywordTime != null) {
            item.progress = 100;
          }
        }
        // 综合测试
        if (widget.type == 3) {
          if (result.zongheTestbeforekeywordTime != null) {
            item.progress = 100;
          }
        }
        // 应变测试
        if (widget.type == 4) {
          if (result.strainTestbeforekeywordTime != null) {
            item.progress = 100;
          }
        }
      }
      // ---章节测试---
      if (item.index == 5) {
        item.title = _chapterName;
        // 我的错误题
        if (widget.type == 1) {
          if (result.errorTestbeforekeywordTime != null) {
            item.progress = 1;
          }
          if (result.errorTestScore != null && result.errorTestScore! >= 0.9) {
            item.progress = 100;
          }
        }
        // 高频错题
        if (widget.type == 2) {
          if (result.gaopingTestbeforekeywordTime != null) {
            item.progress = 1;
          }
          if (result.gaopingTestbeforewordScore != null &&
              result.gaopingTestbeforewordScore! >= 0.9) {
            item.progress = 100;
          }
        }
        // 综合测试
        if (widget.type == 3) {
          if (result.zongheTestbeforekeywordTime != null) {
            item.progress = 1;
          }
          if (result.zongheTestbeforewordScore != null &&
              result.zongheTestbeforewordScore! >= 0.9) {
            item.progress = 100;
          }
        }
        // 应变测试
        if (widget.type == 5) {
          if (result.strainTestbeforekeywordTime != null) {
            item.progress = 1;
          }
          if (result.strainTestbeforewordScore != null &&
              result.strainTestbeforewordScore! >= 0.9) {
            item.progress = 100;
          }
        }
      }
      return item;
    }).toList();
  }

  @override
  void initState() {
    // 关键词测试历史的类型
    switch (widget.type) {
      case 1:
        _studyType = 8;
        _chapterName = '我的错题测试';
        _submitTypeTitle = '我的错题，测前关键词';
        _queryMyErrorTestList();
        break;
      case 2:
        _studyType = 10;
        _chapterName = '高频错题测试';
        _submitTypeTitle = '高频错题，测前关键词';
        _queryHighErrorTestList();
        break;
      case 3:
        _studyType = 12;
        _chapterName = '综合测试';
        _submitTypeTitle = '综合试题，测前关键词';
        _queryCompositeTestList();
        break;
      case 5:
        _studyType = 14;
        _chapterName = '应变测试';
        _submitTypeTitle = '应变测试，测前关键词';
        _queryStrainsTestInfo();
        break;
      default:
        _chapterName = '前往测试';
    }

    _handleAddStudyTime();
    _handleCreateStudyConst();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 测试记录
    MemberTestDetailLogDatum result =
        Provider.of<TestDetailLogsModel>(context, listen: false)
            .getTestDetailLogs;

    // 步骤列表
    _stepData = _handleStepList(result);

    return StudyScaffold(
      appBarTitle: _submitTypeTitle,
      courseChapterName: _submitTypeTitle,
      drawerStepData: _stepData,
      bodyPadding: 0,
      body: _courseWordList.isNotEmpty
          ? StudyWordTest(
              key: _studyWordTestGlobalKey,
              courseWordTestList: _courseWordList,
              courseWordCategory: 1, // 测试前单词
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
