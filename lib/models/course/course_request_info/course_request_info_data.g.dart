// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_request_info_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseRequestInfoData _$CourseRequestInfoDataFromJson(
        Map<String, dynamic> json) =>
    CourseRequestInfoData(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'],
      qualifiedproportion: (json['qualifiedproportion'] as num?)?.toDouble(),
      isrepeattest: json['isrepeattest'] as int?,
      timelimit: json['timelimit'] as int?,
      randomcount: json['randomcount'] as int?,
      sort: json['sort'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CourseRequestInfoDataToJson(
        CourseRequestInfoData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'qualifiedproportion': instance.qualifiedproportion,
      'isrepeattest': instance.isrepeattest,
      'timelimit': instance.timelimit,
      'randomcount': instance.randomcount,
      'sort': instance.sort,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
