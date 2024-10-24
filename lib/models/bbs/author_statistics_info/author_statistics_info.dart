import 'package:json_annotation/json_annotation.dart';

import 'author_statistics_info_data.dart';

part 'author_statistics_info.g.dart';

@JsonSerializable()
class AuthorStatisticsInfo {
	bool? status;
	AuthorStatisticsInfoData? data;

	AuthorStatisticsInfo({this.status, this.data});

	factory AuthorStatisticsInfo.fromJson(Map<String, dynamic> json) {
		return _$AuthorStatisticsInfoFromJson(json);
	}

	Map<String, dynamic> toJson() => _$AuthorStatisticsInfoToJson(this);
}
