// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_error_questtest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyErrorQuesttest _$MyErrorQuesttestFromJson(Map<String, dynamic> json) =>
    MyErrorQuesttest(
      status: json['status'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyErrorQuesttestToJson(MyErrorQuesttest instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
