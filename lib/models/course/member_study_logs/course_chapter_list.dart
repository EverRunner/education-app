import 'package:json_annotation/json_annotation.dart';

part 'course_chapter_list.g.dart';

@JsonSerializable()
class CourseChapterList {
	String? remark;
	String? status;
	DateTime? createdAt;

	CourseChapterList({this.remark, this.status, this.createdAt});

	factory CourseChapterList.fromJson(Map<String, dynamic> json) {
		return _$CourseChapterListFromJson(json);
	}

	Map<String, dynamic> toJson() => _$CourseChapterListToJson(this);
}
