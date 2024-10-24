import 'package:json_annotation/json_annotation.dart';

import 'compound_test_result_data_item.dart';

part 'compound_test_result_data.g.dart';

@JsonSerializable()
class CompoundTestResultData {
  bool? status;
  CompoundTestResultDataItem? data;

  CompoundTestResultData({this.status, this.data});

  factory CompoundTestResultData.fromJson(Map<String, dynamic> json) {
    return _$CompoundTestResultDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CompoundTestResultDataToJson(this);
}
