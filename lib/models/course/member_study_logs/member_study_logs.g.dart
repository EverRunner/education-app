// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_study_logs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberStudyLogs _$MemberStudyLogsFromJson(Map<String, dynamic> json) =>
    MemberStudyLogs(
      status: json['status'] as bool?,
      count: json['count'] as int?,
      dataList: (json['dataList'] as List<dynamic>?)
          ?.map((e) => StudyLogsDataList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MemberStudyLogsToJson(MemberStudyLogs instance) =>
    <String, dynamic>{
      'status': instance.status,
      'count': instance.count,
      'dataList': instance.dataList,
    };
