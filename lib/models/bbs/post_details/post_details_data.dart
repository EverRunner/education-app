import 'package:json_annotation/json_annotation.dart';

import 'yibei_bbs_category.dart';
import 'yibei_member.dart';

part 'post_details_data.g.dart';

@JsonSerializable()
class PostDetailsData {
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
  dynamic contact;
  dynamic contactnumber;
  DateTime? createdAt;
  int? likecount;
  int? postcount;
  int? browsecount;
  int? islike;
  int? islikeuser;
  @JsonKey(name: 'yibei_member')
  YibeiMember? yibeiMember;
  @JsonKey(name: 'yibei_bbs_category')
  YibeiBbsCategory? yibeiBbsCategory;

  PostDetailsData({
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
    this.contact,
    this.contactnumber,
    this.createdAt,
    this.likecount,
    this.postcount,
    this.browsecount,
    this.islike,
    this.islikeuser,
    this.yibeiMember,
    this.yibeiBbsCategory,
  });

  factory PostDetailsData.fromJson(Map<String, dynamic> json) =>
      _$PostDetailsDataFromJson(json);

  Map<String, dynamic> toJson() => _$PostDetailsDataToJson(this);
}
