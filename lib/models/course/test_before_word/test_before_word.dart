import 'package:json_annotation/json_annotation.dart';

import 'answer_list.dart';

part 'test_before_word.g.dart';

@JsonSerializable()
class TestBeforeWord {
  dynamic answer;
  String? atitle;
  String? btitle;
  List<AnswerList>? answerList;

  TestBeforeWord({this.answer, this.atitle, this.btitle, this.answerList});

  factory TestBeforeWord.fromJson(Map<String, dynamic> json) {
    return _$TestBeforeWordFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TestBeforeWordToJson(this);
}
