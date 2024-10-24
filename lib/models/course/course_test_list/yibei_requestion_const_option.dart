import 'package:json_annotation/json_annotation.dart';

part 'yibei_requestion_const_option.g.dart';

@JsonSerializable()
class YibeiRequestionConstOption {
  int? id;
  int? requestid;
  String? title;
  String? content;
  int? iscorrectoption;
  int? sort;
  DateTime? createdAt;
  DateTime? updatedAt;

  YibeiRequestionConstOption({
    this.id,
    this.requestid,
    this.title,
    this.content,
    this.iscorrectoption,
    this.sort,
    this.createdAt,
    this.updatedAt,
  });

  factory YibeiRequestionConstOption.fromJson(Map<String, dynamic> json) {
    return _$YibeiRequestionConstOptionFromJson(json);
  }

  Map<String, dynamic> toJson() => _$YibeiRequestionConstOptionToJson(this);
}
