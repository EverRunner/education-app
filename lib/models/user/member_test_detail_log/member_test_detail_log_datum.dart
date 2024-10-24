import 'package:json_annotation/json_annotation.dart';

part 'member_test_detail_log_datum.g.dart';

@JsonSerializable()
class MemberTestDetailLogDatum {
  @JsonKey(name: 'error_testbeforekeyword_time')
  DateTime? errorTestbeforekeywordTime;
  @JsonKey(name: 'error_testbeforeword_time')
  DateTime? errorTestbeforewordTime;
  @JsonKey(name: 'error_test_score')
  double? errorTestScore;
  @JsonKey(name: 'gaoping_testbeforekeyword_time')
  DateTime? gaopingTestbeforekeywordTime;
  @JsonKey(name: 'gaoping_testbeforeword_time')
  dynamic gaopingTestbeforewordTime;
  @JsonKey(name: 'gaoping_testbeforeword_score')
  double? gaopingTestbeforewordScore;
  @JsonKey(name: 'zonghe_testbeforekeyword_time')
  DateTime? zongheTestbeforekeywordTime;
  @JsonKey(name: 'zonghe_testbeforeword_time')
  dynamic zongheTestbeforewordTime;
  @JsonKey(name: 'zonghe_testbeforeword_score')
  double? zongheTestbeforewordScore;
  @JsonKey(name: 'strain_testbeforekeyword_time')
  DateTime? strainTestbeforekeywordTime;
  @JsonKey(name: 'strain_testbeforeword_time')
  DateTime? strainTestbeforewordTime;
  @JsonKey(name: 'strain_testbeforeword_score')
  double? strainTestbeforewordScore;

  MemberTestDetailLogDatum({
    this.errorTestbeforekeywordTime,
    this.errorTestbeforewordTime,
    this.errorTestScore,
    this.gaopingTestbeforekeywordTime,
    this.gaopingTestbeforewordTime,
    this.gaopingTestbeforewordScore,
    this.zongheTestbeforekeywordTime,
    this.zongheTestbeforewordTime,
    this.zongheTestbeforewordScore,
    this.strainTestbeforekeywordTime,
    this.strainTestbeforewordTime,
    this.strainTestbeforewordScore,
  });

  factory MemberTestDetailLogDatum.fromJson(Map<String, dynamic> json) =>
      _$MemberTestDetailLogDatumFromJson(json);

  Map<String, dynamic> toJson() => _$MemberTestDetailLogDatumToJson(this);
}
