// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_category_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceCategoryItem _$ResourceCategoryItemFromJson(
        Map<String, dynamic> json) =>
    ResourceCategoryItem(
      title: json['title'] as String?,
      id: json['id'] as int?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$ResourceCategoryItemToJson(
        ResourceCategoryItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'id': instance.id,
      'type': instance.type,
    };
