// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_radar_statics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRadarStatics _$UserRadarStaticsFromJson(Map<String, dynamic> json) =>
    UserRadarStatics(
      status: json['status'] as bool?,
      disLastLoginTimes: (json['disLastLoginTimes'] as num?)?.toDouble(),
      data: (json['data'] as List<dynamic>?)
          ?.map(
              (e) => UserRadarStaticsDatum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserRadarStaticsToJson(UserRadarStatics instance) =>
    <String, dynamic>{
      'status': instance.status,
      'disLastLoginTimes': instance.disLastLoginTimes,
      'data': instance.data,
    };
