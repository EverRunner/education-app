// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Progress _$ProgressFromJson(Map<String, dynamic> json) => Progress(
      id: json['id'] as int?,
      memberid: json['memberid'] as int?,
      startdate: json['startdate'] == null
          ? null
          : DateTime.parse(json['startdate'] as String),
      enddate: json['enddate'],
      type: json['type'] as int?,
      currentcourseid: json['currentcourseid'] as int?,
      currentcoursechapterid: json['currentcoursechapterid'] as int?,
      completecoursecount: json['completecoursecount'],
      allcoursecount: json['allcoursecount'],
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
      stepflag: json['stepflag'] as int?,
    );

Map<String, dynamic> _$ProgressToJson(Progress instance) => <String, dynamic>{
      'id': instance.id,
      'memberid': instance.memberid,
      'startdate': instance.startdate?.toIso8601String(),
      'enddate': instance.enddate,
      'type': instance.type,
      'currentcourseid': instance.currentcourseid,
      'currentcoursechapterid': instance.currentcoursechapterid,
      'completecoursecount': instance.completecoursecount,
      'allcoursecount': instance.allcoursecount,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'yibei_course': instance.yibeiCourse,
      'yibei_course_chapter': instance.yibeiCourseChapter,
      'stepflag': instance.stepflag,
    };
