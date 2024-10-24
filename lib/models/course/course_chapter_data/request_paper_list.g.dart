// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_paper_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestPaperList _$RequestPaperListFromJson(Map<String, dynamic> json) =>
    RequestPaperList(
      id: json['id'] as int?,
      coursechapterid: json['coursechapterid'] as int?,
      requestpaperid: json['requestpaperid'] as int?,
    );

Map<String, dynamic> _$RequestPaperListToJson(RequestPaperList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'coursechapterid': instance.coursechapterid,
      'requestpaperid': instance.requestpaperid,
    };
