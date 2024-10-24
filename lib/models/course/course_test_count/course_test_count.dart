import 'package:json_annotation/json_annotation.dart';

import 'test_list.dart';

part 'course_test_count.g.dart';

@JsonSerializable()
class CourseTestCount {
  bool? status;
  List<TestList>? testList;
  int? lefttestcount;

  CourseTestCount({this.status, this.testList, this.lefttestcount});

  factory CourseTestCount.fromJson(Map<String, dynamic> json) {
    return _$CourseTestCountFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CourseTestCountToJson(this);
}
