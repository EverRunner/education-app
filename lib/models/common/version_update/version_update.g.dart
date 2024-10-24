// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionUpdate _$VersionUpdateFromJson(Map<String, dynamic> json) =>
    VersionUpdate(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : VersionUpdateData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VersionUpdateToJson(VersionUpdate instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
