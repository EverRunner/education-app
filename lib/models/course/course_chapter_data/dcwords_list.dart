import 'package:json_annotation/json_annotation.dart';

part 'dcwords_list.g.dart';

@JsonSerializable()
class DcwordsList {
  int? id;
  int? coursechapterid;
  int? dcwordspaperid;

  DcwordsList({this.id, this.coursechapterid, this.dcwordspaperid});

  factory DcwordsList.fromJson(Map<String, dynamic> json) {
    return _$DcwordsListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DcwordsListToJson(this);
}
