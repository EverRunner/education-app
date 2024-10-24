import 'package:json_annotation/json_annotation.dart';

part 'answer_list.g.dart';

@JsonSerializable()
class AnswerList {
  int? id;
  String? title;
  int? iscorrectoption;

  AnswerList({this.id, this.title, this.iscorrectoption});

  factory AnswerList.fromJson(Map<String, dynamic> json) {
    return _$AnswerListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AnswerListToJson(this);
}
