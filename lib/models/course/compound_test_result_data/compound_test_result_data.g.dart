// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compound_test_result_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompoundTestResultData _$CompoundTestResultDataFromJson(
        Map<String, dynamic> json) =>
    CompoundTestResultData(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : CompoundTestResultDataItem.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompoundTestResultDataToJson(
        CompoundTestResultData instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
