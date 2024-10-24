// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_chapter_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseChapterList _$CourseChapterListFromJson(Map<String, dynamic> json) =>
    CourseChapterList(
      remark: json['remark'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CourseChapterListToJson(CourseChapterList instance) =>
    <String, dynamic>{
      'remark': instance.remark,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
