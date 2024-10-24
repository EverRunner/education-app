// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_chapter_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseChapterData _$CourseChapterDataFromJson(Map<String, dynamic> json) =>
    CourseChapterData(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : CourseChapterDataItem.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CourseChapterDataToJson(CourseChapterData instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
