// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_chapter_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseChapterStep _$CourseChapterStepFromJson(Map<String, dynamic> json) =>
    CourseChapterStep(
      index: json['index'] as int?,
      progress: json['progress'] as int?,
      title: json['title'] as String?,
      route: json['route'] as String?,
    );

Map<String, dynamic> _$CourseChapterStepToJson(CourseChapterStep instance) =>
    <String, dynamic>{
      'index': instance.index,
      'progress': instance.progress,
      'title': instance.title,
      'route': instance.route,
    };
