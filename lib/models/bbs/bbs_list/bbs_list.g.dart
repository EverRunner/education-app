// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bbs_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BbsList _$BbsListFromJson(Map<String, dynamic> json) => BbsList(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BbsListToJson(BbsList instance) => <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
