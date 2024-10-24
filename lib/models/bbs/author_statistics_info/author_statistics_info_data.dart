import 'package:json_annotation/json_annotation.dart';

part 'author_statistics_info_data.g.dart';

@JsonSerializable()
class AuthorStatisticsInfoData {
	String? username;
	String? avatar;
	int? followcount;
	int? postcount;
	int? likecount;
	int? viewcount;
	int? islikeuser;

	AuthorStatisticsInfoData({
		this.username, 
		this.avatar, 
		this.followcount, 
		this.postcount, 
		this.likecount, 
		this.viewcount, 
		this.islikeuser, 
	});

	factory AuthorStatisticsInfoData.fromJson(Map<String, dynamic> json) => _$AuthorStatisticsInfoDataFromJson(json);

	Map<String, dynamic> toJson() => _$AuthorStatisticsInfoDataToJson(this);
}
