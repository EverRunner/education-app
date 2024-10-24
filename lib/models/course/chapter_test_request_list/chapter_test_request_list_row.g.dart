// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_test_request_list_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChapterTestRequestListRow _$ChapterTestRequestListRowFromJson(
        Map<String, dynamic> json) =>
    ChapterTestRequestListRow(
      id: json['id'] as int?,
      progressid: json['progressid'] as int?,
      progresscourseid: json['progresscourseid'] as int?,
      progresscoursechatperid: json['progresscoursechatperid'] as int?,
      progresscoursechatperdcwordsid: json['progresscoursechatperdcwordsid'],
      chapterrequestid: json['chapterrequestid'] as int?,
      memberid: json['memberid'] as int?,
      requestpaperid: json['requestpaperid'] as int?,
      requestid: json['requestid'] as int?,
      title: json['title'] as String?,
      category: json['category'] as int?,
      content: json['content'],
      startdate: json['startdate'],
      enddate: json['enddate'],
      memberanswser: json['memberanswser'] as String?,
      status: json['status'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      yibeiRequestionConstOption: (json['yibei_requestion_const_option']
              as List<dynamic>?)
          ?.map((e) =>
              YibeiRequestionConstOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChapterTestRequestListRowToJson(
        ChapterTestRequestListRow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'progressid': instance.progressid,
      'progresscourseid': instance.progresscourseid,
      'progresscoursechatperid': instance.progresscoursechatperid,
      'progresscoursechatperdcwordsid': instance.progresscoursechatperdcwordsid,
      'chapterrequestid': instance.chapterrequestid,
      'memberid': instance.memberid,
      'requestpaperid': instance.requestpaperid,
      'requestid': instance.requestid,
      'title': instance.title,
      'category': instance.category,
      'content': instance.content,
      'startdate': instance.startdate,
      'enddate': instance.enddate,
      'memberanswser': instance.memberanswser,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'yibei_requestion_const_option': instance.yibeiRequestionConstOption,
    };
