// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yibei_newdcword_paper_const.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YibeiNewdcwordPaperConst _$YibeiNewdcwordPaperConstFromJson(
        Map<String, dynamic> json) =>
    YibeiNewdcwordPaperConst(
      id: json['id'] as int?,
      requestid: json['requestid'] as int?,
      wordsid: json['wordsid'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      yibeiNewdcwordPaperConstItem: json['yibei_newdcword_paper_const'] == null
          ? null
          : YibeiNewdcwordPaperConstItem.fromJson(
              json['yibei_newdcword_paper_const'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$YibeiNewdcwordPaperConstToJson(
        YibeiNewdcwordPaperConst instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestid': instance.requestid,
      'wordsid': instance.wordsid,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'yibei_newdcword_paper_const': instance.yibeiNewdcwordPaperConstItem,
    };
