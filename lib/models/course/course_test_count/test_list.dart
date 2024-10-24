import 'package:json_annotation/json_annotation.dart';

part 'test_list.g.dart';

@JsonSerializable()
class TestList {
  String? createdAt;
  String? updatedAt;

  TestList({this.createdAt, this.updatedAt});

  factory TestList.fromJson(Map<String, dynamic> json) {
    return _$TestListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TestListToJson(this);
}
