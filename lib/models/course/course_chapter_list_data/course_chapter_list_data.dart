import 'package:json_annotation/json_annotation.dart';

import 'data_list.dart';

part 'course_chapter_list_data.g.dart';

@JsonSerializable()
class CourseChapterListData {
  bool? status;
  List<DataList>? dataList;

  CourseChapterListData({this.status, this.dataList});

  factory CourseChapterListData.fromJson(Map<String, dynamic> json) {
    return _$CourseChapterListDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CourseChapterListDataToJson(this);
}
