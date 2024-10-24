import 'package:json_annotation/json_annotation.dart';

part 'yibei_content_category.g.dart';

@JsonSerializable()
class YibeiContentCategory {
  String? name;

  YibeiContentCategory({this.name});

  factory YibeiContentCategory.fromJson(Map<String, dynamic> json) {
    return _$YibeiContentCategoryFromJson(json);
  }

  Map<String, dynamic> toJson() => _$YibeiContentCategoryToJson(this);
}
