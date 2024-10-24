import 'package:json_annotation/json_annotation.dart';

import 'content_list_data.dart';

part 'content_list.g.dart';

@JsonSerializable()
class ContentList {
  bool? status;
  ContentListData? data;

  ContentList({this.status, this.data});

  factory ContentList.fromJson(Map<String, dynamic> json) {
    return _$ContentListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ContentListToJson(this);
}
