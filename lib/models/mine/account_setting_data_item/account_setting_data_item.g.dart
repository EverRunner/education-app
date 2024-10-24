// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_setting_data_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountSettingDataItem _$AccountSettingDataItemFromJson(
        Map<String, dynamic> json) =>
    AccountSettingDataItem(
      title: json['title'] as String?,
      value: json['value'] as String?,
      path: json['path'] as String?,
      showIcon: json['showIcon'] as bool?,
    );

Map<String, dynamic> _$AccountSettingDataItemToJson(
        AccountSettingDataItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'value': instance.value,
      'path': instance.path,
      'showIcon': instance.showIcon,
    };
