// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_test_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChapterTestResult _$ChapterTestResultFromJson(Map<String, dynamic> json) =>
    ChapterTestResult(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : ChapterTestResultData.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChapterTestResultToJson(ChapterTestResult instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
