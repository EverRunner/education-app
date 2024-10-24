import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yibei_app/utils/toast_util.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/utils/tools_util.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/routes/index.dart';
import './components/chapter_list.dart';
import 'package:yibei_app/components/common/yb_scaffold.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/course/course_chapter_tree/course_chapter_tree.dart';
import 'package:yibei_app/models/course/course_chapter_tree/yibei_course_chapter.dart';
import 'package:yibei_app/models/course/course_list_data/course_list_data.dart';
import 'package:yibei_app/models/course/user_progress/user_progress.dart';
import 'package:yibei_app/models/course/user_progress/progress.dart';
import 'package:yibei_app/models/course/course_chapter_tree/data_list.dart';
import 'package:yibei_app/models/user/member_test_detail_log/member_test_detail_log.dart';
import 'package:yibei_app/models/user/member_test_detail_log/member_test_detail_log_datum.dart';

import 'package:yibei_app/provider/user_progress_model.dart';
import 'package:yibei_app/provider/course_chapter_tree_model.dart';
import 'package:yibei_app/provider/test_detail_logs_model.dart';

import 'package:yibei_app/api/user.dart';

// 章节列表页
class ChapterListPage extends StatefulWidget {
  /// 课程id
  late int courseId;

  ChapterListPage(this.courseId, {Key? key}) : super(key: key);

  @override
  State<ChapterListPage> createState() => _ChapterListPageState();
}

class _ChapterListPageState extends State<ChapterListPage> {
  /// 综合测试-章节列表
  List<CourseListData> _chapterTestData = [
    CourseListData(
      id: 1,
      title: '我的错题测试（100道/次）',
      progress: 0,
      isFinal: 0,
      type: 1,
    ),
    CourseListData(
      id: 2,
      title: '高频错题测试（100道/次）',
      progress: 0,
      isFinal: 0,
      type: 2,
    ),
    CourseListData(
      id: 3,
      title: '综合题测试（100道/次）',
      progress: 0,
      isFinal: 0,
      type: 3,
    ),
  ];

  /// 章节列表
  late List<CourseListData> _chapterData = [];

  /// 课程列表、章节列表
  late List<DataList> _courseChapterList = [];

  /// 用户的学习进度
  late Progress _userProgress = Progress();

  /// 课程名字
  late String _courseName;

  /// 获取课程列表
  _queryCourseChapterTree() async {
    // 全部学习完成时候
    if (_userProgress.status == 1) {}

    int nowIsStudy = 1; // 当前是否学习过
    List<CourseListData> chapterList = []; // 课程列表

    for (var courseData in _courseChapterList) {
      // 当前课程
      if (courseData.id == widget.courseId) {
        setState(() {
          _courseName = courseData.title ?? '-';
        });
        // 遍历所有章节
        for (var chapterData in courseData.yibeiCourseChapter ?? []) {
          var newChapterData = CourseListData(
            id: chapterData.id,
            progress: 0,
            title: chapterData.title
                ?.replaceAll(courseData.title, '')
                .replaceAll('《解剖与机能》', ''),
            isFinal: chapterData.isfinal,
            studyStep: chapterData.studystep,
          );

          // 获取当前章节下的学习步骤列表
          List<String> studyStepList = chapterData.studystep != ''
              ? chapterData.studystep.split(",")
              : [];

          // 进度百分比 100除以步骤长度，约等于 14.28 ，共有6+1个步骤
          double percentPercent = double.parse(
              (100 / (studyStepList.length + 1)).toStringAsFixed(1));

          // 查找当前在学的章节
          if (chapterData.id == _userProgress.currentcoursechapterid) {
            int stepFlag =
                ToolsUtil.adjustmentStepSort(step: _userProgress.stepflag ?? 0);
            nowIsStudy = 0;
            newChapterData.progress =
                ((stepFlag <= 1 ? 1 : stepFlag) * 14.28).round();
          }
          // 已经学课程
          if (_userProgress.status == 1 ||
              (nowIsStudy == 1 &&
                  widget.courseId <= _userProgress.currentcourseid!)) {
            newChapterData.progress = 100;
          }
          // 添加章节列表
          chapterList.add(newChapterData);
        }
      }
    }

    setState(() {
      _chapterData = chapterList;
    });
  }

