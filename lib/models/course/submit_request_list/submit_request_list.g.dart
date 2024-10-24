// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_request_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitRequestList _$SubmitRequestListFromJson(Map<String, dynamic> json) =>
    SubmitRequestList(
      requestid: json['requestid'] as int?,
      title: json['title'] as String?,
      category: json['category'] as int?,
      memberanswser: json['memberanswser'] as int?,
      status: json['status'] as int?,
    );

Map<String, dynamic> _$SubmitRequestListToJson(SubmitRequestList instance) =>
    <String, dynamic>{
      'requestid': instance.requestid,
      'title': instance.title,
      'category': instance.category,
      'memberanswser': instance.memberanswser,
      'status': instance.status,
    };
