import 'package:json_annotation/json_annotation.dart';
import 'package:yibei_app/models/course/chapter_test_request_list/yibei_requestion_const_option.dart';

part 'compound_test_request_list_row.g.dart';

@JsonSerializable()
class CompoundTestRequestListRow {
  int? id;
  dynamic progressid;
  dynamic progresscourseid;
  dynamic progresscoursechatperid;
  dynamic progresscoursechatperdcwordsid;
  int? chapterrequestid;
  int? memberid;
  dynamic requestpaperid;
  dynamic requestid;
  dynamic category;
  String? content;
  String? title;
  DateTime? startdate;
  DateTime? enddate;
  String? memberanswser;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  @JsonKey(name: 'yibei_requestion_const_option')
  List<YibeiRequestionConstOption>? yibeiRequestionConstOption;

  CompoundTestRequestListRow({
    this.id,
    this.progressid,
    this.progresscourseid,
    this.progresscoursechatperid,
    this.progresscoursechatperdcwordsid,
    this.chapterrequestid,
    this.memberid,
    this.requestpaperid,
    this.requestid,
    this.category,
    this.content,
    this.title,
    this.startdate,
    this.enddate,
    this.memberanswser,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.yibeiRequestionConstOption,
  });

  factory CompoundTestRequestListRow.fromJson(Map<String, dynamic> json) =>
      _$CompoundTestRequestListRowFromJson(json);

  Map<String, dynamic> toJson() => _$CompoundTestRequestListRowToJson(this);
}
