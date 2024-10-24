import 'package:json_annotation/json_annotation.dart';

part 'my_floow_member_datum.g.dart';

@JsonSerializable()
class MyFloowMemberDatum {
  int? memberid;
  String? username;
  DateTime? creathydate;

  MyFloowMemberDatum({this.memberid, this.username, this.creathydate});

  factory MyFloowMemberDatum.fromJson(Map<String, dynamic> json) =>
      _$MyFloowMemberDatumFromJson(json);

  Map<String, dynamic> toJson() => _$MyFloowMemberDatumToJson(this);
}
