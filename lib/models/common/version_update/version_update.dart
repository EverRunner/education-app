import 'package:json_annotation/json_annotation.dart';

import 'version_update_data.dart';

part 'version_update.g.dart';

@JsonSerializable()
class VersionUpdate {
  bool? status;
  VersionUpdateData? data;

  VersionUpdate({this.status, this.data});

  factory VersionUpdate.fromJson(Map<String, dynamic> json) {
    return _$VersionUpdateFromJson(json);
  }

  Map<String, dynamic> toJson() => _$VersionUpdateToJson(this);
}
