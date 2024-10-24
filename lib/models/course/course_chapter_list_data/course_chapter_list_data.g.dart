// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_chapter_list_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseChapterListData _$CourseChapterListDataFromJson(
        Map<String, dynamic> json) =>
    CourseChapterListData(
      status: json['status'] as bool?,
      dataList: (json['dataList'] as List<dynamic>?)
          ?.map((e) => DataList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseChapterListDataToJson(
        CourseChapterListData instance) =>
    <String, dynamic>{
      'status': instance.status,
      'dataList': instance.dataList,
    };
