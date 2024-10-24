// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_test_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseTestListItem _$CourseTestListItemFromJson(Map<String, dynamic> json) =>
    CourseTestListItem(
      id: json['id'] as int?,
      paperid: json['paperid'] as int?,
      requestionid: json['requestionid'] as int?,
      requestid: json['requestid'] as int?,
      answer: json['answer'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      yibeiRequestionConst: json['yibei_requestion_const'] == null
          ? null
          : YibeiRequestionConst.fromJson(
              json['yibei_requestion_const'] as Map<String, dynamic>),
      yibeiRequestionConstOption: (json['yibei_requestion_const_option']
              as List<dynamic>?)
          ?.map((e) =>
              YibeiRequestionConstOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      yibeiNewdcwordPaperConst:
          (json['yibei_newdcword_paper_const'] as List<dynamic>?)
              ?.map((e) =>
                  YibeiNewdcwordPaperConst.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$CourseTestListItemToJson(CourseTestListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paperid': instance.paperid,
      'requestionid': instance.requestionid,
      'requestid': instance.requestid,
      'answer': instance.answer,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'yibei_requestion_const': instance.yibeiRequestionConst,
      'yibei_requestion_const_option': instance.yibeiRequestionConstOption,
      'yibei_newdcword_paper_const': instance.yibeiNewdcwordPaperConst,
    };
