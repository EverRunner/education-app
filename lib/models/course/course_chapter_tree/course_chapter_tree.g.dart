// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_chapter_tree.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseChapterTree _$CourseChapterTreeFromJson(Map<String, dynamic> json) =>
    CourseChapterTree(
      status: json['status'] as bool?,
      dataList: (json['dataList'] as List<dynamic>?)
          ?.map((e) => DataList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseChapterTreeToJson(CourseChapterTree instance) =>
    <String, dynamic>{
      'status': instance.status,
      'dataList': instance.dataList,
    };
