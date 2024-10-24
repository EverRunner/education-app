import 'package:json_annotation/json_annotation.dart';

part 'yibei_course_chapter.g.dart';

@JsonSerializable()
class YibeiCourseChapter {
  String? title;

  YibeiCourseChapter({this.title});

  factory YibeiCourseChapter.fromJson(Map<String, dynamic> json) {
    return _$YibeiCourseChapterFromJson(json);
  }

  Map<String, dynamic> toJson() => _$YibeiCourseChapterToJson(this);
}
