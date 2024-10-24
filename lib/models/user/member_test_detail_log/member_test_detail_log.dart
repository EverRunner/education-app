import 'package:json_annotation/json_annotation.dart';

import 'member_test_detail_log_datum.dart';

part 'member_test_detail_log.g.dart';

@JsonSerializable()
class MemberTestDetailLog {
  bool? status;
  List<MemberTestDetailLogDatum>? data;

  MemberTestDetailLog({this.status, this.data});

  factory MemberTestDetailLog.fromJson(Map<String, dynamic> json) {
    return _$MemberTestDetailLogFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MemberTestDetailLogToJson(this);

  void setTestDetailLogs() {}
}
