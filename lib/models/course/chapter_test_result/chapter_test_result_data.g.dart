// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_test_result_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChapterTestResultData _$ChapterTestResultDataFromJson(
        Map<String, dynamic> json) =>
    ChapterTestResultData(
      id: json['id'] as int?,
      progressid: json['progressid'] as int?,
      progresscourseid: json['progresscourseid'] as int?,
      progresscoursechatperid: json['progresscoursechatperid'] as int?,
      memberid: json['memberid'] as int?,
      requestpaperid: json['requestpaperid'] as int?,
      currentindex: json['currentindex'],
      allrequestcount: json['allrequestcount'] as int?,
      correctcount: json['correctcount'] as int?,
      errorcount: json['errorcount'] as int?,
      score: json['score'] as int?,
      startdate: json['startdate'] == null
          ? null
          : DateTime.parse(json['startdate'] as String),
      enddate: json['enddate'] == null
          ? null
          : DateTime.parse(json['enddate'] as String),
      status: json['status'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ChapterTestResultDataToJson(
        ChapterTestResultData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'progressid': instance.progressid,
      'progresscourseid': instance.progresscourseid,
      'progresscoursechatperid': instance.progresscoursechatperid,
      'memberid': instance.memberid,
      'requestpaperid': instance.requestpaperid,
      'currentindex': instance.currentindex,
      'allrequestcount': instance.allrequestcount,
      'correctcount': instance.correctcount,
      'errorcount': instance.errorcount,
      'score': instance.score,
      'startdate': instance.startdate?.toIso8601String(),
      'enddate': instance.enddate?.toIso8601String(),
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
