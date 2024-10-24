import 'package:json_annotation/json_annotation.dart';

import 'data_list.dart';

part 'course_chapter_tree.g.dart';

@JsonSerializable()
class CourseChapterTree {
  bool? status;
  List<DataList>? dataList;

  CourseChapterTree({this.status, this.dataList});

  factory CourseChapterTree.fromJson(Map<String, dynamic> json) {
    return _$CourseChapterTreeFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CourseChapterTreeToJson(this);
}
