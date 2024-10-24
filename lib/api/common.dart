import 'dart:convert';
import 'package:yibei_app/utils/http/http.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/common/validate_image_code/validate_image_code.dart';
import 'package:yibei_app/models/common/user_login/user_login.dart';
import 'package:yibei_app/models/common/upload_file/upload_file.dart';
import 'package:yibei_app/models/common/common_return_states/common_return_states.dart';
import 'package:yibei_app/models/course/course_chapter_tree/course_chapter_tree.dart';
import 'package:yibei_app/models/course/course_chapter_list_data/course_chapter_list_data.dart';
import 'package:yibei_app/models/content/content_list/content_list.dart';
import 'package:yibei_app/models/common/version_update/version_update.dart';
import 'package:dio/dio.dart';

import 'package:yibei_app/config/config.dart';

/// 验证帐号
Future<BaseEntity<CommonReturnStates>> validateIsAccount(
  String account,
) async {
  Map<String, dynamic> map = Map();
  map['account'] = account;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '/validateisaccount',
    data: map,
  );
  return Future.value(entity);
}

/// 验证邮箱和手机的验证码
/// [account] 帐号
/// [validateCode] 验证码
Future<BaseEntity<CommonReturnStates>> validateEmailOrPhoneCode({
  required String account,
  required String validateCode,
}) async {
  Map<String, dynamic> map = Map();
  map['codeaccount'] = account;
  map['validatecode'] = validateCode;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '/validatevalicode',
    data: map,
  );
  return Future.value(entity);
}

/// 获取图片验证码
Future<BaseEntity<ValidateImageCode>> getImageCode() async {
  dynamic entity = await HttpUtil.get<ValidateImageCode>(
    '/getvalidatecode',
  );
  return Future.value(entity);
}

/// 登录
Future<BaseEntity<UserLogin>> login(
  String account,
  String password,
  String code,
) async {
  Map<String, dynamic> map = Map();
  map['account'] = account;
  map['password'] = password;
  map['code'] = code;
  map['address'] = '';
  map['lat'] = 0;
  map['lng'] = 0;
  map['devicecate'] = 2;

  dynamic entity = await HttpUtil.post<UserLogin>(
    '/userlogin',
    data: map,
  );
  return Future.value(entity);
}

/// 获取课程列表 - 不需要登录的
Future<BaseEntity<CourseChapterTree>> getCourseListNoLogin() async {
  dynamic entity = await HttpUtil.get<CourseChapterTree>(
    '/getcourselist',
  );
  return Future.value(entity);
}

/// 获取课程的章节列表 - 不需要登录的
/// [courseId] 课程id
Future<BaseEntity<CourseChapterListData>> getCourseChapterListNoLogin({
  required int courseId,
  bool showLoading = false,
}) async {
  Map<String, dynamic> map = Map();
  map['courseid'] = courseId;

  dynamic entity = await HttpUtil.get<CourseChapterListData>(
    '/getcoursechapterlist',
    params: map,
  );
  return Future.value(entity);
}

/// 获取文章列表
/// [category] 文章类型
/// [showLoading] 是否显示加载器
Future<BaseEntity<ContentList>> getContentListNoLogin({
  required int category,
  bool showLoading = false,
}) async {
  Map<String, dynamic> map = Map();
  map['category'] = category;

  dynamic entity = await HttpUtil.get<ContentList>(
    '/getcontentpagelist',
    params: map,
  );
  return Future.value(entity);
}

/// 游客登录/注册
/// [touristId] 游客的设备id
/// [channel] 渠道
Future<BaseEntity<UserLogin>> touristLoginRegister({
  required String touristId,
  required String channel,
}) async {
  Map<String, dynamic> map = Map();
  map['touristId'] = touristId;
  map['channel'] = channel;

  dynamic entity = await HttpUtil.post<UserLogin>(
    '/touristLoginRegister',
    data: map,
  );
  return Future.value(entity);
}

/// 上传图片
/// [filePath] 图片路径
Future<BaseEntity<UploadFile>> uploadImage({
  required String filePath,
}) async {
  dynamic entity = await HttpUtil.uploadFile<UploadFile>(
    '/uploadhandler/image',
    filePath: filePath,
  );
  return Future.value(entity);
}

/// 获取更新版本
/// platform 平台：ios、android
Future<BaseEntity<VersionUpdate>> getVersionUpdate({
  required String platform,
  bool showLoading = false,
}) async {
  Map<String, dynamic> map = Map();
  map['platform'] = platform;

  dynamic entity = await HttpUtil.get<VersionUpdate>(
    '/app/getUpdateInfo',
    params: map,
    options: Options(
      extra: {
        'showLoading': showLoading,
      },
    ),
  );
  return Future.value(entity);
}
