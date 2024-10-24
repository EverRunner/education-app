import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'chapter_test_request_list.g.dart';

@JsonSerializable()
class ChapterTestRequestList {
  bool? status;
  Data? data;

  ChapterTestRequestList({this.status, this.data});

  factory ChapterTestRequestList.fromJson(Map<String, dynamic> json) {
    return _$ChapterTestRequestListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ChapterTestRequestListToJson(this);
}
