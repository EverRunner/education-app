import 'package:json_annotation/json_annotation.dart';

import 'answer_list_item.dart';

part 'course_chapter_word_list_item.g.dart';

@JsonSerializable()
class CourseChapterWordListItem {
  int? id;
  int? paperid;
  String? atitle;
  String? btitle;
  dynamic voicepath;
  int? sort;
  int? answer;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<AnswerListItem>? answerList;

  CourseChapterWordListItem({
    this.id,
    this.paperid,
    this.atitle,
    this.btitle,
    this.voicepath,
    this.sort,
    this.answer,
    this.createdAt,
    this.updatedAt,
    this.answerList,
  });

  factory CourseChapterWordListItem.fromJson(Map<String, dynamic> json) =>
      _$CourseChapterWordListItemFromJson(json);

  Map<String, dynamic> toJson() => _$CourseChapterWordListItemToJson(this);
}
