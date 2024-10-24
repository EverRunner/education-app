import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/utils/tools_util.dart';
import 'package:yibei_app/utils/routes_util.dart';
import 'components/study_scaffold.dart';
import 'components/study_test.dart';
import 'package:yibei_app/config/config.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/course/study_const/study_const.dart';
import 'package:yibei_app/models/course/user_progress/progress.dart';
import 'package:yibei_app/models/course/course_chapter_step/course_chapter_step.dart';
import 'package:yibei_app/models/course/course_chapter_data/course_chapter_data_item.dart';
import 'package:yibei_app/models/course/course_test_list/course_test_list.dart';
import 'package:yibei_app/models/course/course_test_list/course_test_list_item.dart';
import 'package:yibei_app/models/course/submit_request_list/submit_request_list.dart';
import 'package:yibei_app/models/course/course_request_info/course_request_info.dart';
import 'package:yibei_app/models/course/course_request_info/course_request_info_data.dart';
import 'package:yibei_app/models/course/my_error_questtest/my_error_questtest.dart';
import 'package:yibei_app/models/course/course_test_list/yibei_requestion_const.dart';
import 'package:yibei_app/models/course/course_compound_submit/course_compound_submit.dart';
import 'package:yibei_app/models/user/member_test_detail_log/member_test_detail_log_datum.dart';

import 'package:yibei_app/provider/test_detail_logs_model.dart';

import 'package:yibei_app/api/course.dart';
import 'package:yibei_app/api/user.dart';

// 单元测试
class StudyCompoundTestPage extends StatefulWidget {
  /// 课程id
  late int type;

  StudyCompoundTestPage(this.type, {Key? key}) : super(key: key);

  @override
  State<StudyCompoundTestPage> createState() => _StudyVideoPageState();
}

class _StudyVideoPageState extends State<StudyCompoundTestPage> {
  /// 课程章节详情信息
  late CourseChapterDataItem? _courseChapterInfo;

  /// 用户的学习进度
  late Progress _userProgress = Progress();

  // 步骤列表
  late List<CourseChapterStep> _stepData = [];

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

  /// 学习类型
  late int _studyType;

  /// 名称
  late String _chapterName;

  /// 提交的名称
  late String _submitTypeTitle;

  /// 应变测试id
  final int _strainsTestId = 138;

  /// 默认60分钟
  final int _testTime = 60 * 60;

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

  /// 更新综合测试、我的、高频错题测试记录（通知所有的provider）
  _updateTestDetailLogsModel() {
    Provider.of<TestDetailLogsModel>(context, listen: false)
        .setTestDetailLogs();
  }

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
    const double passScore = 0.9 * 100; // 通过分数
    final int status = (score >= passScore ? 1 : 2); // 1：测试通过 2：测试不通过

    _handleUpdateStudyConst(
      testScore: score,
      testFinishTime: endTime,
    );

    BaseEntity<CourseCompoundSubmit>? entity;
    switch (widget.type) {
      case 1:
        entity = await submitMyErrorTest(
          correctCount: correctCount,
          errorCount: errorCount,
          score: score,
          startDate: startDate,
          endTime: endTime,
          requestList: requestList,
          status: status,
        );
        break;
      case 2:
        entity = await submitHighErrorTest(
          correctCount: correctCount,
          errorCount: errorCount,
          score: score,
          startDate: startDate,
          endTime: endTime,
          requestList: requestList,
          status: status,
        );
        break;
      case 3:
        entity = await submitCompositeTest(
          correctCount: correctCount,
          errorCount: errorCount,
          score: score,
          startDate: startDate,
          endTime: endTime,
          requestList: requestList,
          status: status,
        );
        break;
      case 5:
        entity = await submitStrainsTest(
          correctCount: correctCount,
          errorCount: errorCount,
          score: score,
          startDate: startDate,
          endTime: endTime,
          requestList: requestList,
          status: status,
        );
        break;
    }

    if (entity == null || entity.data?.status != true) return 1;

    // 测试通过
    // if (status == 1) {
    // }

    // provider 更新通知
    _updateTestDetailLogsModel();

