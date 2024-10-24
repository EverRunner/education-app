import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/components/chart/yb_radar_chart.dart';
import 'package:yibei_app/components/common/yb_scaffold.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/utils/cache_util.dart';
import 'package:yibei_app/utils/tools_util.dart';
import 'package:yibei_app/utils/toast_util.dart';

import 'package:yibei_app/models/user/login_user_info/user_info.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/user/user_radar_statics/user_radar_statics.dart';
import 'package:yibei_app/models/user/user_radar_statics/user_radar_statics_datum.dart';
import 'package:yibei_app/models/user/user_last_login_study/user_last_login_study.dart';
import 'package:yibei_app/models/user/user_last_login_study/user_last_login_study_data.dart';

import 'package:yibei_app/provider/user_progress_model.dart';
import 'package:yibei_app/provider/course_chapter_tree_model.dart';

import 'package:yibei_app/api/user.dart';
import 'package:yibei_app/api/course.dart';

/// 学习分析页面

class StudyAnalysisPage extends StatefulWidget {
  const StudyAnalysisPage({super.key});

  @override
  State<StudyAnalysisPage> createState() => _StudyAnalysisPageState();
}

class _StudyAnalysisPageState extends State<StudyAnalysisPage> {
  /// 用户信息
  UserInfo _userInfo = UserInfo();

  /// 最后登录的时间 - 已格式化
  String _lastLoginTime = '-';

  /// 最后登录时间
  double _disLastLoginTimes = 0;

  /// 雷达图表数据
  UserRadarStaticsDatum _radarChartData = UserRadarStaticsDatum();

  /// 最后登录的时间 - 已格式化
  UserLastLoginStudyData _lastLoginStudy = UserLastLoginStudyData();

  /// 学习建议字段列表
  final List<String> _fieldList = [
    "关键词测试（中英）",
    "关键词测试（英）",
    "单元测试",
    "我的错题（测前单词）",
    "我的错题",
    "高频错题（测前单词）",
    "高频错题",
    "综合测试（测前单词）",
    "综合测试",
  ];

  /// 学习建议列表（数组，值是任意值 ）
  List<dynamic> _studySuggestList = [];

  /// 学习提示
  String? _studyHint;

  /// 学习提示2
  String? _studyHint2;

  /// 处理用户的信息
  _handleUserInfo() async {
    // 获取用户信息的缓存
    UserInfo? userInfo = CacheUtils.instance.get<UserInfo>('userInfo');
    if (userInfo == null) return;

    // 学习建议列表
    List<dynamic> studySuggestList = [];

    if (userInfo.degreecontent != null && userInfo.degreecontent != '') {
      try {
        studySuggestList =
            (jsonDecode(userInfo.degreecontent!) as List<dynamic>)
                .where((item) {
          String title = _fieldList.firstWhere(
            (son) => item[0].contains(son),
            orElse: () => '',
          );

          if (item[1] == 1 && title != '') {
            item[0] = title;
            item[2] = (item[2] * 1000).abs().floor() / 10;
            return true;
          } else {
            return false;
          }
        }).toList();
      } catch (error) {
        // ignore: avoid_print
        print("获取学习建议异常！");
        // ignore: avoid_print
        print(error);
      }
    }

    _studySuggestList = studySuggestList;

    setState(() {
      _userInfo = userInfo;
    });
  }

