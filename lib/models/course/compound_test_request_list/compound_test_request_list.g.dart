// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compound_test_request_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompoundTestRequestList _$CompoundTestRequestListFromJson(
        Map<String, dynamic> json) =>
    CompoundTestRequestList(
      status: json['status'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              CompoundTestRequestListRow.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CompoundTestRequestListToJson(
        CompoundTestRequestList instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
