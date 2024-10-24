// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnswerList _$AnswerListFromJson(Map<String, dynamic> json) => AnswerList(
      id: json['id'] as int?,
      title: json['title'] as String?,
      iscorrectoption: json['iscorrectoption'] as int?,
    );

Map<String, dynamic> _$AnswerListToJson(AnswerList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'iscorrectoption': instance.iscorrectoption,
    };
