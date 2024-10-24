// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yibei_newdcword_paper_const_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YibeiNewdcwordPaperConstItem _$YibeiNewdcwordPaperConstItemFromJson(
        Map<String, dynamic> json) =>
    YibeiNewdcwordPaperConstItem(
      id: json['id'] as int?,
      paperid: json['paperid'] as int?,
      sort: json['sort'] as int?,
      atitle: json['atitle'] as String?,
      btitle: json['btitle'] as String?,
      voicepath: json['voicepath'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$YibeiNewdcwordPaperConstItemToJson(
        YibeiNewdcwordPaperConstItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paperid': instance.paperid,
      'sort': instance.sort,
      'atitle': instance.atitle,
      'btitle': instance.btitle,
      'voicepath': instance.voicepath,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
