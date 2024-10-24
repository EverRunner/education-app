import 'package:json_annotation/json_annotation.dart';

part 'request_paper_list.g.dart';

@JsonSerializable()
class RequestPaperList {
  int? id;
  int? coursechapterid;
  int? requestpaperid;

  RequestPaperList({this.id, this.coursechapterid, this.requestpaperid});

  factory RequestPaperList.fromJson(Map<String, dynamic> json) {
    return _$RequestPaperListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RequestPaperListToJson(this);
}
