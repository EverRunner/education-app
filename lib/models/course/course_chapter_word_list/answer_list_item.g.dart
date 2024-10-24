// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnswerListItem _$AnswerListItemFromJson(Map<String, dynamic> json) =>
    AnswerListItem(
      id: json['id'] as int?,
      title: json['title'] as String?,
      status: json['status'] as String?,
      iscorrectoption: json['iscorrectoption'] as int?,
    );

Map<String, dynamic> _$AnswerListItemToJson(AnswerListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'status': instance.status,
      'iscorrectoption': instance.iscorrectoption,
    };
