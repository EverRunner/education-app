import 'package:json_annotation/json_annotation.dart';

import 'yibei_requestion_const_option.dart';

part 'chapter_test_request_list_row.g.dart';

@JsonSerializable()
class ChapterTestRequestListRow {
  int? id;
  int? progressid;
  int? progresscourseid;
  int? progresscoursechatperid;
  dynamic progresscoursechatperdcwordsid;
  int? chapterrequestid;
  int? memberid;
  int? requestpaperid;
  int? requestid;
  String? title;
  int? category;
  dynamic content;
  dynamic startdate;
  dynamic enddate;
  String? memberanswser;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  @JsonKey(name: 'yibei_requestion_const_option')
  List<YibeiRequestionConstOption>? yibeiRequestionConstOption;

  ChapterTestRequestListRow({
    this.id,
    this.progressid,
    this.progresscourseid,
    this.progresscoursechatperid,
    this.progresscoursechatperdcwordsid,
    this.chapterrequestid,
    this.memberid,
    this.requestpaperid,
    this.requestid,
    this.title,
    this.category,
    this.content,
    this.startdate,
    this.enddate,
    this.memberanswser,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.yibeiRequestionConstOption,
  });

  factory ChapterTestRequestListRow.fromJson(Map<String, dynamic> json) =>
      _$ChapterTestRequestListRowFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterTestRequestListRowToJson(this);
}
