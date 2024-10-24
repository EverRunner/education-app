// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_chapter_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentChapterProgress _$CurrentChapterProgressFromJson(
        Map<String, dynamic> json) =>
    CurrentChapterProgress(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CurrentChapterProgressToJson(
        CurrentChapterProgress instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
