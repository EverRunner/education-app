// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mine_personal_data_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MinePersonalDataItem _$MinePersonalDataItemFromJson(
        Map<String, dynamic> json) =>
    MinePersonalDataItem(
      title: json['title'] as String?,
      value: json['value'] as String?,
      path: json['path'] as String?,
    );

Map<String, dynamic> _$MinePersonalDataItemToJson(
        MinePersonalDataItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'value': instance.value,
      'path': instance.path,
    };
