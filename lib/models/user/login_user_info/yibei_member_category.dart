import 'package:json_annotation/json_annotation.dart';

part 'yibei_member_category.g.dart';

@JsonSerializable()
class YibeiMemberCategory {
  String? categoryname;
  String? categorykey;
  String? color;

  YibeiMemberCategory({this.categoryname, this.categorykey, this.color});

  factory YibeiMemberCategory.fromJson(Map<String, dynamic> json) {
    return _$YibeiMemberCategoryFromJson(json);
  }

  Map<String, dynamic> toJson() => _$YibeiMemberCategoryToJson(this);
}
