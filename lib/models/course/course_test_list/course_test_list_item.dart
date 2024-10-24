import 'package:json_annotation/json_annotation.dart';

import 'yibei_newdcword_paper_const.dart';
import 'yibei_requestion_const.dart';
import 'yibei_requestion_const_option.dart';

part 'course_test_list_item.g.dart';

@JsonSerializable()
class CourseTestListItem {
  int? id;
  int? paperid;
  int? requestionid;
  int? requestid;
  int? answer;
  DateTime? createdAt;
  DateTime? updatedAt;
  @JsonKey(name: 'yibei_requestion_const')
  YibeiRequestionConst? yibeiRequestionConst;
  @JsonKey(name: 'yibei_requestion_const_option')
  List<YibeiRequestionConstOption>? yibeiRequestionConstOption;
  @JsonKey(name: 'yibei_newdcword_paper_const')
  List<YibeiNewdcwordPaperConst>? yibeiNewdcwordPaperConst;

  CourseTestListItem({
    this.id,
    this.paperid,
    this.requestionid,
    this.requestid,
    this.answer,
    this.createdAt,
    this.updatedAt,
    this.yibeiRequestionConst,
    this.yibeiRequestionConstOption,
    this.yibeiNewdcwordPaperConst,
  });

  factory CourseTestListItem.fromJson(Map<String, dynamic> json) {
    return _$CourseTestListItemFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CourseTestListItemToJson(this);
}
