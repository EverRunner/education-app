// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yibei_requestion_const.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YibeiRequestionConst _$YibeiRequestionConstFromJson(
        Map<String, dynamic> json) =>
    YibeiRequestionConst(
      id: json['id'] as int?,
      title: json['title'] as String?,
      category: json['category'] as int?,
      typestring: json['typestring'] as String?,
      content: json['content'] as String?,
      sort: json['sort'] as int?,
      answeranalysis: json['answeranalysis'],
      status: json['status'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$YibeiRequestionConstToJson(
        YibeiRequestionConst instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'typestring': instance.typestring,
      'content': instance.content,
      'sort': instance.sort,
      'answeranalysis': instance.answeranalysis,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
