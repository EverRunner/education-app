import 'package:json_annotation/json_annotation.dart';

import 'yibei_course.dart';
import 'yibei_course_chapter.dart';

part 'progress.g.dart';

@JsonSerializable()
class Progress {
  int? id;
  int? memberid;
  DateTime? startdate;
  dynamic enddate;
  int? type;
  int? currentcourseid;
  int? currentcoursechapterid;
  dynamic completecoursecount;
  dynamic allcoursecount;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  @JsonKey(name: 'yibei_course')
  YibeiCourse? yibeiCourse;
  @JsonKey(name: 'yibei_course_chapter')
  YibeiCourseChapter? yibeiCourseChapter;
  int? stepflag;

  Progress({
    this.id,
    this.memberid,
    this.startdate,
    this.enddate,
    this.type,
    this.currentcourseid,
    this.currentcoursechapterid,
    this.completecoursecount,
    this.allcoursecount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.yibeiCourse,
    this.yibeiCourseChapter,
    this.stepflag,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return _$ProgressFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProgressToJson(this);
}
