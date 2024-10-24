import 'dart:convert';
import 'package:yibei_app/utils/http/http.dart';
import 'package:dio/dio.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/content/content_list/content_list.dart';
import 'package:yibei_app/models/content/content_details/content_details.dart';

const String content = '/content';

/// 获取文章列表
/// [category] 文章类型
/// [showLoading] 是否显示加载器
Future<BaseEntity<ContentList>> getContentList({
  required int category,
  bool showLoading = false,
}) async {
  Map<String, dynamic> map = Map();
  map['category'] = category;

  dynamic entity = await HttpUtil.get<ContentList>(
    '$content/getcontentpagelist',
    params: map,
    options: Options(
      extra: {
        'showLoading': showLoading,
      },
    ),
  );
  return Future.value(entity);
}

/// 获取文章详情
/// [id] 文章id
/// [showLoading] 是否显示加载器
Future<BaseEntity<ContentDetails>> getContentDetails({
  required int id,
}) async {
  Map<String, dynamic> map = Map();
  map['id'] = id;

  dynamic entity = await HttpUtil.get<ContentDetails>(
    '$content/getcontentdatabyid',
    params: map,
  );
  return Future.value(entity);
}
