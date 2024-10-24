// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_test_request_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChapterTestRequestList _$ChapterTestRequestListFromJson(
        Map<String, dynamic> json) =>
    ChapterTestRequestList(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChapterTestRequestListToJson(
        ChapterTestRequestList instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
