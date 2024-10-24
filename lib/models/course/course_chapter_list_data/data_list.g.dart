// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataList _$DataListFromJson(Map<String, dynamic> json) => DataList(
      id: json['id'] as int?,
      courseid: json['courseid'] as int?,
      title: json['title'] as String?,
      thumb: json['thumb'] as String?,
      description: json['description'] as String?,
      videopath: json['videopath'] as String?,
      videotimes: json['videotimes'],
      vediotimesint: json['vediotimesint'] as int?,
      sort: json['sort'] as int?,
      isfinal: json['isfinal'] as int?,
      isreview: json['isreview'] as int?,
      isbindword: json['isbindword'] as int?,
      studystep: json['studystep'] as String?,
      content: json['content'],
      isdelete: json['isdelete'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DataListToJson(DataList instance) => <String, dynamic>{
      'id': instance.id,
      'courseid': instance.courseid,
      'title': instance.title,
      'thumb': instance.thumb,
      'description': instance.description,
      'videopath': instance.videopath,
      'videotimes': instance.videotimes,
      'vediotimesint': instance.vediotimesint,
      'sort': instance.sort,
      'isfinal': instance.isfinal,
      'isreview': instance.isreview,
      'isbindword': instance.isbindword,
      'studystep': instance.studystep,
      'content': instance.content,
      'isdelete': instance.isdelete,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
