import 'package:json_annotation/json_annotation.dart';

import 'post_details_data.dart';

part 'post_details.g.dart';

@JsonSerializable()
class PostDetails {
	bool? status;
	PostDetailsData? data;

	PostDetails({this.status, this.data});

	factory PostDetails.fromJson(Map<String, dynamic> json) {
		return _$PostDetailsFromJson(json);
	}

	Map<String, dynamic> toJson() => _$PostDetailsToJson(this);
}
