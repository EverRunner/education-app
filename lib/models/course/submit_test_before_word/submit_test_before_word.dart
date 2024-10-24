import 'package:json_annotation/json_annotation.dart';

part 'submit_test_before_word.g.dart';

@JsonSerializable()
class SubmitTestBeforeWord {
  bool? status;
  int? hasNosPassCount;

  SubmitTestBeforeWord({this.status, this.hasNosPassCount});

  factory SubmitTestBeforeWord.fromJson(Map<String, dynamic> json) {
    return _$SubmitTestBeforeWordFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SubmitTestBeforeWordToJson(this);
}
