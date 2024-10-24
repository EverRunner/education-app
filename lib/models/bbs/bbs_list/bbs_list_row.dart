import 'package:json_annotation/json_annotation.dart';

import 'yibei_bbs_category.dart';
import 'yibei_member.dart';

part 'bbs_list_row.g.dart';

@JsonSerializable()
class BbsListRow {
  int? id;
  dynamic title;
  dynamic images;
  int? category;
  String? content;
  String? vedio;
  int? memberid;
  dynamic latitude;
  dynamic longitude;
  dynamic location;
  DateTime? createdAt;
  dynamic distance;
  int? likecount;
  int? browsecount;
  int? islike;
  @JsonKey(name: 'yibei_member')
  YibeiMember? yibeiMember;
  @JsonKey(name: 'yibei_bbs_category')
  YibeiBbsCategory? yibeiBbsCategory;

  BbsListRow({
    this.id,
    this.title,
    this.images,
    this.category,
    this.content,
    this.vedio,
    this.memberid,
    this.latitude,
    this.longitude,
    this.location,
    this.createdAt,
    this.distance,
    this.likecount,
    this.browsecount,
    this.islike,
    this.yibeiMember,
    this.yibeiBbsCategory,
  });

  factory BbsListRow.fromJson(Map<String, dynamic> json) =>
      _$BbsListRowFromJson(json);

  Map<String, dynamic> toJson() => _$BbsListRowToJson(this);
}
