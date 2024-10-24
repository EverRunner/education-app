import 'package:json_annotation/json_annotation.dart';

import 'yibei_course.dart';
import 'yibei_course_chapter.dart';
import 'yibei_newdcword_paper_const.dart';
import 'package:yibei_app/models/course/course_test_list/yibei_requestion_const.dart';
import 'package:yibei_app/models/course/course_test_list/yibei_requestion_const_option.dart';

part 'datum.g.dart';

@JsonSerializable()
class Datum {
  int? id;
  int? memberid;
  int? courseid;
  int? chapterid;
  int? requestid;
  String? requesttitle;
  String? content;
  int? requestcategory;
  dynamic memberanswser;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  @JsonKey(name: 'yibei_course')
  YibeiCourse? yibeiCourse;
  @JsonKey(name: 'yibei_course_chapter')
  YibeiCourseChapter? yibeiCourseChapter;
  @JsonKey(name: 'yibei_requestion_const')
  YibeiRequestionConst? yibeiRequestionConst;
  @JsonKey(name: 'yibei_requestion_const_option')
  List<YibeiRequestionConstOption>? yibeiRequestionConstOption;
  @JsonKey(name: 'yibei_newdcword_paper_const')
  List<YibeiNewdcwordPaperConst>? yibeiNewdcwordPaperConst;

  Datum({
    this.id,
    this.memberid,
    this.courseid,
    this.chapterid,
    this.requestid,
    this.requesttitle,
    this.content,
    this.requestcategory,
    this.memberanswser,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.yibeiCourse,
    this.yibeiCourseChapter,
    this.yibeiRequestionConst,
    this.yibeiRequestionConstOption,
    this.yibeiNewdcwordPaperConst,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}
