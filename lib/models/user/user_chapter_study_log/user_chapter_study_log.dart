import 'package:json_annotation/json_annotation.dart';

import 'datum.dart';

part 'user_chapter_study_log.g.dart';

@JsonSerializable()
class UserChapterStudyLog {
	bool? status;
	List<Datum>? data;

	UserChapterStudyLog({this.status, this.data});

	factory UserChapterStudyLog.fromJson(Map<String, dynamic> json) {
		return _$UserChapterStudyLogFromJson(json);
	}

	Map<String, dynamic> toJson() => _$UserChapterStudyLogToJson(this);
}
