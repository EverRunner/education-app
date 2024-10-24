import 'package:json_annotation/json_annotation.dart';

part 'yibei_member.g.dart';

@JsonSerializable()
class YibeiMember {
	String? username;
	dynamic phone;
	String? email;
	dynamic avatar;

	YibeiMember({this.username, this.phone, this.email, this.avatar});

	factory YibeiMember.fromJson(Map<String, dynamic> json) {
		return _$YibeiMemberFromJson(json);
	}

	Map<String, dynamic> toJson() => _$YibeiMemberToJson(this);
}
