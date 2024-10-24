// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_chapter_study_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserChapterStudyLog _$UserChapterStudyLogFromJson(Map<String, dynamic> json) =>
    UserChapterStudyLog(
      status: json['status'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserChapterStudyLogToJson(
        UserChapterStudyLog instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
