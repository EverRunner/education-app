import 'package:json_annotation/json_annotation.dart';

import 'chapter_test_request_list_row.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  int? count;
  List<ChapterTestRequestListRow>? rows;

  Data({this.count, this.rows});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
