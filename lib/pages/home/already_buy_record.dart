import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

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

import 'package:yibei_app/provider/user_progress_model.dart';
import 'package:yibei_app/provider/course_chapter_tree_model.dart';

import 'package:yibei_app/api/user.dart';
import 'package:yibei_app/api/course.dart';

/// 已经购买，已经有学习记录的

class AlreadyBuyRecord extends StatefulWidget {
  const AlreadyBuyRecord({super.key});

  @override
  State<AlreadyBuyRecord> createState() => _AlreadyBuyRecordState();
}

class _AlreadyBuyRecordState extends State<AlreadyBuyRecord> {
  /// 用户姓名
  String _userName = '用户名';

  /// 头像
  String _userAvatar = '';

  /// 预计完成时间
  String _forecastTime = '-';

  /// 本周学习时长
  double _weekStudyTime = 0;

  /// 今天学习时长
  double _dayStudyTime = 0;

  /// 课程列表、章节列表
  List<DataList> _courseChapterList = [];

  /// 用户的学习进度
  Progress _userProgress = Progress();

  /// 全部学习进度
  double _allStudyProgress = 0;

  /// 雷达图表数据
  UserRadarStaticsDatum _radarChartData = UserRadarStaticsDatum();

  /// 当前课程的所有步骤
  String _nowChapterAllStep = '';

  /// 当前课程步骤名称
  String _nowChapterStepTitle = '-';

  /// 当前课程的步骤
  int _nowChapterStep = 0;

  /// 当前是不是final章节
  int _isFinal = 0;

  /// loading
  bool _isLoading = true;

