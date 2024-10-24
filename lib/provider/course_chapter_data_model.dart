import 'package:flutter/material.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/course/course_chapter_tree/course_chapter_tree.dart';
import 'package:yibei_app/models/course/course_chapter_tree/data_list.dart';
import 'package:yibei_app/models/course/course_chapter_data/course_chapter_data_item.dart';
import 'package:yibei_app/models/course/course_chapter_data/course_chapter_data.dart';

import 'package:yibei_app/api/course.dart';

/// 课程和章节的值
class CourseChapterDataModel extends ChangeNotifier {
  /// 初始值
  final Map<int, CourseChapterDataItem> _courseChapterData = {};

  /// 获取章节详情
  /// [chapterId] 章节id
  CourseChapterDataItem? getCourseChapterDataItem(int chapterId) {
    return _courseChapterData[chapterId];
  }

  /// 设置章节详情
  /// [chapterId] 章节id
  Future<void> setCourseChapterDataItem({
    required int chapterId,
  }) async {
    BaseEntity<CourseChapterData> entity = await getCourseChapterDataById(
      chapterId: chapterId,
    );
    if (entity.data?.status != true || entity.data?.data == null) {
      return;
    }

    _courseChapterData[chapterId] = entity.data!.data!;

    // 更新的值，通知Consumer进行刷新
    notifyListeners();
  }
}
