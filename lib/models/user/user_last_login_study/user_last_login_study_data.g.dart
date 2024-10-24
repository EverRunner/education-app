// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_last_login_study_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLastLoginStudyData _$UserLastLoginStudyDataFromJson(
        Map<String, dynamic> json) =>
    UserLastLoginStudyData(
      studyData: json['studyData'] == null
          ? null
          : StudyData.fromJson(json['studyData'] as Map<String, dynamic>),
      unitTestAvg: (json['unitTestAvg'] as num?)?.toDouble(),
      kgskgAvg: json['kgskgAvg'] as int?,
      mykgAvg: json['mykgAvg'] as int?,
    );

Map<String, dynamic> _$UserLastLoginStudyDataToJson(
        UserLastLoginStudyData instance) =>
    <String, dynamic>{
      'studyData': instance.studyData,
      'unitTestAvg': instance.unitTestAvg,
      'kgskgAvg': instance.kgskgAvg,
      'mykgAvg': instance.mykgAvg,
    };
