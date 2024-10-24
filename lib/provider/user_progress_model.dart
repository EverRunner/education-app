import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/course/course_chapter_tree/course_chapter_tree.dart';
import 'package:yibei_app/models/course/course_chapter_tree/data_list.dart';
import 'package:yibei_app/models/course/user_progress/user_progress.dart';
import 'package:yibei_app/models/course/user_progress/progress.dart';

import 'package:yibei_app/api/course.dart';

/// 用户进度数据
class UserProgressModel extends ChangeNotifier {
  /// 初始值
  Progress _userProgress = Progress();

  /// 获取用户进度数据
  Progress get getUserProgressData => _userProgress;

  /// 设置用户进度数据并通知（0：试听进度，1：付费进度）
  Future<void> setUserProgress(
    int type, {
    bool showLoading = false,
  }) async {
    BaseEntity<UserProgress> entity = await getUserProgress(
      type,
      showLoading: showLoading,
    );
    if (entity.data?.status != true) {
      return;
    }

    // 更新的值，通知Consumer进行刷新
    _userProgress = entity.data!.progress ?? Progress();
    notifyListeners();
  }

  void setTestDetailLogs() {}
}
