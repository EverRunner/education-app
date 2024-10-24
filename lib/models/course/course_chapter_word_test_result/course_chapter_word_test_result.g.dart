// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_chapter_word_test_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseChapterWordTestResult _$CourseChapterWordTestResultFromJson(
        Map<String, dynamic> json) =>
    CourseChapterWordTestResult(
      status: json['status'] as bool?,
      errorCount: json['errorCount'] as int?,
      rank: json['rank'] as int?,
      err: json['err'] as String?,
    );

Map<String, dynamic> _$CourseChapterWordTestResultToJson(
        CourseChapterWordTestResult instance) =>
    <String, dynamic>{
      'status': instance.status,
      'errorCount': instance.errorCount,
      'rank': instance.rank,
      'err': instance.err,
    };
