// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_test_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseTestList _$CourseTestListFromJson(Map<String, dynamic> json) =>
    CourseTestList(
      status: json['status'] as bool?,
      dataList: (json['dataList'] as List<dynamic>?)
          ?.map((e) => CourseTestListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseTestListToJson(CourseTestList instance) =>
    <String, dynamic>{
      'status': instance.status,
      'dataList': instance.dataList,
    };
