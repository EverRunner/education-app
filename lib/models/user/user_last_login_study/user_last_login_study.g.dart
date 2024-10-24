// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_last_login_study.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLastLoginStudy _$UserLastLoginStudyFromJson(Map<String, dynamic> json) =>
    UserLastLoginStudy(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : UserLastLoginStudyData.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserLastLoginStudyToJson(UserLastLoginStudy instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
