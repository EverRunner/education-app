// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_list_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentListRow _$ContentListRowFromJson(Map<String, dynamic> json) =>
    ContentListRow(
      id: json['id'] as int?,
      title: json['title'] as String?,
      thumb: json['thumb'] as String?,
      category: json['category'] as int?,
      description: json['description'] as String?,
      content: json['content'],
      sort: json['sort'],
      creatuserid: json['creatuserid'] as int?,
      status: json['status'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      yibeiContentCategory: json['yibei_content_category'] == null
          ? null
          : YibeiContentCategory.fromJson(
              json['yibei_content_category'] as Map<String, dynamic>),
      yibeiAdmin: json['yibei_admin'] == null
          ? null
          : YibeiAdmin.fromJson(json['yibei_admin'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContentListRowToJson(ContentListRow instance) =>
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
      'yibei_content_category': instance.yibeiContentCategory,
      'yibei_admin': instance.yibeiAdmin,
    };
