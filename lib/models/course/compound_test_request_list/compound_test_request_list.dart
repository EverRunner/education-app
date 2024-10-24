import 'package:json_annotation/json_annotation.dart';

import 'compound_test_request_list_row.dart';

part 'compound_test_request_list.g.dart';

@JsonSerializable()
class CompoundTestRequestList {
  bool? status;
  List<CompoundTestRequestListRow>? data;

  CompoundTestRequestList({this.status, this.data});

  factory CompoundTestRequestList.fromJson(Map<String, dynamic> json) {
    return _$CompoundTestRequestListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CompoundTestRequestListToJson(this);
}
