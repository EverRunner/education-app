// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_list_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentListData _$ContentListDataFromJson(Map<String, dynamic> json) =>
    ContentListData(
      count: json['count'] as int?,
      rows: (json['rows'] as List<dynamic>?)
          ?.map((e) => ContentListRow.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContentListDataToJson(ContentListData instance) =>
    <String, dynamic>{
      'count': instance.count,
      'rows': instance.rows,
    };
