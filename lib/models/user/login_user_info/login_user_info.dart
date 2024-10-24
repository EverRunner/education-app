import 'package:json_annotation/json_annotation.dart';

import 'user_info.dart';

part 'login_user_info.g.dart';

@JsonSerializable()
class LoginUserInfo {
  bool? status;
  UserInfo? userInfo;
  double? studytimeavg;

  LoginUserInfo({this.status, this.userInfo, this.studytimeavg});

  factory LoginUserInfo.fromJson(Map<String, dynamic> json) {
    return _$LoginUserInfoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LoginUserInfoToJson(this);
}
