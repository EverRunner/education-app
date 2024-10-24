// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yibei_course_chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YibeiCourseChapter _$YibeiCourseChapterFromJson(Map<String, dynamic> json) =>
    YibeiCourseChapter(
      id: json['id'] as int?,
      courseid: json['courseid'] as int?,
      title: json['title'] as String?,
      thumb: json['thumb'] as String?,
      description: json['description'],
      videopath: json['videopath'] as String?,
      videotimes: json['videotimes'] as String?,
      vediotimesint: json['vediotimesint'] as int?,
      sort: json['sort'] as int?,
      isfinal: json['isfinal'] as int?,
      isreview: json['isreview'] as int?,
      isbindword: json['isbindword'] as int?,
      content: json['content'],
      isdelete: json['isdelete'] as int?,
      studystep: json['studystep'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$YibeiCourseChapterToJson(YibeiCourseChapter instance) =>
    <String, dynamic>{
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
      'content': instance.content,
      'isdelete': instance.isdelete,
      'studystep': instance.studystep,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
