// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_word_test_result_datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudyWordTestResultDatum _$StudyWordTestResultDatumFromJson(
        Map<String, dynamic> json) =>
    StudyWordTestResultDatum(
      id: json['id'] as int?,
      memberid: json['memberid'] as int?,
      ordercode: json['ordercode'] as String?,
      title: json['title'] as String?,
      jonstring: json['jonstring'] as String?,
      status: json['status'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$StudyWordTestResultDatumToJson(
        StudyWordTestResultDatum instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberid': instance.memberid,
      'ordercode': instance.ordercode,
      'title': instance.title,
      'jonstring': instance.jonstring,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
