import 'package:flutter/material.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/course/course_chapter_tree/course_chapter_tree.dart';
import 'package:yibei_app/models/course/course_chapter_tree/data_list.dart';

import 'package:yibei_app/api/course.dart';

/// 课程和章节的值
class CourseChapterTreeModel extends ChangeNotifier {
  /// 初始值
  List<DataList> _courseChapterList = [];

  /// 获取课程和章节的值
  List<DataList> get getCourseChapterList => _courseChapterList;

  /// 设置课程和章节的值并通知
  Future<void> setCourseChapterList() async {
    BaseEntity<CourseChapterTree> entity = await getCourseChapterTree(
      showLoading: false,
    );
    if (entity.data?.status != true || entity.data?.dataList == null) {
      return;
    }
    // 更新的值，通知Consumer进行刷新
    _courseChapterList = entity.data!.dataList!;
    notifyListeners();
  }
}
