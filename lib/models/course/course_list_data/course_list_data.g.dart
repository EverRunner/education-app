// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_list_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseListData _$CourseListDataFromJson(Map<String, dynamic> json) =>
    CourseListData(
      id: json['id'] as int?,
      progress: json['progress'] as int?,
      title: json['title'] as String?,
      isFinal: json['isFinal'] as int?,
      studyStep: json['studyStep'] as String?,
      type: json['type'] as int?,
    );

Map<String, dynamic> _$CourseListDataToJson(CourseListData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'progress': instance.progress,
      'title': instance.title,
      'isFinal': instance.isFinal,
      'studyStep': instance.studyStep,
      'type': instance.type,
    };
