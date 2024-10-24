// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_study_statics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeekStudyStatics _$WeekStudyStaticsFromJson(Map<String, dynamic> json) =>
    WeekStudyStatics(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeekStudyStaticsToJson(WeekStudyStatics instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
