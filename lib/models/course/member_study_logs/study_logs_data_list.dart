import 'package:json_annotation/json_annotation.dart';

import 'course_chapter_list.dart';

part 'study_logs_data_list.g.dart';

@JsonSerializable()
class StudyLogsDataList {
  int? courseid;
  int? chapterid;
  int? progressid;
  String? couserName;
  dynamic courseType;
  String? courseThumb;
  String? chapterName;
  String? chapterThumb;
  List<CourseChapterList>? courseChapterList;

  StudyLogsDataList({
    this.courseid,
    this.chapterid,
    this.progressid,
    this.couserName,
    this.courseType,
    this.courseThumb,
    this.chapterName,
    this.chapterThumb,
    this.courseChapterList,
  });

  factory StudyLogsDataList.fromJson(Map<String, dynamic> json) {
    return _$StudyLogsDataListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$StudyLogsDataListToJson(this);
}
