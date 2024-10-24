import 'package:json_annotation/json_annotation.dart';

part 'yibei_course.g.dart';

@JsonSerializable()
class YibeiCourse {
  String? title;

  YibeiCourse({this.title});

  factory YibeiCourse.fromJson(Map<String, dynamic> json) {
    return _$YibeiCourseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$YibeiCourseToJson(this);
}
