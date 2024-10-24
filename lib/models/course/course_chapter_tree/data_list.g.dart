// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataList _$DataListFromJson(Map<String, dynamic> json) => DataList(
      id: json['id'] as int?,
      title: json['title'] as String?,
      type: json['type'] as int?,
      thumb: json['thumb'] as String?,
      description: json['description'] as String?,
      content: json['content'] as String?,
      jifen: json['jifen'],
      author: json['author'] as String?,
      sort: json['sort'] as int?,
      status: json['status'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      yibeiCourseChapter: (json['yibei_course_chapter'] as List<dynamic>?)
          ?.map((e) => YibeiCourseChapter.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataListToJson(DataList instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'thumb': instance.thumb,
      'description': instance.description,
      'content': instance.content,
      'jifen': instance.jifen,
      'author': instance.author,
      'sort': instance.sort,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'yibei_course_chapter': instance.yibeiCourseChapter,
    };
