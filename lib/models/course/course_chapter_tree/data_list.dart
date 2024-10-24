import 'package:json_annotation/json_annotation.dart';

import 'yibei_course_chapter.dart';

part 'data_list.g.dart';

@JsonSerializable()
class DataList {
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
  @JsonKey(name: 'yibei_course_chapter')
  List<YibeiCourseChapter>? yibeiCourseChapter;

  DataList({
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
    this.yibeiCourseChapter,
  });

  factory DataList.fromJson(Map<String, dynamic> json) {
    return _$DataListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DataListToJson(this);
}
