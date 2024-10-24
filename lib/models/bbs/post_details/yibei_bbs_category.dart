import 'package:json_annotation/json_annotation.dart';

part 'yibei_bbs_category.g.dart';

@JsonSerializable()
class YibeiBbsCategory {
	String? name;
	dynamic thumb;

	YibeiBbsCategory({this.name, this.thumb});

	factory YibeiBbsCategory.fromJson(Map<String, dynamic> json) {
		return _$YibeiBbsCategoryFromJson(json);
	}

	Map<String, dynamic> toJson() => _$YibeiBbsCategoryToJson(this);
}
