import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'course_compound_submit.g.dart';

@JsonSerializable()
class CourseCompoundSubmit {
  bool? status;
  Data? data;

  CourseCompoundSubmit({this.status, this.data});

  factory CourseCompoundSubmit.fromJson(Map<String, dynamic> json) {
    return _$CourseCompoundSubmitFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CourseCompoundSubmitToJson(this);
}
