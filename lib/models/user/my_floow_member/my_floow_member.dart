import 'package:json_annotation/json_annotation.dart';

import 'my_floow_member_datum.dart';

part 'my_floow_member.g.dart';

@JsonSerializable()
class MyFloowMember {
  bool? status;
  List<MyFloowMemberDatum>? data;

  MyFloowMember({this.status, this.data});

  factory MyFloowMember.fromJson(Map<String, dynamic> json) {
    return _$MyFloowMemberFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MyFloowMemberToJson(this);
}
