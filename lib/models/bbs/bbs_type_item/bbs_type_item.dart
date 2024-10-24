import 'package:json_annotation/json_annotation.dart';

part 'bbs_type_item.g.dart';

@JsonSerializable()
class BbsTypeItem {
  String? title;
  String? id;
  String? radiusType;
  bool? display;

  BbsTypeItem({
    this.title,
    this.id,
    this.radiusType,
    this.display,
  });

  factory BbsTypeItem.fromJson(Map<String, dynamic> json) {
    return _$BbsTypeItemFromJson(json);
  }

  Map<String, dynamic> toJson() => _$BbsTypeItemToJson(this);
}
