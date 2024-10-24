import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/components/chart/yb_radar_chart.dart';
import 'package:yibei_app/utils/cache_util.dart';
import 'package:yibei_app/config/config.dart';
import 'package:yibei_app/utils/tools_util.dart';

import 'package:yibei_app/models/user/login_user_info/user_info.dart';
import 'package:yibei_app/models/user/week_study_statics/week_study_statics.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/user/login_user_info/login_user_info.dart';
import 'package:yibei_app/models/course/course_chapter_tree/data_list.dart';
import 'package:yibei_app/models/course/user_progress/user_progress.dart';
import 'package:yibei_app/models/course/user_progress/progress.dart';
import 'package:yibei_app/models/common/common_return_states/common_return_states.dart';
import 'package:yibei_app/models/course/course_chapter_step/course_chapter_step.dart';
import 'package:yibei_app/models/user/user_radar_statics/user_radar_statics.dart';
import 'package:yibei_app/models/user/user_radar_statics/user_radar_statics_datum.dart';
import 'package:yibei_app/models/user/user_chapter_study_log/user_chapter_study_log.dart';

import 'package:yibei_app/provider/user_progress_model.dart';
import 'package:yibei_app/provider/course_chapter_tree_model.dart';

import 'package:yibei_app/api/user.dart';
import 'package:yibei_app/api/course.dart';

/// 免费用户

class FreeRecord extends StatefulWidget {
  const FreeRecord({super.key});

  @override
  State<FreeRecord> createState() => _FreeRecordState();
}

class _FreeRecordState extends State<FreeRecord> {
  /// 用户姓名
  String _userName = '用户名';

  /// 头像
  String _userAvatar = '';

  /// 课程列表、章节列表
  List<DataList> _courseChapterList = [];

  /// 用户的学习进度
  Progress _userProgress = Progress();

  /// 全部学习进度
  double _allStudyProgress = 0;

  /// 当前课程的所有步骤
  String _nowChapterAllStep = '';

  /// 当前课程步骤名称
  String _nowChapterStepTitle = '步骤1 - 解剖学简介';

  /// 当前课程的步骤
  int _nowChapterStep = 0;

  /// 按钮的文字
  String _buttonTitle = '开始试听';

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

  /// 获取用户学习进度 （0：试听进度，1：付费进度）
  _queryUserProgress() async {
    BaseEntity<UserProgress> entity = await getUserProgress(0);
    if (entity.data?.status != true) {
      return;
    }
    // 用户没有学习进度时，创建进度
    if (entity.data?.isprogress != true) {
      _setUserProgress();
      return;
    }
    if (entity.data?.progress != null) {
      setState(() {
        _userProgress = entity.data!.progress!;
      });
    }
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
          _buttonTitle = '继续试听';
          _allStudyProgress += 0.14;
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
        if (entity.data!.data?[0].lastVideotime != null) {
          _allStudyProgress += 0.14;
        }
        if (entity.data!.data?[0].keywordStudyChen != null) {
          _allStudyProgress += 0.14;
        }
        if (entity.data!.data?[0].keywordTestChen != null) {
          _allStudyProgress += 0.14;
        }
        if (entity.data!.data?[0].keywordStudyEn != null) {
          _allStudyProgress += 0.14;
        }
        if (entity.data!.data?[0].keywordTestEn != null) {
          _allStudyProgress += 0.14;
        }
        if (entity.data!.data?[0].uniTestEn != null) {
          _allStudyProgress += 0.16;
        }
      });
    }
  }

  /// 创建学习进度（免费）
  _setUserProgress() async {
    BaseEntity<CommonReturnStates> entity = await creatorUserProgressFree();
    if (entity.data?.status == true) {
      _queryUserProgress();
    }
  }

  /// 跳转继续学习页面
  _handleGotoStudy() {
    Navigator.pushNamed(
      context,
      AppRoutes.freeStudyStepList,
    );
  }

  @override
  void initState() {
    super.initState();

    // 获取用户信息的缓存
    UserInfo? userInfo = CacheUtils.instance.get<UserInfo>('userInfo');
    setState(() {
      if (userInfo?.username != null) {
        _userName = userInfo!.username!;
      }
      if (userInfo?.avatar != null) {
        _userAvatar = userInfo!.avatar!;
      }
    });

    _queryUserChapterStudy();
    _queryUserChapterStudyTwo();

    // () async {
    //   await _queryUserProgress();
    // }();
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

    ToolsUtil.courseChapterStep(
      chapterProgress: _userProgress.status == 1 ? 100 : 0,
      chapterId: 0,
      currentCourseChapterId: 0,
      stepFlag: _userProgress.stepflag ?? 0,
      stepData: _stepData,
    );

    for (var i = 0; i < _stepData.length; i++) {
      if (_stepData[i].progress == 100) {
        _allStudyProgress += 0.166;
      }
      if (_stepData[i].progress! > 0 && _stepData[i].progress! < 100) {
        _nowChapterStepTitle = '步骤${i + 1} ${_stepData[i].title}';
      }
    }

    // 全部学习完成
    if (_userProgress.status == 1) {
      _allStudyProgress = 100;
    }

    return Container(
      padding: const EdgeInsets.only(top: 5, left: 12, right: 12),
      child: Column(
        children: [
          // hello
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hello [$_userName]',
                style:
                    const TextStyle(fontSize: 28, color: AppColors.color43474E),
              ),
              ClipOval(
                child: _userAvatar == ''
                    ? Image.asset(
                        'lib/assets/images/head_avatar_default.png',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        _userAvatar,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
              )
            ],
          ),

          // 我的课程
          Container(
            margin: const EdgeInsets.only(top: 30, bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: AppColors.warningColor,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      '我的课程',
                      style: TextStyle(
                        color: AppColors.color7d5700,
                        fontSize: 14,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 14,
                      color: AppColors.color412d00,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    '联邦按摩辅导课程（试听课）',
                    style: TextStyle(
                      fontSize: 24,
                      decoration: TextDecoration.none,
                      color: AppColors.color412d00,
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _allStudyProgress,
                    backgroundColor: AppColors.colordea000, // 背景颜色
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.whiteColor), // 前景颜色
                    minHeight: 4, // 最小高度
                  ),
                ),
              ],
            ),
          ),

          // 上次学到
          Container(
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: AppColors.colorFFF8F3,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '上次学到',
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.color74777F,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "联邦按摩辅导课程（试听课）",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.color9C6F00,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  _nowChapterStepTitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.colorBC8700,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleGotoStudy,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.warningColor,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        _buttonTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.color271900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
