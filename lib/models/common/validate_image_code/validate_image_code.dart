import 'package:json_annotation/json_annotation.dart';

part 'validate_image_code.g.dart';

@JsonSerializable()
class ValidateImageCode {
  bool? status;
  String? v;
  String? img;

  ValidateImageCode({this.status, this.v, this.img});

  factory ValidateImageCode.fromJson(Map<String, dynamic> json) {
    return _$ValidateImageCodeFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ValidateImageCodeToJson(this);
}
