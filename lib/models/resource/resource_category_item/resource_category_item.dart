import 'package:json_annotation/json_annotation.dart';

part 'resource_category_item.g.dart';

@JsonSerializable()
class ResourceCategoryItem {
  String? title;
  int? id;
  String? type;

  ResourceCategoryItem({this.title, this.id, this.type});

  factory ResourceCategoryItem.fromJson(Map<String, dynamic> json) {
    return _$ResourceCategoryItemFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ResourceCategoryItemToJson(this);
}
