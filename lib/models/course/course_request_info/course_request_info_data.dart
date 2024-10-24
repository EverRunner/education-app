import 'package:json_annotation/json_annotation.dart';

part 'course_request_info_data.g.dart';

@JsonSerializable()
class CourseRequestInfoData {
  int? id;
  String? title;
  dynamic description;
  double? qualifiedproportion;
  int? isrepeattest;
  int? timelimit;
  int? randomcount;
  int? sort;
  DateTime? createdAt;
  DateTime? updatedAt;

  CourseRequestInfoData({
    this.id,
    this.title,
    this.description,
    this.qualifiedproportion,
    this.isrepeattest,
    this.timelimit,
    this.randomcount,
    this.sort,
    this.createdAt,
    this.updatedAt,
  });

  factory CourseRequestInfoData.fromJson(Map<String, dynamic> json) =>
      _$CourseRequestInfoDataFromJson(json);

  Map<String, dynamic> toJson() => _$CourseRequestInfoDataToJson(this);
}
