import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/pages/course/components/course_list.dart';
import 'package:yibei_app/models/course/course_list_data/course_list_data.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/dialog/dialog_show.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/course/course_chapter_tree/course_chapter_tree.dart';

import 'package:yibei_app/api/common.dart';
import 'package:yibei_app/provider/notifier_provider.dart';

// 主页 - 课程列表页
class IndexCourseListPage extends StatefulWidget {
  const IndexCourseListPage({super.key});

  @override
  State<IndexCourseListPage> createState() => _IndexCourseListPageState();
}

class _IndexCourseListPageState extends State<IndexCourseListPage> {
  // 课程列表
  late List<CourseListData> _courseData = [];

  //  课程测试列表
  final List<CourseListData> _courseTestData = [
    CourseListData(
      id: -100,
      title: "综合测评",
    ),
    CourseListData(
      id: -200,
      title: "应变测试",
    ),
  ];

  /// 设置课程和章节的值并通知
  Future<void> _getCourseChapterList() async {
    BaseEntity<CourseChapterTree> entity = await getCourseListNoLogin();

    if (entity.data?.status != true || entity.data?.dataList == null) {
      return;
    }

    List<CourseListData> courseList = []; // 课程列表
    for (var courseData in entity.data!.dataList!) {
      var newCourseData = CourseListData(
        id: courseData.id,
        progress: 0,
        title: courseData.title,
      );
      // 添加课程列表
      courseList.add(newCourseData);
    }

    setState(() {
      _courseData = courseList + _courseTestData;
    });
  }

  /// 打开弹框解锁全部课程
  handleOpen() {
    onShowAlertDialog(
        context: context,
        title: '提示',
        barrierDismissible: true,
        detail: Container(
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 10,
          ),
          child: const Text('解锁全部课程，帮您轻松通过联邦按摩！'),
        ),
        actions: [
          YbButton(
            text: '去注册购买',
            circle: 20,
            onPressed: () {
              Navigator.pop(context); // 关闭弹窗
              // 去注册
              jumpPageProvider.value = 0;
              Navigator.pushNamed(context, AppRoutes.register);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 5),
            child: TextButton(
              child: const Text('游客购买'),
              onPressed: () {
                Navigator.pop(context); // 关闭弹窗
                Navigator.pushNamed(context, AppRoutes.touristLogin);
              },
            ),
          ),
        ]);
  }

  @override
  void initState() {
    super.initState();

    _getCourseChapterList();
  }

  @override
  Widget build(BuildContext context) {
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
          color: AppColors.colorF1F4FA,
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
                onButtonPressed: () {
                  handleOpen();
                },
                disabled: true,
              ),
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
