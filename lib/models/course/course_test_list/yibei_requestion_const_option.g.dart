// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yibei_requestion_const_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YibeiRequestionConstOption _$YibeiRequestionConstOptionFromJson(
        Map<String, dynamic> json) =>
    YibeiRequestionConstOption(
      id: json['id'] as int?,
      requestid: json['requestid'] as int?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      iscorrectoption: json['iscorrectoption'] as int?,
      sort: json['sort'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$YibeiRequestionConstOptionToJson(
        YibeiRequestionConstOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestid': instance.requestid,
      'title': instance.title,
      'content': instance.content,
      'iscorrectoption': instance.iscorrectoption,
      'sort': instance.sort,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
