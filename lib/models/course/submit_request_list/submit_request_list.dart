import 'package:json_annotation/json_annotation.dart';

part 'submit_request_list.g.dart';

@JsonSerializable()
class SubmitRequestList {
  int? requestid;
  String? title;
  int? category;
  int? memberanswser;
  int? status;

  SubmitRequestList({
    this.requestid,
    this.title,
    this.category,
    this.memberanswser,
    this.status,
  });

  factory SubmitRequestList.fromJson(Map<String, dynamic> json) {
    return _$SubmitRequestListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SubmitRequestListToJson(this);
}
