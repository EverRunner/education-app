import 'package:json_annotation/json_annotation.dart';

part 'user_radar_statics_datum.g.dart';

@JsonSerializable()
class UserRadarStaticsDatum {
  @JsonKey(name: 'vedio_mine_duration')
  double? vedioMineDuration;
  @JsonKey(name: 'vedio_allavg_duration')
  double? vedioAllavgDuration;
  @JsonKey(name: 'vedio_kaoguoavg_duration')
  double? vedioKaoguoavgDuration;
  @JsonKey(name: 'enstudy_mine_duration')
  double? enstudyMineDuration;
  @JsonKey(name: 'enstudy_allavg_duration')
  double? enstudyAllavgDuration;
  @JsonKey(name: 'enstudy_kaoguoavg_duration')
  double? enstudyKaoguoavgDuration;
  @JsonKey(name: 'entest_mine_duration')
  double? entestMineDuration;
  @JsonKey(name: 'entest_allavg_duration')
  double? entestAllavgDuration;
  @JsonKey(name: 'entest_kaoguoavg_duration')
  double? entestKaoguoavgDuration;
  @JsonKey(name: 'chaptertest_mine_duration')
  double? chaptertestMineDuration;
  @JsonKey(name: 'chaptertest_allavg_duration')
  double? chaptertestAllavgDuration;
  @JsonKey(name: 'chaptertest_kaoguoavg_duration')
  double? chaptertestKaoguoavgDuration;
  @JsonKey(name: 'chentest_mine_duration')
  double? chentestMineDuration;
  @JsonKey(name: 'chentest_allavg_duration')
  double? chentestAllavgDuration;
  @JsonKey(name: 'chentest_kaoguoavg_duration')
  double? chentestKaoguoavgDuration;
  @JsonKey(name: 'chenstudy_mine_duration')
  double? chenstudyMineDuration;
  @JsonKey(name: 'chenstudy_allavg_duration')
  double? chenstudyAllavgDuration;
  @JsonKey(name: 'chenstudy_kaoguoavg_duration')
  double? chenstudyKaoguoavgDuration;
  @JsonKey(name: 'mine_vediostudy_count')
  int? mineVediostudyCount;
  @JsonKey(name: 'mine_keywordtest_count')
  int? mineKeywordtestCount;
  @JsonKey(name: 'mine_chatpertest_avg')
  double? mineChatpertestAvg;

  UserRadarStaticsDatum({
    this.vedioMineDuration,
    this.vedioAllavgDuration,
    this.vedioKaoguoavgDuration,
    this.enstudyMineDuration,
    this.enstudyAllavgDuration,
    this.enstudyKaoguoavgDuration,
    this.entestMineDuration,
    this.entestAllavgDuration,
    this.entestKaoguoavgDuration,
    this.chaptertestMineDuration,
    this.chaptertestAllavgDuration,
    this.chaptertestKaoguoavgDuration,
    this.chentestMineDuration,
    this.chentestAllavgDuration,
    this.chentestKaoguoavgDuration,
    this.chenstudyMineDuration,
    this.chenstudyAllavgDuration,
    this.chenstudyKaoguoavgDuration,
    this.mineVediostudyCount,
    this.mineKeywordtestCount,
    this.mineChatpertestAvg,
  });

  factory UserRadarStaticsDatum.fromJson(Map<String, dynamic> json) =>
      _$UserRadarStaticsDatumFromJson(json);

  Map<String, dynamic> toJson() => _$UserRadarStaticsDatumToJson(this);
}
