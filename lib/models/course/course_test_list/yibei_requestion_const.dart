import 'package:json_annotation/json_annotation.dart';

part 'yibei_requestion_const.g.dart';

@JsonSerializable()
class YibeiRequestionConst {
  int? id;
  String? title;
  int? category;
  String? typestring;
  String? content;
  int? sort;
  dynamic answeranalysis;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  YibeiRequestionConst({
    this.id,
    this.title,
    this.category,
    this.typestring,
    this.content,
    this.sort,
    this.answeranalysis,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory YibeiRequestionConst.fromJson(Map<String, dynamic> json) {
    return _$YibeiRequestionConstFromJson(json);
  }

  Map<String, dynamic> toJson() => _$YibeiRequestionConstToJson(this);
}
