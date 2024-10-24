// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      currentweekstudytime: json['currentweekstudytime'] as int?,
      todaystudytime: json['todaystudytime'] as int?,
      currentWeekData: (json['currentWeekData'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      lastWeekData: (json['lastWeekData'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      sysavg: (json['sysavg'] as num?)?.toDouble(),
      sysAvgData: (json['sysAvgData'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      contrastlvoflastweek: (json['contrastlvoflastweek'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'currentweekstudytime': instance.currentweekstudytime,
      'todaystudytime': instance.todaystudytime,
      'currentWeekData': instance.currentWeekData,
      'lastWeekData': instance.lastWeekData,
      'sysavg': instance.sysavg,
      'sysAvgData': instance.sysAvgData,
      'contrastlvoflastweek': instance.contrastlvoflastweek,
    };
