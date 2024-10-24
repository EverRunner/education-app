// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginUserInfo _$LoginUserInfoFromJson(Map<String, dynamic> json) =>
    LoginUserInfo(
      status: json['status'] as bool?,
      userInfo: json['userInfo'] == null
          ? null
          : UserInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
      studytimeavg: (json['studytimeavg'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LoginUserInfoToJson(LoginUserInfo instance) =>
    <String, dynamic>{
      'status': instance.status,
      'userInfo': instance.userInfo,
      'studytimeavg': instance.studytimeavg,
    };
