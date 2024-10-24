import 'package:json_annotation/json_annotation.dart';

import 'chapter_test_result_data.dart';

part 'chapter_test_result.g.dart';

@JsonSerializable()
class ChapterTestResult {
  bool? status;
  ChapterTestResultData? data;

  ChapterTestResult({this.status, this.data});

  factory ChapterTestResult.fromJson(Map<String, dynamic> json) {
    return _$ChapterTestResultFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ChapterTestResultToJson(this);
}