  // 学习数据、学习分析 Widget
  Widget studyDataAnalysis({
    required String title,
    required List<Widget> children,
    required String routeName,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 20,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: AppColors.colorF7F9FF,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, routeName);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: AppColors.color74777F,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
                  size: 14,
                  color: AppColors.color74777F,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 22,
          ),
          ...children,
        ],
      ),
    );
  }

  /// 获取本周的学习数据
  _queryWeekStudyStatics() async {
    BaseEntity<WeekStudyStatics> entity = await getWeekStudyStatics(
      showLoading: false,
    );
    if (entity.data?.status == false) {
      return;
    }
    // 本周和今天学习时长
    if (entity.data?.data != null) {
      double weekHours =
          (entity.data?.data?.currentweekstudytime ?? 0) / 60 / 60;
      double dayHours = (entity.data?.data?.todaystudytime ?? 0) / 60 / 60;
      setState(() {
        _weekStudyTime = double.parse(weekHours.toStringAsFixed(1));
        _dayStudyTime = double.parse(dayHours.toStringAsFixed(1));
      });
    }
  }

  /// 获取用户的学习雷达图
  _queryUserRadarStatics() async {
    BaseEntity<UserRadarStatics> entity = await getUserRadarStatics(
      showLoading: false,
    );
    if (entity.data?.status != true ||
        entity.data?.data == null ||
        entity.data?.data?[0] == null) {
      return;
    }
    setState(() {
      _radarChartData = entity.data!.data![0];
    });
  }

  /// 获取登录用户的信息
  _queryLoginUserInfo() async {
    BaseEntity<LoginUserInfo> entity = await getLoginUserInfo(
      showLoading: false,
    );
    if (entity.data?.status != true || entity.data?.userInfo == null) {
      return;
    }
    int aiycwcTime = int.parse(entity.data?.userInfo?.aiycwctime ?? '0'); // 总时长
    double studyTimeAvg = entity.data?.studytimeavg ?? 0; // 平均每天学习的时间

    // 预计完成时间
    if (aiycwcTime == 0) {
      setState(() {
        _forecastTime = "已完成";
      });
    } else {
      int expectedDay = (aiycwcTime / studyTimeAvg).ceil(); // 计算预计的天数
      DateTime currentDate = DateTime.now(); // 当前时间
      DateTime newDate = currentDate.add(Duration(days: expectedDay));
      setState(() {
        _forecastTime = DateFormat('yyyy/MM/dd').format(newDate);
      });
    }

    // 获取最新的用户信息，覆盖用户缓存信息
    CacheUtils.instance.set<UserInfo>(
      'userInfo',
      (entity.data!.userInfo!)..studytimeavg = entity.data?.studytimeavg,
    );
    // 更新加载状态
    setState(() {
      _isLoading = false;
    });
  }

  /// 获取课程列表
  _queryCourseChapterTree() {
    // 全部学习完成时候
    if (_userProgress.status == 1) {
      setState(() {
        _allStudyProgress = 1;
        _nowChapterStepTitle = '已完成';
      });
      return;
    }

    int sumStudyChapter = 0; // 已学习的章节数
    int chapterAll = 0; // 章节总数
    bool isStudy = true; // 是否学习过

    for (var courseData in _courseChapterList) {
      if (courseData.type == 1) {
        // 遍历子章节
        for (var chapterData in courseData.yibeiCourseChapter ?? []) {
          chapterAll++;

          if (chapterData.id == _userProgress?.currentcoursechapterid) {
            _nowChapterAllStep = chapterData?.studystep ?? '';

            _isFinal = chapterData?.isfinal;
            isStudy = false;
          }
          if (isStudy) sumStudyChapter++; // 已学
        }
      }
    }

    _handleLastChapterStep();

    setState(() {
      _allStudyProgress = double.parse(
          (sumStudyChapter / (chapterAll == 0 ? 0.01 : chapterAll))
              .toStringAsFixed(1));
    });
  }

  /// 获取用户学习进度 （0：试听进度，1：付费进度）
  _queryUserProgress() async {
    await Provider.of<UserProgressModel>(context, listen: false)
        .setUserProgress(1);

    BaseEntity<UserProgress> entity = await getUserProgress(
      1,
      showLoading: false,
    );
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

  /// 创建学习进度（付费的）
  _setUserProgress() async {
    BaseEntity<CommonReturnStates> entity = await creatorUserProgress(
      showLoading: false,
    );
    if (entity.data?.status == true) {
      _queryUserProgress();
    }
  }

  /// 跳转继续学习页面
  _handleGotoStudy() {
    int nowChapterStep = _nowChapterStep;

    // 当章节的进度为6，说明已经学习完成了，必须从 关键英文测试开始复习
    if (nowChapterStep == 6) {
      nowChapterStep = 4;
    }

    // 实例化工具类
    ToolsUtil toolsUtil = ToolsUtil();

    // 查找学习步骤=>对应的页面
    final CourseChapterStep courseChapterStepItem =
        toolsUtil.courseChapterStepData.firstWhere((stepItem) {
      return stepItem.index == nowChapterStep;
    }, orElse: () => CourseChapterStep());

    if (_isFinal == 1) {
      courseChapterStepItem.route = AppRoutes.studyWordFinalTest;
    }

    // 跳转到学习页
    if (courseChapterStepItem.route == null) return;
    Navigator.pushNamed(
      context,
      courseChapterStepItem.route!,
      arguments: {
        'courseId': _userProgress.currentcourseid,
        'chapterId': _userProgress.currentcoursechapterid,
      },
    );
  }

  /// 处理上一次学到的章节步骤
  _handleLastChapterStep() {
    // 当前步骤
    String stepFlag = (_userProgress.stepflag ?? 0).toString();

    // 调整步骤顺序
    int stepSort =
        ToolsUtil.adjustmentStepSort(step: int.parse(stepFlag)); // 当前步骤，不含时

    if (_nowChapterAllStep != '' &&
        !_nowChapterAllStep.contains(stepSort.toString())) {
      stepFlag = _nowChapterAllStep[0];
      stepSort = int.parse(stepFlag);
    }

    // Final章节
    if (_isFinal == 1) {
      stepFlag = '6';
    }

    setState(() {
      _nowChapterStep = stepSort;
      _nowChapterStepTitle = Config.study_chapter_step[stepFlag] ?? '-';
    });
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

    () async {
      await _queryUserProgress();

      // provider中的数据，学习进度
      _userProgress = Provider.of<UserProgressModel>(context, listen: false)
          .getUserProgressData;

      _queryWeekStudyStatics();
      _queryLoginUserInfo();
      _queryUserRadarStatics();
    }();
  }

  /// 真实的内容Widget
  Widget buildContent() {
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
              color: AppColors.primaryColor,
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
                        color: AppColors.whiteColor,
                        fontSize: 14,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 14,
                      color: AppColors.whiteColor,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    '联邦按摩辅导课程',
                    style: TextStyle(
                        fontSize: 24,
                        decoration: TextDecoration.none,
                        color: AppColors.whiteColor),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _allStudyProgress,
                    backgroundColor: AppColors.color004785, // 背景颜色
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.whiteColor), // 前景颜色
                    minHeight: 4, // 最小高度
                  ),
                ),
              ],
            ),
          ),

          // 学习数据、学习分析
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              studyDataAnalysis(
                  title: '学习数据',
                  routeName: AppRoutes.homeStudyData,
                  children: [
                    Row(
                      mainAxisAlignment: MediaQuery.of(context).size.width > 600
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '本周学习时长',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.color74777F,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '$_weekStudyTime',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 4, left: 4),
                                    child: Text(
                                      '小时',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.color74777F,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          padding: MediaQuery.of(context).size.width > 600
                              ? const EdgeInsets.only(left: 30)
                              : null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '今日学习时长',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.color74777F,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '$_dayStudyTime',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 4, left: 4),
                                      child: Text(
                                        '小时',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.color74777F,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 22,
                        ),
                        const Text(
                          '预计完成日',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.color74777F,
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          _forecastTime,
                          style: const TextStyle(
                            fontSize: 24,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ]),
              Flexible(
                child: studyDataAnalysis(
                  title: '学习分析',
                  routeName: AppRoutes.studyAnalysis,
                  children: [
                    Container(
                      height: 125,
                      child: YbRadarChart(
                        chartData: _radarChartData,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),

          // 上次学到
          Container(
            margin: const EdgeInsets.only(
              top: 16,
              bottom: 20,
            ),
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: AppColors.colorFFF8F3,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '上次学到',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.color74777F,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    InkWell(
                      child: Row(
                        children: const [
                          Text(
                            '学习报告',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.color74777F,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            size: 14,
                            color: AppColors.color74777F,
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.studyReport,
                        );
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  _userProgress.yibeiCourseChapter?.title ?? "-",
                  style: const TextStyle(
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
                          AppColors.warningColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        '继续学习',
                        style: TextStyle(
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

  @override
  Widget build(BuildContext context) {
    // provider中的数据，课程列表、章节列表
    _courseChapterList =
        Provider.of<CourseChapterTreeModel>(context, listen: true)
            .getCourseChapterList;
    // provider中的数据，学习进度
    _userProgress = Provider.of<UserProgressModel>(context, listen: true)
        .getUserProgressData;

    _queryCourseChapterTree();

    return _isLoading
        ? Shimmer.fromColors(
            baseColor: AppColors.colorECEFF5,
            highlightColor: AppColors.colorF7F9FF,
            child: buildContent(),
          )
        : buildContent();
  }
}
