import 'package:json_annotation/json_annotation.dart';

import 'course_test_list_item.dart';

part 'course_test_list.g.dart';

@JsonSerializable()
class CourseTestList {
  bool? status;
  List<CourseTestListItem>? dataList;

  CourseTestList({this.status, this.dataList});

  factory CourseTestList.fromJson(Map<String, dynamic> json) {
    return _$CourseTestListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CourseTestListToJson(this);
}
