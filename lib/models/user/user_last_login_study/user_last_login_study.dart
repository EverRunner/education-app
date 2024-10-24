import 'package:json_annotation/json_annotation.dart';

import 'user_last_login_study_data.dart';

part 'user_last_login_study.g.dart';

@JsonSerializable()
class UserLastLoginStudy {
  bool? status;
  UserLastLoginStudyData? data;

  UserLastLoginStudy({this.status, this.data});

  factory UserLastLoginStudy.fromJson(Map<String, dynamic> json) {
    return _$UserLastLoginStudyFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserLastLoginStudyToJson(this);
}
