import 'package:json_annotation/json_annotation.dart';

part 'course_chapter_word_test_result.g.dart';

@JsonSerializable()
class CourseChapterWordTestResult {
  bool? status;
  int? errorCount;
  int? rank;
  String? err;

  CourseChapterWordTestResult({
    this.status,
    this.errorCount,
    this.rank,
    this.err,
  });

  factory CourseChapterWordTestResult.fromJson(Map<String, dynamic> json) {
    return _$CourseChapterWordTestResultFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CourseChapterWordTestResultToJson(this);
}
