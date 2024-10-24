import 'package:json_annotation/json_annotation.dart';

import 'study_logs_data_list.dart';

part 'member_study_logs.g.dart';

@JsonSerializable()
class MemberStudyLogs {
	bool? status;
	int? count;
	List<StudyLogsDataList>? dataList;

	MemberStudyLogs({this.status, this.count, this.dataList});

	factory MemberStudyLogs.fromJson(Map<String, dynamic> json) {
		return _$MemberStudyLogsFromJson(json);
	}

	Map<String, dynamic> toJson() => _$MemberStudyLogsToJson(this);
}
