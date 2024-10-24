// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bbs_type_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BbsTypeItem _$BbsTypeItemFromJson(Map<String, dynamic> json) => BbsTypeItem(
      title: json['title'] as String?,
      id: json['id'] as String?,
      radiusType: json['radiusType'] as String?,
      display: json['display'] as bool?,
    );

Map<String, dynamic> _$BbsTypeItemToJson(BbsTypeItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'id': instance.id,
      'radiusType': instance.radiusType,
      'display': instance.display,
    };
