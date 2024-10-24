import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/components/common/yb_scaffold.dart';
import 'package:yibei_app/utils/tools_util.dart';
import './components/step_list.dart';
import 'package:yibei_app/provider/user_progress_model.dart';
import 'package:yibei_app/models/course/course_chapter_step/course_chapter_step.dart';
import 'package:yibei_app/models/course/user_progress/progress.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/user/user_chapter_study_log/user_chapter_study_log.dart';

import 'package:yibei_app/api/user.dart';
import 'package:yibei_app/utils/routes_util.dart';

// 学习步骤
class FreeStudyStepListPage extends StatefulWidget {
  FreeStudyStepListPage({Key? key}) : super(key: key);

  @override
  State<FreeStudyStepListPage> createState() => _FreeStudyStepListPageState();
}

class _FreeStudyStepListPageState extends State<FreeStudyStepListPage> {
  // 步骤列表
  List<CourseChapterStep> _stepData = [
    CourseChapterStep(
      index: 0,
      progress: 1,
      title: "解剖学简介",
      route: AppRoutes.studyVideo,
    ),
    CourseChapterStep(
      index: 0,
      progress: 0,
      title: "躯干骨骼",
      route: AppRoutes.studyVideo,
    ),
    CourseChapterStep(
      index: 1,
      progress: 0,
      title: "中英文关键词卡",
      route: AppRoutes.studyWordChEn,
    ),
    CourseChapterStep(
      index: 2,
      progress: 0,
      title: "中英文关键词测试",
      route: AppRoutes.studyWordTestChEn,
    ),
    CourseChapterStep(
      index: 3,
      progress: 0,
      title: "英文关键词卡",
      route: AppRoutes.studyWordEn,
    ),
    CourseChapterStep(
      index: 4,
      progress: 0,
      title: "英文关键词测试",
      route: AppRoutes.studyWordTestEn,
    ),
    CourseChapterStep(
      index: 5,
      progress: 0,
      title: "章节测试",
      route: AppRoutes.studyTest,
    ),
  ];

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

    // 免费课程进度（课程id：12 章节id：86、96 是体验课程）
    int courseId = 12;
    int chapterId = 96;

    if (title == '解剖学简介') {
      chapterId = 86;
    }

    // 跳转函数及参数
    Map<String, dynamic> args = {
      'courseId': courseId,
      'chapterId': chapterId,
      'isReviewWordTest': progress == 100 ? 1 : 0,
      'courseType': 0,
    };
    RoutesUtil.pushReplacement(
      context: context,
      routeName: routeName,
      arguments: args,
    );
  }

  // @override
  // void didUpdateWidget(FreeStudyStepListPage oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   // 更新_userProgress的值
  //   setState(() {
  //     // 学习进度
  //     _userProgress = Provider.of<UserProgressModel>(context, listen: false)
  //         .getUserProgressData;
  //   });
  // }

  /// 打开弹框解锁全部课程
  handleOpen() {
    onShowAlertDialog(
      context: context,
      title: '提示',
      detail: Container(
        padding: const EdgeInsets.only(
          top: 5,
          bottom: 10,
        ),
        child: const Text('解锁全部课程，帮您轻松通过联邦按摩！'),
      ),
      actions: [
        YbButton(
          text: '立即购买',
          circle: 20,
          onPressed: () {
            Navigator.pushNamed(
              context,
              AppRoutes.mineMyBuyPage,
            );
          },
        ),
        TextButton(
          child: const Text('关闭'),
          onPressed: () {
            Navigator.pop(context); // 关闭弹窗
          },
        ),
      ],
    );
  }

  /// 获取当前用户章节学习最近详细记录（体验课1）
  /// 免费课程进度（课程id：12 章节id：86、96 是体验课程）
  _queryUserChapterStudy() async {
    BaseEntity<UserChapterStudyLog> entity = await getUserChapterStudy(86);
    if (entity.data?.status != true) {
      return;
    }
    if (entity.data?.data != null && entity.data!.data!.isNotEmpty) {
      setState(() {
        if (entity.data!.data?[0].lastVideotime != null) {
          setState(() {
            _stepData[0].progress = 100;
            _stepData[1].progress = 1;
          });
        }
      });
    }
  }

  /// 获取当前用户章节学习最近详细记录（体验课2）
  _queryUserChapterStudyTwo() async {
    BaseEntity<UserChapterStudyLog> entity = await getUserChapterStudy(96);
    if (entity.data?.status != true) {
      return;
    }
    if (entity.data?.data != null && entity.data!.data!.isNotEmpty) {
      setState(() {
        if (entity.data!.data?[0].lastVideotime != null) {}
        if (entity.data!.data?[0].keywordStudyChen != null) {}
        if (entity.data!.data?[0].keywordTestChen != null) {}
        if (entity.data!.data?[0].keywordStudyEn != null) {}
        if (entity.data!.data?[0].keywordTestEn != null) {}
        if (entity.data!.data?[0].uniTestEn != null) {}
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // _queryUserChapterStudyTwo();
    _queryUserChapterStudy();
  }

  @override
  Widget build(BuildContext context) {
    // 学习进度
    _userProgress = Provider.of<UserProgressModel>(context, listen: true)
        .getUserProgressData;

    ToolsUtil.courseChapterStep(
      chapterProgress: _userProgress.status == 1 ? 100 : 0,
      chapterId: 0,
      currentCourseChapterId: 0,
      stepFlag: _userProgress.stepflag ?? 0,
      stepData: _stepData,
    );

    return YbScaffold(
      appBarTitle: '联邦按摩辅导课程（试听课）',
      body: Column(
        children: [
          StepList(
            data: _stepData,
            onButtonPressed: _handleGoto,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: YbButton(
              text: '解锁全部课程',
              circle: 20,
              icon: Icons.lock_open_outlined,
              onPressed: handleOpen,
            ),
          )
        ],
      ),
    );
  }
}
