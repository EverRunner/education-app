import 'package:json_annotation/json_annotation.dart';

part 'study_const.g.dart';

@JsonSerializable()
class StudyConst {
  bool? status;
  int? id;
  String? err;

  StudyConst({this.status, this.id, this.err});

  factory StudyConst.fromJson(Map<String, dynamic> json) {
    return _$StudyConstFromJson(json);
  }

  Map<String, dynamic> toJson() => _$StudyConstToJson(this);
}
