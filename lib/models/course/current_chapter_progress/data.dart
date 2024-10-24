import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  int? id;
  int? progressid;
  dynamic progresscourseid;
  int? memberid;
  int? courseid;
  int? chapterid;
  int? sort;
  DateTime? startdate;
  dynamic enddate;
  DateTime? videosdate;
  DateTime? videoedate;
  int? completevidoe;
  int? completedcword;
  int? completerequest;
  int? isnotest;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.progressid,
    this.progresscourseid,
    this.memberid,
    this.courseid,
    this.chapterid,
    this.sort,
    this.startdate,
    this.enddate,
    this.videosdate,
    this.videoedate,
    this.completevidoe,
    this.completedcword,
    this.completerequest,
    this.isnotest,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
