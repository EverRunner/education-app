// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_statistics_info_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorStatisticsInfoData _$AuthorStatisticsInfoDataFromJson(
        Map<String, dynamic> json) =>
    AuthorStatisticsInfoData(
      username: json['username'] as String?,
      avatar: json['avatar'] as String?,
      followcount: json['followcount'] as int?,
      postcount: json['postcount'] as int?,
      likecount: json['likecount'] as int?,
      viewcount: json['viewcount'] as int?,
      islikeuser: json['islikeuser'] as int?,
    );

Map<String, dynamic> _$AuthorStatisticsInfoDataToJson(
        AuthorStatisticsInfoData instance) =>
    <String, dynamic>{
      'username': instance.username,
      'avatar': instance.avatar,
      'followcount': instance.followcount,
      'postcount': instance.postcount,
      'likecount': instance.likecount,
      'viewcount': instance.viewcount,
      'islikeuser': instance.islikeuser,
    };
