// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDetails _$PostDetailsFromJson(Map<String, dynamic> json) => PostDetails(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : PostDetailsData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostDetailsToJson(PostDetails instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
