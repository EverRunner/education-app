import 'package:json_annotation/json_annotation.dart';

part 'course_chapter_set_next.g.dart';

@JsonSerializable()
class CourseChapterSetNext {
  bool? status;
  int? nextCourseid;
  int? nextChapterid;
  String? err;

  CourseChapterSetNext({
    this.status,
    this.nextCourseid,
    this.nextChapterid,
    this.err,
  });

  factory CourseChapterSetNext.fromJson(Map<String, dynamic> json) {
    return _$CourseChapterSetNextFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CourseChapterSetNextToJson(this);
}
