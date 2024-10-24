// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yibei_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YibeiMember _$YibeiMemberFromJson(Map<String, dynamic> json) => YibeiMember(
      username: json['username'] as String?,
      phone: json['phone'],
      email: json['email'] as String?,
      avatar: json['avatar'],
    );

Map<String, dynamic> _$YibeiMemberToJson(YibeiMember instance) =>
    <String, dynamic>{
      'username': instance.username,
      'phone': instance.phone,
      'email': instance.email,
      'avatar': instance.avatar,
    };
