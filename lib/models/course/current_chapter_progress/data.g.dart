// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      id: json['id'] as int?,
      progressid: json['progressid'] as int?,
      progresscourseid: json['progresscourseid'],
      memberid: json['memberid'] as int?,
      courseid: json['courseid'] as int?,
      chapterid: json['chapterid'] as int?,
      sort: json['sort'] as int?,
      startdate: json['startdate'] == null
          ? null
          : DateTime.parse(json['startdate'] as String),
      enddate: json['enddate'],
      videosdate: json['videosdate'] == null
          ? null
          : DateTime.parse(json['videosdate'] as String),
      videoedate: json['videoedate'] == null
          ? null
          : DateTime.parse(json['videoedate'] as String),
      completevidoe: json['completevidoe'] as int?,
      completedcword: json['completedcword'] as int?,
      completerequest: json['completerequest'] as int?,
      isnotest: json['isnotest'] as int?,
      status: json['status'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'progressid': instance.progressid,
      'progresscourseid': instance.progresscourseid,
      'memberid': instance.memberid,
      'courseid': instance.courseid,
      'chapterid': instance.chapterid,
      'sort': instance.sort,
      'startdate': instance.startdate?.toIso8601String(),
      'enddate': instance.enddate,
      'videosdate': instance.videosdate?.toIso8601String(),
      'videoedate': instance.videoedate?.toIso8601String(),
      'completevidoe': instance.completevidoe,
      'completedcword': instance.completedcword,
      'completerequest': instance.completerequest,
      'isnotest': instance.isnotest,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
