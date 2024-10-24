// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_compound_submit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseCompoundSubmit _$CourseCompoundSubmitFromJson(
        Map<String, dynamic> json) =>
    CourseCompoundSubmit(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CourseCompoundSubmitToJson(
        CourseCompoundSubmit instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
