import 'package:json_annotation/json_annotation.dart';

part 'version_update_data.g.dart';

@JsonSerializable()
class VersionUpdateData {
  int? id;
  String? appid;
  String? version;
  String? description;
  String? platform;
  String? downloadurl;
  int? isforceupdate;
  DateTime? createdAt;
  DateTime? updatedAt;

  VersionUpdateData({
    this.id,
    this.appid,
    this.version,
    this.description,
    this.platform,
    this.downloadurl,
    this.isforceupdate,
    this.createdAt,
    this.updatedAt,
  });

  factory VersionUpdateData.fromJson(Map<String, dynamic> json) =>
      _$VersionUpdateDataFromJson(json);

  Map<String, dynamic> toJson() => _$VersionUpdateDataToJson(this);
}
