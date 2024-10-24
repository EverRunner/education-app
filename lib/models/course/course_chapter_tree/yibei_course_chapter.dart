import 'package:json_annotation/json_annotation.dart';

part 'yibei_course_chapter.g.dart';

@JsonSerializable()
class YibeiCourseChapter {
  int? id;
  int? courseid;
  String? title;
  String? thumb;
  dynamic description;
  String? videopath;
  String? videotimes;
  int? vediotimesint;
  int? sort;
  int? isfinal;
  int? isreview;
  int? isbindword;
  dynamic content;
  int? isdelete;
  String? studystep;
  DateTime? createdAt;
  DateTime? updatedAt;

  YibeiCourseChapter({
    this.id,
    this.courseid,
    this.title,
    this.thumb,
    this.description,
    this.videopath,
    this.videotimes,
    this.vediotimesint,
    this.sort,
    this.isfinal,
    this.isreview,
    this.isbindword,
    this.content,
    this.isdelete,
    this.studystep,
    this.createdAt,
    this.updatedAt,
  });

  factory YibeiCourseChapter.fromJson(Map<String, dynamic> json) {
    return _$YibeiCourseChapterFromJson(json);
  }

  Map<String, dynamic> toJson() => _$YibeiCourseChapterToJson(this);
}
