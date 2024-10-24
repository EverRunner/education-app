// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compound_test_result_data_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompoundTestResultDataItem _$CompoundTestResultDataItemFromJson(
        Map<String, dynamic> json) =>
    CompoundTestResultDataItem(
      id: json['id'] as int?,
      memberid: json['memberid'] as int?,
      allrequestcount: json['allrequestcount'] as int?,
      correctcount: json['correctcount'] as int?,
      errorcount: json['errorcount'] as int?,
      score: json['score'] as String?,
      startdate: json['startdate'] == null
          ? null
          : DateTime.parse(json['startdate'] as String),
      enddate: json['enddate'] == null
          ? null
          : DateTime.parse(json['enddate'] as String),
      status: json['status'] as int?,
      remark: json['remark'],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      requestpaperid: json['requestpaperid'],
    );

Map<String, dynamic> _$CompoundTestResultDataItemToJson(
        CompoundTestResultDataItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberid': instance.memberid,
      'allrequestcount': instance.allrequestcount,
      'correctcount': instance.correctcount,
      'errorcount': instance.errorcount,
      'score': instance.score,
      'startdate': instance.startdate?.toIso8601String(),
      'enddate': instance.enddate?.toIso8601String(),
      'status': instance.status,
      'remark': instance.remark,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'requestpaperid': instance.requestpaperid,
    };
