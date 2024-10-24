import 'package:json_annotation/json_annotation.dart';

part 'content_details_data.g.dart';

@JsonSerializable()
class ContentDetailsData {
  int? id;
  String? title;
  String? thumb;
  int? category;
  String? description;
  dynamic content;
  int? sort;
  int? creatuserid;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  ContentDetailsData({
    this.id,
    this.title,
    this.thumb,
    this.category,
    this.description,
    this.content,
    this.sort,
    this.creatuserid,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ContentDetailsData.fromJson(Map<String, dynamic> json) =>
      _$ContentDetailsDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContentDetailsDataToJson(this);
}
