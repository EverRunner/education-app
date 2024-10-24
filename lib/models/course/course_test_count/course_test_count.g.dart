// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_test_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseTestCount _$CourseTestCountFromJson(Map<String, dynamic> json) =>
    CourseTestCount(
      status: json['status'] as bool?,
      testList: (json['testList'] as List<dynamic>?)
          ?.map((e) => TestList.fromJson(e as Map<String, dynamic>))
          .toList(),
      lefttestcount: json['lefttestcount'] as int?,
    );

Map<String, dynamic> _$CourseTestCountToJson(CourseTestCount instance) =>
    <String, dynamic>{
      'status': instance.status,
      'testList': instance.testList,
      'lefttestcount': instance.lefttestcount,
    };
