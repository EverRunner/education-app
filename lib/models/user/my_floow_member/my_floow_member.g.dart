// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_floow_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyFloowMember _$MyFloowMemberFromJson(Map<String, dynamic> json) =>
    MyFloowMember(
      status: json['status'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MyFloowMemberDatum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyFloowMemberToJson(MyFloowMember instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
