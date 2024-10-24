import 'package:json_annotation/json_annotation.dart';

part 'compound_test_result_data_item.g.dart';

@JsonSerializable()
class CompoundTestResultDataItem {
  int? id;
  int? memberid;
  int? allrequestcount;
  int? correctcount;
  int? errorcount;
  String? score;
  DateTime? startdate;
  DateTime? enddate;
  int? status;
  dynamic remark;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic requestpaperid;

  CompoundTestResultDataItem({
    this.id,
    this.memberid,
    this.allrequestcount,
    this.correctcount,
    this.errorcount,
    this.score,
    this.startdate,
    this.enddate,
    this.status,
    this.remark,
    this.createdAt,
    this.updatedAt,
    this.requestpaperid,
  });

  factory CompoundTestResultDataItem.fromJson(Map<String, dynamic> json) =>
      _$CompoundTestResultDataItemFromJson(json);

  Map<String, dynamic> toJson() => _$CompoundTestResultDataItemToJson(this);
}
