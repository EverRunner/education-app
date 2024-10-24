import 'package:json_annotation/json_annotation.dart';

import 'user_radar_statics_datum.dart';

part 'user_radar_statics.g.dart';

@JsonSerializable()
class UserRadarStatics {
  bool? status;
  double? disLastLoginTimes;
  List<UserRadarStaticsDatum>? data;

  UserRadarStatics({this.status, this.disLastLoginTimes, this.data});

  factory UserRadarStatics.fromJson(Map<String, dynamic> json) {
    return _$UserRadarStaticsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserRadarStaticsToJson(this);
}
