// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_before_word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestBeforeWord _$TestBeforeWordFromJson(Map<String, dynamic> json) =>
    TestBeforeWord(
      answer: json['answer'],
      atitle: json['atitle'] as String?,
      btitle: json['btitle'] as String?,
      answerList: (json['answerList'] as List<dynamic>?)
          ?.map((e) => AnswerList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TestBeforeWordToJson(TestBeforeWord instance) =>
    <String, dynamic>{
      'answer': instance.answer,
      'atitle': instance.atitle,
      'btitle': instance.btitle,
      'answerList': instance.answerList,
    };
