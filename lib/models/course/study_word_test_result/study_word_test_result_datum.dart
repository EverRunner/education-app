import 'package:json_annotation/json_annotation.dart';

part 'study_word_test_result_datum.g.dart';

@JsonSerializable()
class StudyWordTestResultDatum {
  int? id;
  int? memberid;
  String? ordercode;
  String? title;
  String? jonstring;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  StudyWordTestResultDatum({
    this.id,
    this.memberid,
    this.ordercode,
    this.title,
    this.jonstring,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory StudyWordTestResultDatum.fromJson(Map<String, dynamic> json) =>
      _$StudyWordTestResultDatumFromJson(json);

  Map<String, dynamic> toJson() => _$StudyWordTestResultDatumToJson(this);
}
