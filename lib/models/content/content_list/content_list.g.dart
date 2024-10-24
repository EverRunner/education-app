// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentList _$ContentListFromJson(Map<String, dynamic> json) => ContentList(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : ContentListData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContentListToJson(ContentList instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
