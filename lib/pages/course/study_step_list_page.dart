import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

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
import 'package:yibei_app/utils/tools_util.dart';
import 'package:yibei_app/utils/routes_util.dart';
import 'components/study_scaffold.dart';
import 'components/study_test.dart';

// 学习步骤
class StudyStepListPage extends StatefulWidget {
  /// 课程id
  late int courseId;

  /// 章节id
  late int chapterId;

  /// 章节名称
  late String? chapterName;

  /// 章节进度
  late int chapterProgress;

  /// 步骤列表
  late String studyStep;

  StudyStepListPage(this.courseId, this.chapterId, this.chapterName,
      this.chapterProgress, this.studyStep,
      {Key? key})
      : super(key: key);

  @override
  State<StudyStepListPage> createState() => _StudyStepListPageState();
}

class _StudyStepListPageState extends State<StudyStepListPage> {
  // 步骤列表
  List<CourseChapterStep> _stepData = [];

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
    // 学习提示
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
    // 复习单元测试时的提示
    if (progress == 100 && index == 5) {
      return onShowAlertDialog(
        context: context,
        title: '您无法复习此内容',
        detail: Column(
          mainAxisSize: MainAxisSize.min, // 垂直方向上自适应文本内容高度
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '复习时，请先通过 步骤5 【英文关键词测试】',
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
      'isReviewWordTest': progress == 100 ? 1 : 0,
      'courseType': 1,
    };
    RoutesUtil.pushReplacement(
      context: context,
      routeName: routeName,
      arguments: args,
    );
  }

  /// 获取课程步骤列表
  _queryCourseChapterStep() {
    // 实例化工具类
    ToolsUtil toolsUtil = ToolsUtil();
    List<CourseChapterStep> stepData = toolsUtil.courseChapterStepData
        .map((stepDataItem) {
          if (widget.studyStep.contains(stepDataItem.index.toString())) {
            return stepDataItem;
          }
        })
        .whereType<CourseChapterStep>()
        .toList();

    setState(() {
      _stepData = ToolsUtil.courseChapterStep(
        stepData: stepData,
        chapterProgress: widget.chapterProgress,
        chapterId: widget.chapterId,
        currentCourseChapterId: _userProgress.currentcoursechapterid ?? 0,
        stepFlag: _userProgress.stepflag ?? 0,
      );
    });
  }

  // @override
  // void didUpdateWidget(StudyStepListPage oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   // 更新_userProgress的值
  //   setState(() {
  //     // 学习进度
  //     _userProgress = Provider.of<UserProgressModel>(context, listen: false)
  //         .getUserProgressData;
  //   });
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 学习进度
    _userProgress = Provider.of<UserProgressModel>(context, listen: true)
        .getUserProgressData;

    _queryCourseChapterStep();

    return YbScaffold(
      appBarTitle: widget.chapterName ?? 'chapter 1',
      body: StepList(
        data: _stepData,
        onButtonPressed: _handleGoto,
      ),
    );
  }
}
