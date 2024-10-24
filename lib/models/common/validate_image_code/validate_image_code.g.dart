// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validate_image_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidateImageCode _$ValidateImageCodeFromJson(Map<String, dynamic> json) =>
    ValidateImageCode(
      status: json['status'] as bool?,
      v: json['v'] as String?,
      img: json['img'] as String?,
    );

Map<String, dynamic> _$ValidateImageCodeToJson(ValidateImageCode instance) =>
    <String, dynamic>{
      'status': instance.status,
      'v': instance.v,
      'img': instance.img,
    };
