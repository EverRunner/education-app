// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compound_test_request_list_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompoundTestRequestListRow _$CompoundTestRequestListRowFromJson(
        Map<String, dynamic> json) =>
    CompoundTestRequestListRow(
      id: json['id'] as int?,
      progressid: json['progressid'],
      progresscourseid: json['progresscourseid'],
      progresscoursechatperid: json['progresscoursechatperid'],
      progresscoursechatperdcwordsid: json['progresscoursechatperdcwordsid'],
      chapterrequestid: json['chapterrequestid'] as int?,
      memberid: json['memberid'] as int?,
      requestpaperid: json['requestpaperid'],
      requestid: json['requestid'],
      category: json['category'],
      content: json['content'] as String?,
      title: json['title'] as String?,
      startdate: json['startdate'] == null
          ? null
          : DateTime.parse(json['startdate'] as String),
      enddate: json['enddate'] == null
          ? null
          : DateTime.parse(json['enddate'] as String),
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

Map<String, dynamic> _$CompoundTestRequestListRowToJson(
        CompoundTestRequestListRow instance) =>
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
      'category': instance.category,
      'content': instance.content,
      'title': instance.title,
      'startdate': instance.startdate?.toIso8601String(),
      'enddate': instance.enddate?.toIso8601String(),
      'memberanswser': instance.memberanswser,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'yibei_requestion_const_option': instance.yibeiRequestionConstOption,
    };
