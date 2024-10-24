// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_chapter_data_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseChapterDataItem _$CourseChapterDataItemFromJson(
        Map<String, dynamic> json) =>
    CourseChapterDataItem(
      id: json['id'] as int?,
      courseid: json['courseid'] as int?,
      title: json['title'] as String?,
      thumb: json['thumb'] as String?,
      description: json['description'] as String?,
      videopath: json['videopath'] as String?,
      videotimes: json['videotimes'] as String?,
      studystep: json['studystep'] as String?,
      vediotimesint: json['vediotimesint'] as int?,
      sort: json['sort'] as int?,
      isfinal: json['isfinal'] as int?,
      isreview: json['isreview'] as int?,
      isbindword: json['isbindword'] as int?,
      content: json['content'],
      isdelete: json['isdelete'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      dcwordsList: (json['dcwordsList'] as List<dynamic>?)
          ?.map((e) => DcwordsList.fromJson(e as Map<String, dynamic>))
          .toList(),
      requestPaperList: (json['requestPaperList'] as List<dynamic>?)
          ?.map((e) => RequestPaperList.fromJson(e as Map<String, dynamic>))
          .toList(),
      courseObj: json['courseObj'] == null
          ? null
          : CourseObj.fromJson(json['courseObj'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CourseChapterDataItemToJson(
        CourseChapterDataItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseid': instance.courseid,
      'title': instance.title,
      'thumb': instance.thumb,
      'description': instance.description,
      'videopath': instance.videopath,
      'videotimes': instance.videotimes,
      'studystep': instance.studystep,
      'vediotimesint': instance.vediotimesint,
      'sort': instance.sort,
      'isfinal': instance.isfinal,
      'isreview': instance.isreview,
      'isbindword': instance.isbindword,
      'content': instance.content,
      'isdelete': instance.isdelete,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'dcwordsList': instance.dcwordsList,
      'requestPaperList': instance.requestPaperList,
      'courseObj': instance.courseObj,
    };
