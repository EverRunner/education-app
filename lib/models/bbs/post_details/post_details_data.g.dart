// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_details_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDetailsData _$PostDetailsDataFromJson(Map<String, dynamic> json) =>
    PostDetailsData(
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
      contact: json['contact'],
      contactnumber: json['contactnumber'],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      likecount: json['likecount'] as int?,
      postcount: json['postcount'] as int?,
      browsecount: json['browsecount'] as int?,
      islike: json['islike'] as int?,
      islikeuser: json['islikeuser'] as int?,
      yibeiMember: json['yibei_member'] == null
          ? null
          : YibeiMember.fromJson(json['yibei_member'] as Map<String, dynamic>),
      yibeiBbsCategory: json['yibei_bbs_category'] == null
          ? null
          : YibeiBbsCategory.fromJson(
              json['yibei_bbs_category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostDetailsDataToJson(PostDetailsData instance) =>
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
      'contact': instance.contact,
      'contactnumber': instance.contactnumber,
      'createdAt': instance.createdAt?.toIso8601String(),
      'likecount': instance.likecount,
      'postcount': instance.postcount,
      'browsecount': instance.browsecount,
      'islike': instance.islike,
      'islikeuser': instance.islikeuser,
      'yibei_member': instance.yibeiMember,
      'yibei_bbs_category': instance.yibeiBbsCategory,
    };
