import 'package:json_annotation/json_annotation.dart';

import 'course_request_info_data.dart';

part 'course_request_info.g.dart';

@JsonSerializable()
class CourseRequestInfo {
  bool? status;
  CourseRequestInfoData? data;

  CourseRequestInfo({this.status, this.data});

  factory CourseRequestInfo.fromJson(Map<String, dynamic> json) {
    return _$CourseRequestInfoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CourseRequestInfoToJson(this);
}
