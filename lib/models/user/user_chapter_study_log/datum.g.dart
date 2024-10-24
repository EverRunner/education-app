// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
      lastVideotime: json['lastVideotime'] == null
          ? null
          : DateTime.parse(json['lastVideotime'] as String),
      keywordStudyChen: json['keyword_study_chen'] == null
          ? null
          : DateTime.parse(json['keyword_study_chen'] as String),
      keywordTestChen: json['keyword_test_chen'] == null
          ? null
          : DateTime.parse(json['keyword_test_chen'] as String),
      keywordTestScoreChen: json['keyword_test_score_chen'] as int?,
      keywordStudyEn: json['keyword_study_en'] == null
          ? null
          : DateTime.parse(json['keyword_study_en'] as String),
      keywordTestEn: json['keyword_test_en'] == null
          ? null
          : DateTime.parse(json['keyword_test_en'] as String),
      keywordTestScoreEn: json['keyword_test_score_en'] as int?,
      uniTestEn: json['uni_test_en'] == null
          ? null
          : DateTime.parse(json['uni_test_en'] as String),
      uniTestScoreEn: json['uni_test_score_en'] as int?,
    );

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
      'lastVideotime': instance.lastVideotime?.toIso8601String(),
      'keyword_study_chen': instance.keywordStudyChen?.toIso8601String(),
      'keyword_test_chen': instance.keywordTestChen?.toIso8601String(),
      'keyword_test_score_chen': instance.keywordTestScoreChen,
      'keyword_study_en': instance.keywordStudyEn?.toIso8601String(),
      'keyword_test_en': instance.keywordTestEn?.toIso8601String(),
      'keyword_test_score_en': instance.keywordTestScoreEn,
      'uni_test_en': instance.uniTestEn?.toIso8601String(),
      'uni_test_score_en': instance.uniTestScoreEn,
    };
