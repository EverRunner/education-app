import 'package:json_annotation/json_annotation.dart';

part 'course_final_test_pass.g.dart';

@JsonSerializable()
class CourseFinalTestPass {
  bool? status;
  int? count;

  CourseFinalTestPass({this.status, this.count});

  factory CourseFinalTestPass.fromJson(Map<String, dynamic> json) {
    return _$CourseFinalTestPassFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CourseFinalTestPassToJson(this);
}
