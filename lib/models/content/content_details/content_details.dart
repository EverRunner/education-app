import 'package:json_annotation/json_annotation.dart';

import 'content_details_data.dart';

part 'content_details.g.dart';

@JsonSerializable()
class ContentDetails {
  bool? status;
  ContentDetailsData? data;

  ContentDetails({this.status, this.data});

  factory ContentDetails.fromJson(Map<String, dynamic> json) {
    return _$ContentDetailsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ContentDetailsToJson(this);
}
