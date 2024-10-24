// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_submit_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseSubmitTest _$CourseSubmitTestFromJson(Map<String, dynamic> json) =>
    CourseSubmitTest(
      status: json['status'] as bool?,
      requestid: json['requestid'] as int?,
      isthreeerrorcount: json['isthreeerrorcount'] as bool?,
      lefttestcount: json['lefttestcount'] as int?,
      chapterrequestid: json['chapterrequestid'] as int?,
      rank: json['rank'] as int?,
    );

Map<String, dynamic> _$CourseSubmitTestToJson(CourseSubmitTest instance) =>
    <String, dynamic>{
      'status': instance.status,
      'requestid': instance.requestid,
      'isthreeerrorcount': instance.isthreeerrorcount,
      'lefttestcount': instance.lefttestcount,
      'chapterrequestid': instance.chapterrequestid,
      'rank': instance.rank,
    };
