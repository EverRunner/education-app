// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadFile _$UploadFileFromJson(Map<String, dynamic> json) => UploadFile(
      status: json['status'] as bool?,
      path: json['path'] as String?,
    );

Map<String, dynamic> _$UploadFileToJson(UploadFile instance) =>
    <String, dynamic>{
      'status': instance.status,
      'path': instance.path,
    };