    // 跳转
    _handleGoto(
      testRequestId: entity.data?.data?.id ?? 0,
    );
  }

  /// 跳转页面
  /// [testRequestId] 测试记录的id
  _handleGoto({
    required int testRequestId,
  }) {
    // 跳转函数及参数
    Map<String, dynamic> args = {
      'type': widget.type,
      'testRequestId': testRequestId,
    };
    RoutesUtil.pushReplacement(
      context: context,
      routeName: AppRoutes.studyCompoundTestResultPage,
      arguments: args,
    );
  }

  /// 获取测试题列表 - 我的错题
  _queryMyErrorTestList() async {
    BaseEntity<MyErrorQuesttest> entity = await getErrorTestList(
      randomCount: Config.ERROR_RANDOM_TOPIC,
    );
    if (entity.data?.status != true || entity.data?.data == null) {
      return;
    }

    List<CourseTestListItem> testList = [];
    for (var item in entity.data?.data ?? []) {
      if (item.yibeiRequestionConst?.content != null &&
          item.yibeiRequestionConstOption.isNotEmpty) {
        testList.add(CourseTestListItem(
          requestionid: item?.requestid ?? item?.id,
          yibeiRequestionConst: item.yibeiRequestionConst,
          yibeiRequestionConstOption: item.yibeiRequestionConstOption,
        ));
      }
    }

    setState(() {
      _courseTestList = testList;
    });
  }

  /// 获取测试题列表 - 高频错题
  _queryHighErrorTestList() async {
    BaseEntity<MyErrorQuesttest> entity = await getHighErrorTestList(
      randomCount: Config.ERROR_RANDOM_TOPIC,
    );
    if (entity.data?.status != true || entity.data?.data == null) {
      return;
    }

    List<CourseTestListItem> testList = [];
    for (var item in entity.data?.data ?? []) {
      if (item.content != null && item.yibeiRequestionConstOption.isNotEmpty) {
        testList.add(CourseTestListItem(
          requestionid: item?.requestid ?? item?.id,
          yibeiRequestionConst: YibeiRequestionConst(
            content: item.content,
          ),
          yibeiRequestionConstOption: item.yibeiRequestionConstOption,
        ));
      }
    }
    setState(() {
      _courseTestList = testList;
    });
  }

  /// 获取测试题列表 - 综合测试
  _queryCompositeTestList() async {
    BaseEntity<MyErrorQuesttest> entity = await getCompositeTestList(
      randomCount: Config.ERROR_RANDOM_TOPIC,
    );
    if (entity.data?.status != true || entity.data?.data == null) {
      return;
    }

    List<CourseTestListItem> testList = [];
    for (var item in entity.data?.data ?? []) {
      if (item.content != null && item.yibeiRequestionConstOption.isNotEmpty) {
        testList.add(CourseTestListItem(
          requestionid: item?.requestid ?? item?.id,
          yibeiRequestionConst: YibeiRequestionConst(
            content: item.content,
          ),
          yibeiRequestionConstOption: item.yibeiRequestionConstOption,
        ));
      }
    }
    setState(() {
      _courseTestList = testList;
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

  /// 获取测试题列表 - 应变测试
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
    List<CourseTestListItem> captionArr = entity.data!.dataList!
        .where(
            (item) => item.yibeiRequestionConst?.title?.contains("图题") ?? false)
        .toList()
      ..shuffle();

    // 按一比例取出每个章节的题
    List<CourseTestListItem> resultList = [
      ...anatomyArr.take(25).toList(),
      ...treatmentArr.take(20).toList(),
      ...practiceArr.take(25).toList(),
      ...pathologyArr.take(25).toList(),
      ...ethicsArr.take(20).toList(),
      ...captionArr.take(15).toList(),
      // ...anatomyArr.take(2).toList(),
      // ...treatmentArr.take(2).toList(),
      // ...practiceArr.take(2).toList(),
      // ...pathologyArr.take(2).toList(),
      // ...ethicsArr.take(2).toList(),
      // ...captionArr.take(2).toList(),
    ];

    List<CourseTestListItem> testList = [];

    for (var item in resultList ?? []) {
      if (item.yibeiRequestionConst?.content != null &&
          item.yibeiRequestionConstOption.isNotEmpty) {
        testList.add(CourseTestListItem(
          requestionid: item?.requestid ?? item?.requestionid,
          yibeiRequestionConst: item.yibeiRequestionConst,
          yibeiRequestionConstOption: item.yibeiRequestionConstOption,
        ));
      }
    }

    setState(() {
      _courseTestList = testList;
    });
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
        _studyType = 9;
        _chapterName = '我的错题测试';
        _submitTypeTitle = '我的错题，测前关键词';
        _queryMyErrorTestList();
        break;
      case 2:
        _studyType = 11;
        _chapterName = '高频错题测试';
        _submitTypeTitle = '高频错题，测前关键词';
        _queryHighErrorTestList();
        break;
      case 3:
        _studyType = 13;
        _chapterName = '综合测试';
        _submitTypeTitle = '综合试题，测前关键词';
        _queryCompositeTestList();
        break;
      case 5:
        _studyType = 15;
        _chapterName = '应变测试';
        _submitTypeTitle = '应变测试，测前关键词';
        _queryStrainsTestInfo();
        break;
      default:
        _chapterName = '测试';
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
      appBarTitle: _chapterName,
      courseChapterName: _chapterName,
      bodyPadding: 0,
      body: _courseTestList.isNotEmpty && _testTime != null
          ? StudyTest(
              courseTestList: _courseTestList,
              testTime: _testTime,
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
