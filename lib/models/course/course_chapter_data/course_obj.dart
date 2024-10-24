import 'package:json_annotation/json_annotation.dart';

part 'course_obj.g.dart';

@JsonSerializable()
class CourseObj {
  int? id;
  String? title;
  int? type;
  String? thumb;
  String? description;
  String? content;
  dynamic jifen;
  String? author;
  int? sort;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  CourseObj({
    this.id,
    this.title,
    this.type,
    this.thumb,
    this.description,
    this.content,
    this.jifen,
    this.author,
    this.sort,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CourseObj.fromJson(Map<String, dynamic> json) {
    return _$CourseObjFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CourseObjToJson(this);
}
