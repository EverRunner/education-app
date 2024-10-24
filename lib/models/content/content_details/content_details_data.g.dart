// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_details_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentDetailsData _$ContentDetailsDataFromJson(Map<String, dynamic> json) =>
    ContentDetailsData(
      id: json['id'] as int?,
      title: json['title'] as String?,
      thumb: json['thumb'] as String?,
      category: json['category'] as int?,
      description: json['description'] as String?,
      content: json['content'],
      sort: json['sort'] as int?,
      creatuserid: json['creatuserid'] as int?,
      status: json['status'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ContentDetailsDataToJson(ContentDetailsData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'thumb': instance.thumb,
      'category': instance.category,
      'description': instance.description,
      'content': instance.content,
      'sort': instance.sort,
      'creatuserid': instance.creatuserid,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
