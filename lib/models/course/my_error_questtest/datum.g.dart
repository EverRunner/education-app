// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
      id: json['id'] as int?,
      memberid: json['memberid'] as int?,
      courseid: json['courseid'] as int?,
      chapterid: json['chapterid'] as int?,
      requestid: json['requestid'] as int?,
      requesttitle: json['requesttitle'] as String?,
      content: json['content'] as String?,
      requestcategory: json['requestcategory'] as int?,
      memberanswser: json['memberanswser'],
      status: json['status'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      yibeiCourse: json['yibei_course'] == null
          ? null
          : YibeiCourse.fromJson(json['yibei_course'] as Map<String, dynamic>),
      yibeiCourseChapter: json['yibei_course_chapter'] == null
          ? null
          : YibeiCourseChapter.fromJson(
              json['yibei_course_chapter'] as Map<String, dynamic>),
      yibeiRequestionConst: json['yibei_requestion_const'] == null
          ? null
          : YibeiRequestionConst.fromJson(
              json['yibei_requestion_const'] as Map<String, dynamic>),
      yibeiRequestionConstOption: (json['yibei_requestion_const_option']
              as List<dynamic>?)
          ?.map((e) =>
              YibeiRequestionConstOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      yibeiNewdcwordPaperConst:
          (json['yibei_newdcword_paper_const'] as List<dynamic>?)
              ?.map((e) =>
                  YibeiNewdcwordPaperConst.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
      'id': instance.id,
      'memberid': instance.memberid,
      'courseid': instance.courseid,
      'chapterid': instance.chapterid,
      'requestid': instance.requestid,
      'requesttitle': instance.requesttitle,
      'content': instance.content,
      'requestcategory': instance.requestcategory,
      'memberanswser': instance.memberanswser,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'yibei_course': instance.yibeiCourse,
      'yibei_course_chapter': instance.yibeiCourseChapter,
      'yibei_requestion_const': instance.yibeiRequestionConst,
      'yibei_requestion_const_option': instance.yibeiRequestionConstOption,
      'yibei_newdcword_paper_const': instance.yibeiNewdcwordPaperConst,
    };
