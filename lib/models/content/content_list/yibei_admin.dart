import 'package:json_annotation/json_annotation.dart';

part 'yibei_admin.g.dart';

@JsonSerializable()
class YibeiAdmin {
  String? username;

  YibeiAdmin({this.username});

  factory YibeiAdmin.fromJson(Map<String, dynamic> json) {
    return _$YibeiAdminFromJson(json);
  }

  Map<String, dynamic> toJson() => _$YibeiAdminToJson(this);
}
