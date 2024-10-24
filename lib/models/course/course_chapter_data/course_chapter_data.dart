import 'package:json_annotation/json_annotation.dart';

import 'course_chapter_data_item.dart';

part 'course_chapter_data.g.dart';

@JsonSerializable()
class CourseChapterData {
  bool? status;
  CourseChapterDataItem? data;

  CourseChapterData({this.status, this.data});

  factory CourseChapterData.fromJson(Map<String, dynamic> json) {
    return _$CourseChapterDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CourseChapterDataToJson(this);
}
