import 'package:json_annotation/json_annotation.dart';

import 'study_word_test_result_datum.dart';

part 'study_word_test_result.g.dart';

@JsonSerializable()
class StudyWordTestResult {
  bool? status;
  List<StudyWordTestResultDatum>? data;

  StudyWordTestResult({this.status, this.data});

  factory StudyWordTestResult.fromJson(Map<String, dynamic> json) {
    return _$StudyWordTestResultFromJson(json);
  }

  Map<String, dynamic> toJson() => _$StudyWordTestResultToJson(this);
}
