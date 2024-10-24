import 'package:json_annotation/json_annotation.dart';

part 'course_submit_test.g.dart';

@JsonSerializable()
class CourseSubmitTest {
  bool? status;
  int? requestid;
  bool? isthreeerrorcount;
  int? lefttestcount;
  int? chapterrequestid;
  int? rank;

  CourseSubmitTest({
    this.status,
    this.requestid,
    this.isthreeerrorcount,
    this.lefttestcount,
    this.chapterrequestid,
    this.rank,
  });

  factory CourseSubmitTest.fromJson(Map<String, dynamic> json) {
    return _$CourseSubmitTestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CourseSubmitTestToJson(this);
}
