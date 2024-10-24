import 'package:json_annotation/json_annotation.dart';

import 'yibei_admin.dart';
import 'yibei_content_category.dart';

part 'content_list_row.g.dart';

@JsonSerializable()
class ContentListRow {
  int? id;
  String? title;
  String? thumb;
  int? category;
  String? description;
  dynamic content;
  dynamic sort;
  int? creatuserid;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  @JsonKey(name: 'yibei_content_category')
  YibeiContentCategory? yibeiContentCategory;
  @JsonKey(name: 'yibei_admin')
  YibeiAdmin? yibeiAdmin;

  ContentListRow({
    this.id,
    this.title,
    this.thumb,
    this.category,
    this.description,
    this.content,
    this.sort,
    this.creatuserid,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.yibeiContentCategory,
    this.yibeiAdmin,
  });

  factory ContentListRow.fromJson(Map<String, dynamic> json) =>
      _$ContentListRowFromJson(json);

  Map<String, dynamic> toJson() => _$ContentListRowToJson(this);
}
