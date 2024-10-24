// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_floow_member_datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyFloowMemberDatum _$MyFloowMemberDatumFromJson(Map<String, dynamic> json) =>
    MyFloowMemberDatum(
      memberid: json['memberid'] as int?,
      username: json['username'] as String?,
      creathydate: json['creathydate'] == null
          ? null
          : DateTime.parse(json['creathydate'] as String),
    );

Map<String, dynamic> _$MyFloowMemberDatumToJson(MyFloowMemberDatum instance) =>
    <String, dynamic>{
      'memberid': instance.memberid,
      'username': instance.username,
      'creathydate': instance.creathydate?.toIso8601String(),
    };
