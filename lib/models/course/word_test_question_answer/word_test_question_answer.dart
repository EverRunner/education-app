import 'package:json_annotation/json_annotation.dart';

part 'word_test_question_answer.g.dart';

@JsonSerializable()
class WordTestQuestionAnswer {
  bool? status;
  String? ordercode;

  WordTestQuestionAnswer({this.status, this.ordercode});

  factory WordTestQuestionAnswer.fromJson(Map<String, dynamic> json) {
    return _$WordTestQuestionAnswerFromJson(json);
  }

  Map<String, dynamic> toJson() => _$WordTestQuestionAnswerToJson(this);
}
