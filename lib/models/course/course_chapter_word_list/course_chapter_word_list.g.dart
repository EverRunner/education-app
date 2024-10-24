// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_chapter_word_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseChapterWordList _$CourseChapterWordListFromJson(
        Map<String, dynamic> json) =>
    CourseChapterWordList(
      status: json['status'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              CourseChapterWordListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseChapterWordListToJson(
        CourseChapterWordList instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
