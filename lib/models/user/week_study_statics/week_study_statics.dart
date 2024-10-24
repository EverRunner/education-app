import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'week_study_statics.g.dart';

@JsonSerializable()
class WeekStudyStatics {
  bool? status;
  Data? data;

  WeekStudyStatics({this.status, this.data});

  factory WeekStudyStatics.fromJson(Map<String, dynamic> json) {
    return _$WeekStudyStaticsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$WeekStudyStaticsToJson(this);
}
