import 'package:flutter/material.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/user/member_test_detail_log/member_test_detail_log.dart';
import 'package:yibei_app/models/user/member_test_detail_log/member_test_detail_log_datum.dart';

import 'package:yibei_app/api/user.dart';

/// 综合测试、我的错题、高频错题、应变测试，测试记录
class TestDetailLogsModel extends ChangeNotifier {
  /// 初始值
  MemberTestDetailLogDatum _testDetailLogs = MemberTestDetailLogDatum();

  /// 获取测试记录数据
  MemberTestDetailLogDatum get getTestDetailLogs => _testDetailLogs;

  /// 设置测试记录并通知
  Future<void> setTestDetailLogs() async {
    BaseEntity<MemberTestDetailLog> entity = await getMemberTestLog();
    if (entity.data?.status != true) {
      return;
    }
    MemberTestDetailLogDatum? result = entity.data?.data?[0];
    if (result != null) {
      // 更新的值，通知Consumer进行刷新
      _testDetailLogs = result;
    }

    notifyListeners();
  }
}
