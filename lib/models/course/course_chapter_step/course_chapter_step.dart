import 'package:json_annotation/json_annotation.dart';

part 'course_chapter_step.g.dart';

@JsonSerializable()
class CourseChapterStep {
  int? index;
  int? progress;
  String? title;
  String? route;

  CourseChapterStep({this.index, this.progress, this.title, this.route});

  factory CourseChapterStep.fromJson(Map<String, dynamic> json) {
    return _$CourseChapterStepFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CourseChapterStepToJson(this);
}
