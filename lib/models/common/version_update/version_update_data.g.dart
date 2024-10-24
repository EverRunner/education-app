// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_update_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionUpdateData _$VersionUpdateDataFromJson(Map<String, dynamic> json) =>
    VersionUpdateData(
      id: json['id'] as int?,
      appid: json['appid'] as String?,
      version: json['version'] as String?,
      description: json['description'] as String?,
      platform: json['platform'] as String?,
      downloadurl: json['downloadurl'] as String?,
      isforceupdate: json['isforceupdate'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$VersionUpdateDataToJson(VersionUpdateData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appid': instance.appid,
      'version': instance.version,
      'description': instance.description,
      'platform': instance.platform,
      'downloadurl': instance.downloadurl,
      'isforceupdate': instance.isforceupdate,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
