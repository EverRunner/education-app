import 'package:json_annotation/json_annotation.dart';

part 'answer_list_item.g.dart';

@JsonSerializable()
class AnswerListItem {
  int? id;
  String? title;
  String? status;
  int? iscorrectoption;

  AnswerListItem({this.id, this.title, this.status, this.iscorrectoption});

  factory AnswerListItem.fromJson(Map<String, dynamic> json) {
    return _$AnswerListItemFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AnswerListItemToJson(this);
}
