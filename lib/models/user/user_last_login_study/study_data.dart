import 'package:json_annotation/json_annotation.dart';

part 'study_data.g.dart';

@JsonSerializable()
class StudyData {
  @JsonKey(name: 'video_study_times')
  int? videoStudyTimes;
  @JsonKey(name: 'keywordchen_test_times')
  int? keywordchenTestTimes;
  @JsonKey(name: 'keyworden_test_times')
  int? keywordenTestTimes;
  @JsonKey(name: 'unit_test_times')
  int? unitTestTimes;

  StudyData({
    this.videoStudyTimes,
    this.keywordchenTestTimes,
    this.keywordenTestTimes,
    this.unitTestTimes,
  });

  factory StudyData.fromJson(Map<String, dynamic> json) {
    return _$StudyDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$StudyDataToJson(this);
}
