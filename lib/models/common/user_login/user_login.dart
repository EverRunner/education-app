import 'package:json_annotation/json_annotation.dart';

import 'package:yibei_app/models/user/login_user_info/user_info.dart';

part 'user_login.g.dart';

@JsonSerializable()
class UserLogin {
  bool? status;
  UserInfo? userInfo;
  String? token;

  UserLogin({this.status, this.userInfo, this.token});

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return _$UserLoginFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserLoginToJson(this);
}
