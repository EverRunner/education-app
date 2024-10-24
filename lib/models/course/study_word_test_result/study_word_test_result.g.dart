// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_word_test_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudyWordTestResult _$StudyWordTestResultFromJson(Map<String, dynamic> json) =>
    StudyWordTestResult(
      status: json['status'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              StudyWordTestResultDatum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StudyWordTestResultToJson(
        StudyWordTestResult instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
