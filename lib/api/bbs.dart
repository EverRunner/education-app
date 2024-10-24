import 'package:dio/dio.dart';
import 'package:yibei_app/utils/http/http.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/common/common_return_states/common_return_states.dart';
import 'package:yibei_app/models/bbs/bbs_list/bbs_list.dart';
import 'package:yibei_app/models/bbs/author_statistics_info/author_statistics_info.dart';
import 'package:yibei_app/models/bbs/post_details/post_details.dart';

// 论坛
const String bbs = '/bbs';

/// 获取帖子列表
/// [userId] 用户id
/// [attention] 是否获取自己关注的列表
/// [latitude] 是否显示加载器
/// [longitude] 是否显示加载器
Future<BaseEntity<BbsList>> getBbsList({
  int? userId,
  int? attention,
  double? latitude,
  double? longitude,
  int? pageSize,
  int? pageIndex,
  bool showLoading = false,
}) async {
  Map<String, dynamic> map = Map();
  map['userId'] = userId;
  map['attention'] = attention;
  map['latitude'] = latitude;
  map['longitude'] = longitude;
  map['pagesize'] = pageSize;
  map['pageindex'] = pageIndex;

  dynamic entity = await HttpUtil.get<BbsList>(
    '$bbs/getartpagelist',
    params: map,
    options: Options(
      extra: {
        'showLoading': showLoading,
      },
    ),
  );
  return Future.value(entity);
}

/// 帖子点赞
/// [id] 帖子id
/// [showLoading] 是否显示加载器
Future<BaseEntity<CommonReturnStates>> setPostLike({
  required int id,
  bool showLoading = false,
}) async {
  Map<String, dynamic> map = Map();
  map['artid'] = id;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$bbs/saveartlike',
    data: map,
    options: Options(
      extra: {
        'showLoading': showLoading,
      },
    ),
  );
  return Future.value(entity);
}

/// 发布帖子
/// [images] 图片集
/// [title] 标题
/// [category] 分类
/// [content] 内容
/// [contact] 联系人
/// [contactNumber] 联系电话
/// [location] 位置（州名字）
/// [latitude] 纬度
/// [longitude] 经度
Future<BaseEntity<CommonReturnStates>> addPost({
  required String images,
  required String title,
  required int category,
  required String content,
  required String contact,
  required String contactNumber,
  required String location,
  required String latitude,
  required String longitude,
}) async {
  Map<String, dynamic> map = Map();
  map['images'] = images;
  map['title'] = title;
  map['category'] = category;
  map['content'] = content;
  map['contact'] = contact;
  map['contactnumber'] = contactNumber;
  map['location'] = location;
  map['latitude'] = latitude;
  map['longitude'] = longitude;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$bbs/creatartconst',
    data: map,
  );
  return Future.value(entity);
}

/// 关注作者
/// [authorId] 作者id
/// [showLoading] 是否显示加载器
Future<BaseEntity<CommonReturnStates>> setAuthorLike({
  required int authorId,
  bool showLoading = false,
}) async {
  Map<String, dynamic> map = Map();
  map['authorId'] = authorId;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$bbs/saveauthorike',
    data: map,
    options: Options(
      extra: {
        'showLoading': showLoading,
      },
    ),
  );
  return Future.value(entity);
}

/// 获取作者的统计信息
/// [authorId] 作者id
Future<BaseEntity<AuthorStatisticsInfo>> getAuthorStatistics({
  int? authorId,
  String? longitude,
}) async {
  Map<String, dynamic> map = Map();
  map['authorId'] = authorId;
  map['longitude'] = longitude;

  dynamic entity = await HttpUtil.get<AuthorStatisticsInfo>(
    '$bbs/getuserstatistics',
    params: map,
    // options: Options(
    //   extra: {
    //     'showLoading': false,
    //   },
    // ),
  );
  return Future.value(entity);
}

/// 增加帖子的浏览记录
/// [artid] 帖子id
/// [showLoading] 是否显示加载器
Future<BaseEntity<CommonReturnStates>> addPostbrowse({
  required int artid,
  bool showLoading = false,
}) async {
  Map<String, dynamic> map = Map();
  map['artid'] = artid;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$bbs/saveartbrowse',
    data: map,
    options: Options(
      extra: {
        'showLoading': showLoading,
      },
    ),
  );
  return Future.value(entity);
}

/// 获取帖子详情
/// [artid] 帖子id
Future<BaseEntity<PostDetails>> getPostDetails({
  required int artid,
}) async {
  Map<String, dynamic> map = Map();
  map['artid'] = artid;

  dynamic entity = await HttpUtil.get<PostDetails>(
    '$bbs/getartdetails',
    params: map,
  );
  return Future.value(entity);
}
