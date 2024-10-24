// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_chapter_set_next.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseChapterSetNext _$CourseChapterSetNextFromJson(
        Map<String, dynamic> json) =>
    CourseChapterSetNext(
      status: json['status'] as bool?,
      nextCourseid: json['nextCourseid'] as int?,
      nextChapterid: json['nextChapterid'] as int?,
      err: json['err'] as String?,
    );

Map<String, dynamic> _$CourseChapterSetNextToJson(
        CourseChapterSetNext instance) =>
    <String, dynamic>{
      'status': instance.status,
      'nextCourseid': instance.nextCourseid,
      'nextChapterid': instance.nextChapterid,
      'err': instance.err,
    };
