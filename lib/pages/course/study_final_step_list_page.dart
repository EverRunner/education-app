import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:yibei_app/utils/cache_util.dart';

import 'package:yibei_app/utils/tools_util.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/routes/index.dart';

import 'package:yibei_app/components/common/yb_scaffold.dart';
import './components/step_list.dart';

import 'package:yibei_app/provider/user_progress_model.dart';
import 'package:yibei_app/models/course/course_chapter_step/course_chapter_step.dart';
import 'package:yibei_app/models/course/user_progress/progress.dart';

import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/utils/routes_util.dart';
import 'components/study_scaffold.dart';
import 'components/study_test.dart';
import 'package:yibei_app/models/user/member_test_detail_log/member_test_detail_log.dart';
import 'package:yibei_app/models/user/member_test_detail_log/member_test_detail_log_datum.dart';

import 'package:yibei_app/provider/test_detail_logs_model.dart';

// 学习步骤
class StudyFinalStepListPage extends StatefulWidget {
  /// 课程id
  late int? courseId;

  /// 章节id
  late int? chapterId;

  /// 章节名称
  late String? chapterName;

  /// 章节进度
  late int? chapterProgress;

  /// 类型 1：我的错题测试  2：高频错题测试  3：综合测试  5：应变测试
  int? type;

  StudyFinalStepListPage(this.courseId, this.chapterId, this.chapterName,
      this.chapterProgress, this.type,
      {Key? key})
      : super(key: key);

  @override
  State<StudyFinalStepListPage> createState() => _StudyFinalStepListPageState();
}

class _StudyFinalStepListPageState extends State<StudyFinalStepListPage> {
  // 步骤列表
  List<CourseChapterStep> _finalStepData = [];

  /// 用户的学习进度
  late Progress _userProgress = Progress();

  /// 处理跳转
  _handleGoto(
    BuildContext context,
    int index,
    int progress,
    String routeName,
    String? title,
  ) async {
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

    // 跳转函数及参数
    Map<String, dynamic> args = {
      'courseId': widget.courseId,
      'chapterId': widget.chapterId,
      'courseType': 1,
    };
    RoutesUtil.pushReplacement(
      context: context,
      routeName: routeName,
      arguments: args,
    );
  }

  /// 处理跳转-综合测试
  _handleTestGoto(
    BuildContext context,
    int index,
    int progress,
    String routeName,
    String? title,
  ) async {
    // 复习单元测试时的提示
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

    // 跳转函数及参数
    Map<String, dynamic> args = {
      'type': widget.type,
      'courseType': 1,
    };
    RoutesUtil.pushReplacement(
      context: context,
      routeName: index == 4
          ? AppRoutes.studyCompoundWordTestPage
          : AppRoutes.studyCompoundTestPage,
      arguments: args,
    );
  }

  /// 获取课程步骤列表
  _queryCourseChapterStep() async {
    // for (var item in ToolsUtil.courseChapterFinalStepData) {}

    // 实例化工具类
    ToolsUtil toolsUtil = ToolsUtil();

    setState(() {
      // fnial 步骤列表
      if (widget.type == null) {
        // 获取缓存中已通过的final关键测试id
        String chapterPassIds =
            CacheUtils.instance.get<String>('finalWordPassIds') ?? '';

        _finalStepData = toolsUtil.courseChapterFinalStepData.map((item) {
          // 缓存中如果有此章节id，就修改进度
          if (chapterPassIds.contains('${widget.chapterId}')) {
            // ---关键词测试---
            if (item.index == 4) {
              item.progress = 100;
            }
            // ---章节测试---
            if (item.index == 6) {
              item.progress = 1;
            }
          }

          return item;
        }).toList();
      } else {
        // 我的错误题、高频错题、综合测试、应变测试步骤列表
        MemberTestDetailLogDatum result =
            Provider.of<TestDetailLogsModel>(context, listen: false)
                .getTestDetailLogs;
        _finalStepData = toolsUtil.courseChapterFinalStepData.map((item) {
          // ---关键词测试---
          if (item.index == 4) {
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
          if (item.index == 6) {
            // 我的错误题
            if (widget.type == 1) {
              if (result.errorTestbeforekeywordTime != null) {
                item.progress = 1;
              }
              if (result.errorTestScore != null &&
                  result.errorTestScore! >= 0.9) {
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
    });
  }

  /// 跳转，带有逻辑
  handleButtonPressed() {}

  @override
  void didUpdateWidget(StudyFinalStepListPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 更新_userProgress的值
    setState(() {
      // 学习进度
      _userProgress = Provider.of<UserProgressModel>(context, listen: false)
          .getUserProgressData;
    });
  }

  @override
  void initState() {
    super.initState();

    // 设置值
    setState(() {
      // 学习进度
      _userProgress = Provider.of<UserProgressModel>(context, listen: false)
          .getUserProgressData;
    });
    _queryCourseChapterStep();
  }

  @override
  Widget build(BuildContext context) {
    return YbScaffold(
      appBarTitle: '${widget.chapterName}' ?? 'chapter 1',
      body: StepList(
        data: _finalStepData,
        onButtonPressed: widget.type != null ? _handleTestGoto : _handleGoto,
      ),
    );
  }
}