  _handleStudyHint() {
    /// 提示1
    String? studyHint;

    /// 提示2
    String? studyHint2;

    // 提示1
    if (_studySuggestList.isNotEmpty) {
      studyHint = "根据我们的数据分析结果，如果您想顺利通过联邦考试，您的";

      for (int index = 0; index < _studySuggestList.length; index++) {
        List<dynamic> item = _studySuggestList[index];
        studyHint!; // 非空断言
        studyHint += '【${item[0]}，';
        studyHint += item[2] > 5 ? '需要加强关键词的记忆和多练习关键词】' : '需要加强关键词的记忆】';
        studyHint += index >= _studySuggestList.length - 1 ? '' : '、';
      }
    }

    int videoStudyTimes = _lastLoginStudy.studyData?.videoStudyTimes != null
        ? _lastLoginStudy.studyData!.videoStudyTimes! ~/ 60
        : 0;
    int keywordChEnTestTimes =
        _lastLoginStudy.studyData?.keywordchenTestTimes != null
            ? _lastLoginStudy.studyData!.keywordchenTestTimes! ~/ 60
            : 0;
    int keywordEnTestTimes =
        _lastLoginStudy.studyData?.keywordenTestTimes != null
            ? _lastLoginStudy.studyData!.keywordenTestTimes! ~/ 60
            : 0;
    int unitTestTimes = _lastLoginStudy.studyData?.unitTestTimes != null
        ? _lastLoginStudy.studyData!.unitTestTimes! ~/ 60
        : 0;

    // 提示2
    if (_disLastLoginTimes >= 5 * 24) {
      studyHint2 = '您已经5天没有登系统学习了，再忙也要抽出时间来学习哦！每天一点点的进步，都可以带您通往成功之路！';
    } else if (keywordChEnTestTimes + keywordEnTestTimes > videoStudyTimes) {
      studyHint2 =
          '我们注意到您花了很多时间在关键词测试上，不要心急！如果您发现测试总是无法通过，不妨多花些时间看看视频课程，真正学懂知识点，做起题来就会更轻松啦！视频课程听不懂的地方，可以随时微信咨询张老师或者在学习群里跟大家讨论哦！';
    } else if (_lastLoginStudy.unitTestAvg != null &&
        _lastLoginStudy.mykgAvg != null &&
        _lastLoginStudy.kgskgAvg != null &&
        _lastLoginStudy.unitTestAvg! < 0.9 &&
        _lastLoginStudy.mykgAvg! > _lastLoginStudy.kgskgAvg!) {
      studyHint2 =
          '我们注意到您花了很多时间在关键词测试上，不要心急！如果您发现测试总是无法通过，不妨多花些时间看看视频课程，真正学懂知识点，做起题来就会更轻松啦！视频课程听不懂的地方，可以随时微信咨询张老师或者在学习群里跟大家讨论哦！';
    } else if (_radarChartData.vedioMineDuration != null &&
        _radarChartData.entestMineDuration != null &&
        _radarChartData.chentestMineDuration != null &&
        _radarChartData.chaptertestMineDuration != null &&
        _lastLoginStudy.unitTestAvg != null &&
        _radarChartData.vedioMineDuration! >
            _radarChartData.entestMineDuration! +
                _radarChartData.chentestMineDuration! +
                _radarChartData.chaptertestMineDuration! &&
        _lastLoginStudy.unitTestAvg! < 0.9) {
      studyHint2 =
          '我们注意到您花了很多时间来看视频课程，是对视频课程有什么疑问吗？ 如果有疑问的话，可以随时微信咨询张老师或者在学习群里跟大家讨论哦！看完视频一定要去做题，检验自己哪里没有学懂，这样学习才能更高效哦！';
    } else {
      studyHint2 =
          "您上次登录花了${videoStudyTimes}分钟学习视频课程，${keywordChEnTestTimes + keywordEnTestTimes}分钟做关键词测试，${unitTestTimes}分钟做单元测试，请继续努力！";
    }

    setState(() {
      _studyHint = studyHint;
      _studyHint2 = studyHint2;
    });
  }

  /// 获取用户上一次学习的记录情况
  _queryUserLastLoginStudy() async {
    BaseEntity<UserLastLoginStudy> entity = await getUserLastLoginStudyConst();
    if (entity.data?.status != true || entity.data?.data == null) {
      return;
    }

    _lastLoginStudy = entity.data!.data!;
  }

  /// 获取用户的学习雷达图
  _queryUserRadarStatics() async {
    BaseEntity<UserRadarStatics> entity = await getUserRadarStatics();
    if (entity.data?.status != true ||
        entity.data?.data == null ||
        entity.data?.data?[0] == null) {
      return;
    }

    _disLastLoginTimes = entity.data?.disLastLoginTimes ?? 0;

    int seconds = (entity.data!.disLastLoginTimes! * 60 * 60).toInt();

    setState(() {
      _radarChartData = entity.data!.data![0];
      _lastLoginTime = ToolsUtil.formatSeconds(
        seconds: seconds,
      );
    });
  }

  @override
  void initState() {
    _handleUserInfo();

    () async {
      await _queryUserRadarStatics();
      await _queryUserLastLoginStudy();
      _handleStudyHint();
    }();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YbScaffold(
      appBarTitle: '学习分析',
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
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
                    Text(
                      'Dear ${_userInfo.username},',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.color43474E,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      '距离您上次登入学习已有 $_lastLoginTime 。以下是您目前为止的学习情况分析：',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.color43474E,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (_studyHint != null)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: AppColors.colorFDF6EC,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'lib/assets/images/twemoji_light-bulb.png',
                              width: 22,
                              height: 22,
                            ),
                            Expanded(
                              child: Text(
                                '$_studyHint',
                                softWrap: true,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.color43474E,
                                  height: 1.4,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (_studyHint2 != null)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: AppColors.colorFDF6EC,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'lib/assets/images/twemoji_light-bulb.png',
                              width: 22,
                              height: 22,
                            ),
                            Expanded(
                              child: Text(
                                '$_studyHint2',
                                softWrap: true,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.color43474E,
                                  height: 1.4,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      height: 200,
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: YbRadarChart(
                        isShowLegend: true,
                        chartData: _radarChartData,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: YbButton(
                  text: '分享到朋友圈',
                  circle: 25,
                  onPressed: () {
                    ToastUtil.shortToast('此功能暂示开放');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
