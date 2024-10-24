import 'package:json_annotation/json_annotation.dart';

part 'upload_file.g.dart';

@JsonSerializable()
class UploadFile {
  bool? status;
  String? path;

  UploadFile({this.status, this.path});

  factory UploadFile.fromJson(Map<String, dynamic> json) {
    return _$UploadFileFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UploadFileToJson(this);
}
