import 'package:json_annotation/json_annotation.dart';

part 'chapter_test_result_data.g.dart';

@JsonSerializable()
class ChapterTestResultData {
  int? id;
  int? progressid;
  int? progresscourseid;
  int? progresscoursechatperid;
  int? memberid;
  int? requestpaperid;
  dynamic currentindex;
  int? allrequestcount;
  int? correctcount;
  int? errorcount;
  int? score;
  DateTime? startdate;
  DateTime? enddate;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  ChapterTestResultData({
    this.id,
    this.progressid,
    this.progresscourseid,
    this.progresscoursechatperid,
    this.memberid,
    this.requestpaperid,
    this.currentindex,
    this.allrequestcount,
    this.correctcount,
    this.errorcount,
    this.score,
    this.startdate,
    this.enddate,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ChapterTestResultData.fromJson(Map<String, dynamic> json) =>
      _$ChapterTestResultDataFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterTestResultDataToJson(this);
}
