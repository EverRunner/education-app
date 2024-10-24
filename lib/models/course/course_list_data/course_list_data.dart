import 'package:json_annotation/json_annotation.dart';

part 'course_list_data.g.dart';

@JsonSerializable()
class CourseListData {
  int? id;
  int? progress;
  String? title;
  int? isFinal;
  String? studyStep;
  int? type;

  CourseListData({
    this.id,
    this.progress,
    this.title,
    this.isFinal,
    this.studyStep,
    this.type,
  });

  factory CourseListData.fromJson(Map<String, dynamic> json) {
    return _$CourseListDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CourseListDataToJson(this);
}
