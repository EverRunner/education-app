// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_chapter_word_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseChapterWordListItem _$CourseChapterWordListItemFromJson(
        Map<String, dynamic> json) =>
    CourseChapterWordListItem(
      id: json['id'] as int?,
      paperid: json['paperid'] as int?,
      atitle: json['atitle'] as String?,
      btitle: json['btitle'] as String?,
      voicepath: json['voicepath'],
      sort: json['sort'] as int?,
      answer: json['answer'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      answerList: (json['answerList'] as List<dynamic>?)
          ?.map((e) => AnswerListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseChapterWordListItemToJson(
        CourseChapterWordListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paperid': instance.paperid,
      'atitle': instance.atitle,
      'btitle': instance.btitle,
      'voicepath': instance.voicepath,
      'sort': instance.sort,
      'answer': instance.answer,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'answerList': instance.answerList,
    };
