// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mine_menu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MineMenuItem _$MineMenuItemFromJson(Map<String, dynamic> json) => MineMenuItem(
      title: json['title'] as String?,
      path: json['path'] as String?,
      icon: json['icon'] as String?,
      display: json['display'] as bool?,
    );

Map<String, dynamic> _$MineMenuItemToJson(MineMenuItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'path': instance.path,
      'icon': instance.icon,
      'display': instance.display,
    };
