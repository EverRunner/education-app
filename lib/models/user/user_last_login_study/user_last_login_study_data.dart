import 'package:json_annotation/json_annotation.dart';

import 'study_data.dart';

part 'user_last_login_study_data.g.dart';

@JsonSerializable()
class UserLastLoginStudyData {
  StudyData? studyData;
  double? unitTestAvg;
  int? kgskgAvg;
  int? mykgAvg;

  UserLastLoginStudyData(
      {this.studyData, this.unitTestAvg, this.kgskgAvg, this.mykgAvg});

  factory UserLastLoginStudyData.fromJson(Map<String, dynamic> json) =>
      _$UserLastLoginStudyDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserLastLoginStudyDataToJson(this);
}
