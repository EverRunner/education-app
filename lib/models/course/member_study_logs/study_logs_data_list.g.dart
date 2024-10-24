// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_logs_data_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudyLogsDataList _$StudyLogsDataListFromJson(Map<String, dynamic> json) =>
    StudyLogsDataList(
      courseid: json['courseid'] as int?,
      chapterid: json['chapterid'] as int?,
      progressid: json['progressid'] as int?,
      couserName: json['couserName'] as String?,
      courseType: json['courseType'],
      courseThumb: json['courseThumb'] as String?,
      chapterName: json['chapterName'] as String?,
      chapterThumb: json['chapterThumb'] as String?,
      courseChapterList: (json['courseChapterList'] as List<dynamic>?)
          ?.map((e) => CourseChapterList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StudyLogsDataListToJson(StudyLogsDataList instance) =>
    <String, dynamic>{
      'courseid': instance.courseid,
      'chapterid': instance.chapterid,
      'progressid': instance.progressid,
      'couserName': instance.couserName,
      'courseType': instance.courseType,
      'courseThumb': instance.courseThumb,
      'chapterName': instance.chapterName,
      'chapterThumb': instance.chapterThumb,
      'courseChapterList': instance.courseChapterList,
    };
