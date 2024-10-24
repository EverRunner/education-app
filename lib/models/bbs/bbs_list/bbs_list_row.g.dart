// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bbs_list_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BbsListRow _$BbsListRowFromJson(Map<String, dynamic> json) => BbsListRow(
      id: json['id'] as int?,
      title: json['title'],
      images: json['images'],
      category: json['category'] as int?,
      content: json['content'] as String?,
      vedio: json['vedio'] as String?,
      memberid: json['memberid'] as int?,
      latitude: json['latitude'],
      longitude: json['longitude'],
      location: json['location'],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      distance: json['distance'],
      likecount: json['likecount'] as int?,
      browsecount: json['browsecount'] as int?,
      islike: json['islike'] as int?,
      yibeiMember: json['yibei_member'] == null
          ? null
          : YibeiMember.fromJson(json['yibei_member'] as Map<String, dynamic>),
      yibeiBbsCategory: json['yibei_bbs_category'] == null
          ? null
          : YibeiBbsCategory.fromJson(
              json['yibei_bbs_category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BbsListRowToJson(BbsListRow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'images': instance.images,
      'category': instance.category,
      'content': instance.content,
      'vedio': instance.vedio,
      'memberid': instance.memberid,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'location': instance.location,
      'createdAt': instance.createdAt?.toIso8601String(),
      'distance': instance.distance,
      'likecount': instance.likecount,
      'browsecount': instance.browsecount,
      'islike': instance.islike,
      'yibei_member': instance.yibeiMember,
      'yibei_bbs_category': instance.yibeiBbsCategory,
    };
