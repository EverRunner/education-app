import 'package:json_annotation/json_annotation.dart';

part 'data_list.g.dart';

@JsonSerializable()
class DataList {
  int? id;
  int? courseid;
  String? title;
  String? thumb;
  String? description;
  String? videopath;
  dynamic videotimes;
  int? vediotimesint;
  int? sort;
  int? isfinal;
  int? isreview;
  int? isbindword;
  String? studystep;
  dynamic content;
  int? isdelete;
  DateTime? createdAt;
  DateTime? updatedAt;

  DataList({
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
    this.studystep,
    this.content,
    this.isdelete,
    this.createdAt,
    this.updatedAt,
  });

  factory DataList.fromJson(Map<String, dynamic> json) {
    return _$DataListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DataListToJson(this);
}
