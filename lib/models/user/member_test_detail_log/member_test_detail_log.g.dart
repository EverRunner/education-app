// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_test_detail_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberTestDetailLog _$MemberTestDetailLogFromJson(Map<String, dynamic> json) =>
    MemberTestDetailLog(
      status: json['status'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              MemberTestDetailLogDatum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MemberTestDetailLogToJson(
        MemberTestDetailLog instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