  /// 获取综合测试、我的错题、高频错题的记录
  _queryChapterTestLog() async {
    MemberTestDetailLogDatum result =
        Provider.of<TestDetailLogsModel>(context, listen: false)
            .getTestDetailLogs;

    setState(() {
      _chapterTestData = _chapterTestData.map((item) {
        // 我的错误题
        if (item.id == 1) {
          if (result.errorTestbeforekeywordTime != null) {
            item.progress = 50;
          } else {
            item.progress = 1;
          }
          if (result.errorTestScore != null) {
            item.progress = 100;
          }
        }
        // 高频错题
        if (item.id == 2) {
          if (result.gaopingTestbeforekeywordTime != null) {
            item.progress = 50;
          } else {
            item.progress = 1;
          }
          if (result.gaopingTestbeforewordScore != null) {
            item.progress = 100;
          }
        }
        // 综合测试
        if (item.id == 3) {
          if (result.zongheTestbeforekeywordTime != null) {
            item.progress = 50;
          } else {
            item.progress = 1;
          }
          if (result.zongheTestbeforewordScore != null) {
            item.progress = 100;
          }
        }
        return item;
      }).toList();
    });
  }

  /// 获取应变测试的记录
  _queryChapterStrainsTestLog() async {
    MemberTestDetailLogDatum result =
        Provider.of<TestDetailLogsModel>(context, listen: false)
            .getTestDetailLogs;

    CourseListData courseListItem = CourseListData(
      id: 5,
      title: '应变题测试（100道/次）',
      progress: 0,
      isFinal: 0,
      type: 5,
    );

    // 应变测试
    if (courseListItem.id == 5) {
      if (result.strainTestbeforekeywordTime != null) {
        courseListItem.progress = 50;
      } else {
        courseListItem.progress = 1;
      }
      if (result.strainTestbeforewordScore != null) {
        courseListItem.progress = 100;
      }
    }

    setState(() {
      _chapterTestData = [courseListItem];
    });
  }

  /// 处理跳转
  _handleGoto(
    BuildContext context,
    int chapterId,
    int progress,
    String name,
    int isFinal,
    String? studyStep,
    int? type,
  ) {
    if (progress <= 0) {
      return onShowAlertDialog(
        context: context,
        title: '您无法学习此内容',
        detail: Column(
          mainAxisSize: MainAxisSize.min, // 垂直方向上自适应文本内容高度
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '您暂未学习完成前面的课程，请完成后再回来学习此内容。',
              style: TextStyle(
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    // 如果是final
    Navigator.pushNamed(
      context,
      isFinal == 1 || type != null
          ? AppRoutes.studyFinalStepList
          : AppRoutes.studyStepList,
      arguments: {
        'courseId': widget.courseId,
        'chapterId': chapterId,
        'chapterName': name,
        'chapterProgress': progress,
        'studyStep': studyStep,
        'type': type,
      },
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.courseId == -100) {
      setState(() {
        _courseName = '综合测评';
      });
    }
    if (widget.courseId == -200) {
      setState(() {
        _courseName = '应变测试';
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var userProgress = Provider.of<UserProgressModel>(context, listen: true)
        .getUserProgressData;

    // 全部学习已完成
    if (userProgress.status == 1) {
      // 综合测试
      if (widget.courseId == -100) {
        _queryChapterTestLog();
      }
      // 应变测试
      if (widget.courseId == -200) {
        _queryChapterStrainsTestLog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // provider中的数据，课程列表、章节列表
    _courseChapterList =
        Provider.of<CourseChapterTreeModel>(context, listen: true)
            .getCourseChapterList;
    // provider中的数据，学习进度
    _userProgress = Provider.of<UserProgressModel>(context, listen: true)
        .getUserProgressData;

    // 不为综合测试、应变测试时
    if (widget.courseId != -100 && widget.courseId != -200) {
      _queryCourseChapterTree();
    }

    return YbScaffold(
      appBarTitle: _courseName,
      body: ChapterList(
        data: widget.courseId == -100 || widget.courseId == -200
            ? _chapterTestData
            : _chapterData,
        onButtonPressed: _handleGoto,
      ),
    );
  }
}
