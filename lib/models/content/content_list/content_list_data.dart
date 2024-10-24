import 'package:json_annotation/json_annotation.dart';

import 'content_list_row.dart';

part 'content_list_data.g.dart';

@JsonSerializable()
class ContentListData {
  int? count;
  List<ContentListRow>? rows;

  ContentListData({this.count, this.rows});

  factory ContentListData.fromJson(Map<String, dynamic> json) =>
      _$ContentListDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContentListDataToJson(this);
}
