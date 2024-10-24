import 'package:json_annotation/json_annotation.dart';

import 'course_chapter_word_list_item.dart';

part 'course_chapter_word_list.g.dart';

@JsonSerializable()
class CourseChapterWordList {
  bool? status;
  List<CourseChapterWordListItem>? data;

  CourseChapterWordList({this.status, this.data});

  factory CourseChapterWordList.fromJson(Map<String, dynamic> json) {
    return _$CourseChapterWordListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CourseChapterWordListToJson(this);
}
