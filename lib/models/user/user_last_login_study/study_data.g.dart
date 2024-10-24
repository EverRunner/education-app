// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudyData _$StudyDataFromJson(Map<String, dynamic> json) => StudyData(
      videoStudyTimes: json['video_study_times'] as int?,
      keywordchenTestTimes: json['keywordchen_test_times'] as int?,
      keywordenTestTimes: json['keyworden_test_times'] as int?,
      unitTestTimes: json['unit_test_times'] as int?,
    );

Map<String, dynamic> _$StudyDataToJson(StudyData instance) => <String, dynamic>{
      'video_study_times': instance.videoStudyTimes,
      'keywordchen_test_times': instance.keywordchenTestTimes,
      'keyworden_test_times': instance.keywordenTestTimes,
      'unit_test_times': instance.unitTestTimes,
    };
