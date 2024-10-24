import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'bbs_list.g.dart';

@JsonSerializable()
class BbsList {
	bool? status;
	Data? data;

	BbsList({this.status, this.data});

	factory BbsList.fromJson(Map<String, dynamic> json) {
		return _$BbsListFromJson(json);
	}

	Map<String, dynamic> toJson() => _$BbsListToJson(this);
}
