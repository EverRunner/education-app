import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/routes/index.dart';
import './components/course_list.dart';

import 'package:yibei_app/models/course/course_chapter_tree/yibei_course_chapter.dart';
import 'package:yibei_app/models/course/course_list_data/course_list_data.dart';
import 'package:yibei_app/models/course/user_progress/progress.dart';
import 'package:yibei_app/models/course/course_chapter_tree/data_list.dart';
import 'package:yibei_app/models/user/member_test_detail_log/member_test_detail_log_datum.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/provider/user_progress_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yibei_app/utils/cache_util.dart';

import 'package:yibei_app/provider/course_chapter_tree_model.dart';
import 'package:yibei_app/provider/user_progress_model.dart';
import 'package:yibei_app/provider/test_detail_logs_model.dart';
import 'package:yibei_app/models/user/login_user_info/user_info.dart';

import 'package:yibei_app/provider/course_chapter_tree_model.dart';
import 'package:yibei_app/provider/test_detail_logs_model.dart';

// 课程列表页
class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  // 课程列表
  late List<CourseListData> _courseData = [];

  /// 课程列表、章节列表
  late List<DataList> _courseChapterList = [];

  /// 用户的学习进度
  late Progress _userProgress = Progress();

  //  课程测试列表
  List<CourseListData> _courseTestData = [
    CourseListData(
      id: -100,
      title: "综合测评",
    ),
    CourseListData(
      id: -200,
      title: "应变测试",
    ),
  ];

  /// 综合、我的错题、高频错题记录、应变测试
  late MemberTestDetailLogDatum _testDetailLogs = MemberTestDetailLogDatum();

  /// 获取课程列表
  _handleCourseChapterTree(UserInfo? userInfo) {
    // // 全部学习完成时候
    // if (_userProgress.status == 1) {}

    int nowIsStudy = 1; // 当前是否学习过
    List<CourseListData> courseList = []; // 课程列表

    for (var courseData in _courseChapterList) {
      //  付费课程
      if (courseData.type == 1) {
        var newCourseData = CourseListData(
          id: courseData.id,
          progress: 0,
          title: courseData.title,
        );

        if (userInfo?.level == 1) {
          // 查找当前课程
          if (courseData.id == _userProgress.currentcourseid) {
            nowIsStudy = 0;
            newCourseData.progress = _handleChapterProgress(
                  courseData.yibeiCourseChapter ?? [],
                  _userProgress.currentcoursechapterid ?? 0,
                ) ??
                0;

            // 步骤4 代表已经完成
            if (newCourseData.progress == 100 && _userProgress.stepflag != 4) {
              newCourseData.progress = 96;
            }

            // 全部学习完成
            if (_userProgress.status == 1) {
              newCourseData.progress = 100;
            }
          }

          // 已经学课程
          if (nowIsStudy == 1) {
            newCourseData.progress = 100;
          }
        }

        // 添加课程列表
        courseList.add(newCourseData);
      }
    }
    _courseData = courseList + _courseTestData;
  }

  /// 查找章节的进度
  int _handleChapterProgress(List<YibeiCourseChapter> list, int id) {
    final allCount = list.length;
    var index = 1;

    for (var i = 0; i < allCount; i++) {
      if (list[i].id == id) {
        return ((index / allCount) * 100).truncate();
      }
      index++;
    }

    return 0;
  }

  /// 处理综合、高频、我的错误等记录
  _handleTestDetailLogs() {
    int progress = 1; // 综合测评进度
    int strainProgress = 0; // 应变测试进度

    // 我的错题
    if (_testDetailLogs.errorTestbeforekeywordTime != null) progress += 16;
    if (_testDetailLogs.errorTestScore != null) progress += 17;

    // 高频错题
    if (_testDetailLogs.gaopingTestbeforekeywordTime != null) progress += 17;
    if (_testDetailLogs.gaopingTestbeforewordScore != null) progress += 17;

    // 综合题
    if (_testDetailLogs.zongheTestbeforekeywordTime != null) progress += 16;
    if (_testDetailLogs.zongheTestbeforewordScore != null) progress += 16;

    // 应变题
    if (_testDetailLogs.strainTestbeforekeywordTime != null)
      strainProgress += 50;
    if (_testDetailLogs.strainTestbeforewordScore != null) strainProgress += 50;

    // 综合测试
    _courseTestData[0].progress = progress;

    // 应变测试
    if (progress >= 100 && strainProgress == 0) {
      _courseTestData[1].progress = 1;
    } else {
      _courseTestData[1].progress = strainProgress;
    }
  }

  /// 处理跳转
  _handleGoto(
    BuildContext context,
    int id,
  ) {
    // 获取用户信息的缓存
    UserInfo? userInfo = CacheUtils.instance.get<UserInfo>('userInfo');

    // 当前日期
    DateTime currentDate = DateTime.now();

    if (userInfo?.level == 0 ||
        currentDate.isAfter(userInfo?.endhydate ?? currentDate)) {
      handleOpen();
      return;
    }
    Navigator.pushNamed(
      context,
      AppRoutes.courseChapterList,
      arguments: {
        'courseId': id,
      },
    );
  }

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
        ]);
  }

  @override
  void initState() {
    super.initState();
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
    // provider中的数据，综合、我的错题、高频测试记录
    _testDetailLogs = Provider.of<TestDetailLogsModel>(context, listen: true)
        .getTestDetailLogs;
    // 获取用户信息的缓存
    UserInfo? userInfo = CacheUtils.instance.get<UserInfo>('userInfo');

    // 当前日期
    DateTime currentDate = DateTime.now();

    if (userInfo?.level == 1 && _userProgress.status == 1) {
      _handleTestDetailLogs();
    }

    _handleCourseChapterTree(userInfo);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // 设置为0表示不显示AppBar
        child: AppBar(
          backgroundColor: AppColors.colorF1F4FA,
          elevation: 0.0, // 设置阴影为0.0
        ),
      ),
      backgroundColor: AppColors.colorF1F4FA,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 20,
            left: 12,
            right: 12,
          ),
          child: Column(
            children: [
              CourseList(
                data: _courseData,
                onButtonPressed: _handleGoto,
              ),
              if (userInfo?.level == 0 ||
                  currentDate.isAfter(userInfo?.endhydate ?? currentDate))
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: YbButton(
                      text: '解锁全部课程',
                      circle: 20,
                      icon: Icons.lock_open_outlined,
                      onPressed: handleOpen,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
