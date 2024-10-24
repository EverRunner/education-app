// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_request_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseRequestInfo _$CourseRequestInfoFromJson(Map<String, dynamic> json) =>
    CourseRequestInfo(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : CourseRequestInfoData.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CourseRequestInfoToJson(CourseRequestInfo instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
