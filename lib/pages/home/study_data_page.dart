import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/utils/cache_util.dart';
import 'package:yibei_app/components/chart/yb_line_chart.dart';
import 'package:yibei_app/components/common/yb_scaffold.dart';

import 'package:yibei_app/models/user/login_user_info/user_info.dart';
import 'package:yibei_app/models/user/week_study_statics/week_study_statics.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/course/course_chapter_tree/data_list.dart';
import 'package:yibei_app/models/course/user_progress/progress.dart';

import 'package:yibei_app/provider/user_progress_model.dart';
import 'package:yibei_app/provider/course_chapter_tree_model.dart';

import 'package:yibei_app/api/user.dart';

/// 学习数据页面
class StudyDataPage extends StatefulWidget {
  const StudyDataPage({super.key});

  @override
  State<StudyDataPage> createState() => _StudyDataPageState();
}

class _StudyDataPageState extends State<StudyDataPage> {
  /// 预计完成时间
  String _forecastTime = '-';

  /// 本周学习时长
  double _weekStudyTime = 0;

  /// 今天学习时长
  double _dayStudyTime = 0;

  /// 总学习时长
  int _allStudyTime = 0;

  /// 总学习天数
  int _allStudyDay = 0;

  /// 全部学习进度
  double _allStudyProgress = 0;

  /// 课程列表、章节列表
  List<DataList> _courseChapterList = [];

  /// 用户的学习进度
  Progress _userProgress = Progress();

  /// 本周数据
  List<int> _currentWeekData = [];

  /// 本周数据
  List<int> _lastWeekData = [];

  /// 本周数据
  List<double> _sysAvgData = [];

  /// 获取学习进度
  _queryStudyProgress() {
    // 全部学习完成时候
    if (_userProgress.status == 1) {
      setState(() {
        _allStudyProgress = 1;
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
            isStudy = false;
          }
          if (isStudy) sumStudyChapter++; // 已学
        }
      }
    }
    setState(() {
      _allStudyProgress = double.parse(
          (sumStudyChapter / (chapterAll == 0 ? 0.01 : chapterAll))
              .toStringAsFixed(1));
    });
  }

  /// 处理用户的信息
  _handleUserInfo() async {
    // 获取用户信息的缓存
    UserInfo? userInfo = CacheUtils.instance.get<UserInfo>('userInfo');
    if (userInfo == null) return;

    int aiycwcTime = int.parse(userInfo.aiycwctime ?? '0'); // 总时长
    double studyTimeAvg = userInfo.studytimeavg ?? 0; // 平均每天学习的时间

    String forecastTime;

    // 预计完成时间
    if (aiycwcTime == 0) {
      forecastTime = "已完成";
    } else {
      int expectedDay = (aiycwcTime / studyTimeAvg).ceil(); // 计算预计的天数
      DateTime currentDate = DateTime.now(); // 当前时间
      DateTime newDate = currentDate.add(Duration(days: expectedDay));
      forecastTime = DateFormat('yyyy/MM/dd').format(newDate);
    }

    setState(() {
      _forecastTime = forecastTime;
      _allStudyDay = userInfo.allstudydate ?? 0; // 总天数
      _allStudyTime = (userInfo.allstudytime! / 60 / 60).ceil(); // 总时长
    });
  }

  /// 获取本周的学习数据
  _queryWeekStudyStatics() async {
    BaseEntity<WeekStudyStatics> entity = await getWeekStudyStatics();
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
        _currentWeekData = entity.data?.data?.currentWeekData ?? [];
        _lastWeekData = entity.data?.data?.lastWeekData ?? [];
        // _sysAvgData = entity.data?.data?.sysAvgData ?? [];
        _sysAvgData = [
          entity.data?.data?.sysavg ?? 0,
          entity.data?.data?.sysavg ?? 0,
          entity.data?.data?.sysavg ?? 0,
          entity.data?.data?.sysavg ?? 0,
          entity.data?.data?.sysavg ?? 0,
          entity.data?.data?.sysavg ?? 0,
          entity.data?.data?.sysavg ?? 0,
        ];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _queryWeekStudyStatics();
    _handleUserInfo();

    // 获取provider中的数据
    setState(() {
      // 课程列表
      _courseChapterList =
          Provider.of<CourseChapterTreeModel>(context, listen: false)
              .getCourseChapterList;
      // 学习进度
      _userProgress = Provider.of<UserProgressModel>(context, listen: false)
          .getUserProgressData;
    });
    _queryStudyProgress();
  }

  @override
  Widget build(BuildContext context) {
    return YbScaffold(
      appBarTitle: '学习数据',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 预计完成
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              border: Border.all(
                color: AppColors.colorE0E2EC, // 设置边框颜色
                width: 1.0, // 设置边框宽度
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '预计完成',
                  style: TextStyle(
                    fontSize: 22,
                    color: AppColors.color1A1C1E,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  _forecastTime,
                  style: const TextStyle(
                    fontSize: 32,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          // 学习数据
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              border: Border.all(
                color: AppColors.colorE0E2EC, // 设置边框颜色
                width: 1.0, // 设置边框宽度
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '学习数据',
                  style: TextStyle(
                    fontSize: 22,
                    color: AppColors.color1A1C1E,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  '已完成 ${(_allStudyProgress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.color1A1C1E,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _allStudyProgress,
                    backgroundColor: AppColors.colorE7F2FF, // 背景颜色
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryColor), // 前景颜色
                    minHeight: 4, // 最小高度
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 37,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '总学习时长',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.color1A1C1E,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text(
                                '$_allStudyTime',
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  left: 8,
                                ),
                                child: Text(
                                  '小时',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.color74777F,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 37,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '总学习天数',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.color1A1C1E,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text(
                                '$_allStudyDay',
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  left: 8,
                                ),
                                child: Text(
                                  '天',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.color74777F,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(
            height: 22,
          ),

          // 本周学习
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              border: Border.all(
                color: AppColors.colorE0E2EC, // 设置边框颜色
                width: 1.0, // 设置边框宽度
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '本周学习',
                  style: TextStyle(
                    fontSize: 22,
                    color: AppColors.color1A1C1E,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 37,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '本周学习时长',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.color1A1C1E,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text(
                                '$_weekStudyTime',
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  left: 8,
                                ),
                                child: Text(
                                  '小时',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.color74777F,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 37,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '今日学习时长',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.color1A1C1E,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text(
                                '$_dayStudyTime',
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  left: 8,
                                ),
                                child: Text(
                                  '小时',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.color74777F,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  // height: 170,
                  margin: const EdgeInsets.only(top: 25),
                  child: _sysAvgData.length > 0
                      ? YbLineChart(
                          currentWeekData: _currentWeekData,
                          lastWeekData: _lastWeekData,
                          sysAvgData: _sysAvgData,
                        )
                      : null,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
