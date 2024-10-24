import 'package:json_annotation/json_annotation.dart';

import 'datum.dart';

part 'my_error_questtest.g.dart';

@JsonSerializable()
class MyErrorQuesttest {
  bool? status;
  List<Datum>? data;

  MyErrorQuesttest({this.status, this.data});

  factory MyErrorQuesttest.fromJson(Map<String, dynamic> json) {
    return _$MyErrorQuesttestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MyErrorQuesttestToJson(this);
}
