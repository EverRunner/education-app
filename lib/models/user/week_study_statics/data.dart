import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  int? currentweekstudytime;
  int? todaystudytime;
  List<int>? currentWeekData;
  List<int>? lastWeekData;
  double? sysavg;
  List<double>? sysAvgData;
  double? contrastlvoflastweek;

  Data({
    this.currentweekstudytime,
    this.todaystudytime,
    this.currentWeekData,
    this.lastWeekData,
    this.sysavg,
    this.sysAvgData,
    this.contrastlvoflastweek,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
