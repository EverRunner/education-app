// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_test_detail_log_datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberTestDetailLogDatum _$MemberTestDetailLogDatumFromJson(
        Map<String, dynamic> json) =>
    MemberTestDetailLogDatum(
      errorTestbeforekeywordTime: json['error_testbeforekeyword_time'] == null
          ? null
          : DateTime.parse(json['error_testbeforekeyword_time'] as String),
      errorTestbeforewordTime: json['error_testbeforeword_time'] == null
          ? null
          : DateTime.parse(json['error_testbeforeword_time'] as String),
      errorTestScore: (json['error_test_score'] as num?)?.toDouble(),
      gaopingTestbeforekeywordTime: json['gaoping_testbeforekeyword_time'] ==
              null
          ? null
          : DateTime.parse(json['gaoping_testbeforekeyword_time'] as String),
      gaopingTestbeforewordTime: json['gaoping_testbeforeword_time'],
      gaopingTestbeforewordScore:
          (json['gaoping_testbeforeword_score'] as num?)?.toDouble(),
      zongheTestbeforekeywordTime: json['zonghe_testbeforekeyword_time'] == null
          ? null
          : DateTime.parse(json['zonghe_testbeforekeyword_time'] as String),
      zongheTestbeforewordTime: json['zonghe_testbeforeword_time'],
        zongheTestbeforewordScore:
          (json['zonghe_testbeforeword_score'] as num?)?.toDouble(),
      strainTestbeforekeywordTime: json['strain_testbeforekeyword_time'] == null
          ? null
          : DateTime.parse(json['strain_testbeforekeyword_time'] as String),
      strainTestbeforewordTime: json['strain_testbeforeword_time'] == null
          ? null
          : DateTime.parse(json['strain_testbeforeword_time'] as String),
      strainTestbeforewordScore:
          (json['strain_testbeforeword_score'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MemberTestDetailLogDatumToJson(
        MemberTestDetailLogDatum instance) =>
    <String, dynamic>{
      'error_testbeforekeyword_time':
          instance.errorTestbeforekeywordTime?.toIso8601String(),
      'error_testbeforeword_time':
          instance.errorTestbeforewordTime?.toIso8601String(),
      'error_test_score': instance.errorTestScore,
      'gaoping_testbeforekeyword_time':
          instance.gaopingTestbeforekeywordTime?.toIso8601String(),
      'gaoping_testbeforeword_time': instance.gaopingTestbeforewordTime,
      'gaoping_testbeforeword_score': instance.gaopingTestbeforewordScore,
      'zonghe_testbeforekeyword_time':
          instance.zongheTestbeforekeywordTime?.toIso8601String(),
      'zonghe_testbeforeword_time': instance.zongheTestbeforewordTime,
      'zonghe_testbeforeword_score': instance.zongheTestbeforewordScore,
      'strain_testbeforekeyword_time':
          instance.strainTestbeforekeywordTime?.toIso8601String(),
      'strain_testbeforeword_time':
          instance.strainTestbeforewordTime?.toIso8601String(),
      'strain_testbeforeword_score': instance.strainTestbeforewordScore,
    };
