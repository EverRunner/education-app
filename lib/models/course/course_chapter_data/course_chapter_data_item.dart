import 'package:json_annotation/json_annotation.dart';

import 'course_obj.dart';
import 'dcwords_list.dart';
import 'request_paper_list.dart';

part 'course_chapter_data_item.g.dart';

@JsonSerializable()
class CourseChapterDataItem {
  int? id;
  int? courseid;
  String? title;
  String? thumb;
  String? description;
  String? videopath;
  String? videotimes;
  String? studystep;
  int? vediotimesint;
  int? sort;
  int? isfinal;
  int? isreview;
  int? isbindword;
  dynamic content;
  int? isdelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<DcwordsList>? dcwordsList;
  List<RequestPaperList>? requestPaperList;
  CourseObj? courseObj;

  CourseChapterDataItem({
    this.id,
    this.courseid,
    this.title,
    this.thumb,
    this.description,
    this.videopath,
    this.videotimes,
    this.studystep,
    this.vediotimesint,
    this.sort,
    this.isfinal,
    this.isreview,
    this.isbindword,
    this.content,
    this.isdelete,
    this.createdAt,
    this.updatedAt,
    this.dcwordsList,
    this.requestPaperList,
    this.courseObj,
  });

  factory CourseChapterDataItem.fromJson(Map<String, dynamic> json) =>
      _$CourseChapterDataItemFromJson(json);

  Map<String, dynamic> toJson() => _$CourseChapterDataItemToJson(this);
}
