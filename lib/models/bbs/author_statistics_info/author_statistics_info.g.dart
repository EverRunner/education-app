// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_statistics_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorStatisticsInfo _$AuthorStatisticsInfoFromJson(
        Map<String, dynamic> json) =>
    AuthorStatisticsInfo(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : AuthorStatisticsInfoData.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthorStatisticsInfoToJson(
        AuthorStatisticsInfo instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
