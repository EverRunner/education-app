import 'package:dio/dio.dart';
import 'package:yibei_app/utils/http/http.dart';
import 'package:yibei_app/config/config.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/user/week_study_statics/week_study_statics.dart';
import 'package:yibei_app/models/user/login_user_info/login_user_info.dart';
import 'package:yibei_app/models/user/user_radar_statics/user_radar_statics.dart';
import 'package:yibei_app/models/common/common_return_states/common_return_states.dart';
import 'package:yibei_app/models/course/study_const/study_const.dart';
import 'package:yibei_app/models/course/course_final_test_pass/course_final_test_pass.dart';
import 'package:yibei_app/models/user/member_test_detail_log/member_test_detail_log.dart';
import 'package:yibei_app/models/user/my_floow_member/my_floow_member.dart';
import 'package:yibei_app/models/user/my_buy_order_data/my_buy_order_data.dart';
import 'package:yibei_app/models/user/user_last_login_study/user_last_login_study.dart';
import 'package:yibei_app/models/user/user_chapter_study_log/user_chapter_study_log.dart';

const String user = '/user';

/// 发送邮箱验证码-注册时
/// [email] 邮箱号
/// [imgCode] 片验证码
Future<BaseEntity<CommonReturnStates>> sendValidateToEmail({
  required String email,
  required String imgCode,
}) async {
  Map<String, dynamic> map = Map();
  map['email'] = email;
  map['validatecode'] = imgCode;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$user/sendvalidatetoemail',
    data: map,
  );
  return Future.value(entity);
}

/// 发送手机验证码-注册时
/// [phone] 手机号
/// [imgCode] 图片验证码
Future<BaseEntity<CommonReturnStates>> sendValidateToPhone({
  required String phone,
  required String imgCode,
}) async {
  Map<String, dynamic> map = Map();
  map['phone'] = phone;
  map['validatecode'] = imgCode;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$user/sendvalidatetophone',
    data: map,
  );
  return Future.value(entity);
}

/// 使用手机号注册
/// [phone] 手机号
/// [password] 密码
/// [channel] 渠道
/// [phoneCode] 手机验证码
/// [userName] 用户姓名
Future<BaseEntity<CommonReturnStates>> registerPhone({
  required String phone,
  required String password,
  required String channel,
  required String phoneCode,
  required String userName,
}) async {
  Map<String, dynamic> map = Map();
  map['phone'] = phone;
  map['password'] = password;
  map['channel'] = channel;
  map['phonecode'] = phoneCode;
  map['username'] = userName;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$user/registerphone',
    data: map,
  );
  return Future.value(entity);
}

/// 使用邮箱注册
/// [email] 手机号
/// [password] 密码
/// [channel] 渠道
/// [emailCode] 邮箱证码
/// [userName] 用户姓名
Future<BaseEntity<CommonReturnStates>> registerEmail({
  required String email,
  required String password,
  required String channel,
  required String emailCode,
  required String userName,
}) async {
  Map<String, dynamic> map = Map();
  map['email'] = email;
  map['password'] = password;
  map['channel'] = channel;
  map['phonecode'] = emailCode;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$user/registeremail',
    data: map,
  );
  return Future.value(entity);
}

/// 获取本周的学习数据
Future<BaseEntity<WeekStudyStatics>> getWeekStudyStatics({
  bool showLoading = true,
}) async {
  dynamic entity = await HttpUtil.get<WeekStudyStatics>(
    '$user/getmemberweekstudystatics',
    options: Options(
      extra: {
        'showLoading': showLoading,
      },
    ),
  );
  return Future.value(entity);
}

/// 获取登录用户信息
Future<BaseEntity<LoginUserInfo>> getLoginUserInfo({
  bool showLoading = true,
}) async {
  dynamic entity = await HttpUtil.get<LoginUserInfo>(
    '$user/getloginuserinfo',
    options: Options(
      extra: {
        'showLoading': false,
      },
    ),
  );
  return Future.value(entity);
}

/// 获取当前用户的学习雷达图
Future<BaseEntity<UserRadarStatics>> getUserRadarStatics({
  bool showLoading = true,
}) async {
  dynamic entity = await HttpUtil.get<UserRadarStatics>(
    '$user/getcurrentuserstudyalanydata',
    options: Options(
      extra: {
        'showLoading': showLoading,
      },
    ),
  );
  return Future.value(entity);
}

/// 增加学习总时长
/// [limit] 增加的时长
Future<BaseEntity<CommonReturnStates>> addStudyTime({
  int limit = 10,
}) async {
  Map<String, dynamic> map = Map();
  map['limit'] = limit;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$user/addallstudytime',
    data: map,
    options: Options(
      extra: {
        'showLoading': false,
      },
    ),
  );
  return Future.value(entity);
}

/// 创建学习页面的停留信息及时间等
/// [courseId] 课程id
/// [chapterId] 章节id
/// [category] 类型  * 1:视频  2:记单词（中英） 3:记单词（中英）测试   4:记单词（英）  5：记单词（中英）测试   6:单元测试   7.单元测试前关键词
///  8:我的错题（测前单词） 9:我的错题测试   10:高频错题（测前单词）  11:高频错题测试  12:综合题（测前单词）  13:综合题测试  14:应变测试（测前单词）  15:应变测试
Future<BaseEntity<StudyConst>> createStudyConst({
  required int courseId,
  required int chapterId,
  required int category,
}) async {
  Map<String, dynamic> map = Map();
  map['courseid'] = courseId;
  map['chapterid'] = chapterId;
  map['category'] = category;

  dynamic entity = await HttpUtil.post<StudyConst>(
    '$user/creatstudyconst',
    data: map,
    options: Options(
      extra: {
        'showLoading': false,
      },
    ),
  );
  return Future.value(entity);
}

/// 更新学习页面的停留信息及时间等
/// [studyId] 创建返回的id
/// [testScore] 测试分数
/// [testFinishTime] 测试完成时间
Future<BaseEntity<StudyConst>> updateStudyConst({
  required int studyId,
  double? testScore,
  DateTime? testFinishTime,
}) async {
  Map<String, dynamic> map = Map();
  map['studyid'] = studyId;
  map['testscore'] = testScore;
  map['testfinishtime'] = testFinishTime.toString();

  dynamic entity = await HttpUtil.post<StudyConst>(
    '$user/updatestudyconst',
    data: map,
    options: Options(
      extra: {
        'showLoading': false,
      },
    ),
  );
  return Future.value(entity);
}

/// 更新当前用户学习关键词的日期
Future<BaseEntity<CommonReturnStates>> updateWordTime() async {
  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$user/updatestudyworddate',
    options: Options(
      extra: {
        'showLoading': false,
      },
    ),
  );
  return Future.value(entity);
}

/// 获取Final章节的关键词是否己学习过
/// [courseId] 课程id
/// [chapterId] 章节id
Future<BaseEntity<CourseFinalTestPass>> getCourseFinalTestPass({
  required int courseId,
  required int chapterId,
}) async {
  Map<String, dynamic> map = Map();
  map['courseid'] = courseId;
  map['chapterid'] = chapterId;

  dynamic entity = await HttpUtil.get<CourseFinalTestPass>(
    '$user/getcoursechatperother',
    params: map,
  );
  return Future.value(entity);
}

/// 删除Final章节的关键词是否己学习过
/// [courseId] 课程id
/// [chapterId] 章节id
Future<BaseEntity<CommonReturnStates>> deleteCourseChapterOther({
  required int courseId,
  required int chapterId,
}) async {
  Map<String, dynamic> map = Map();
  map['courseid'] = courseId;
  map['chapterid'] = chapterId;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$user/deletecoursechatperother',
    data: map,
    options: Options(
      extra: {
        'showLoading': false,
      },
    ),
  );
  return Future.value(entity);
}

/// 设置Final章节的关键词是否己学习过
/// [courseId] 课程id
/// [chapterId] 章节id
Future<BaseEntity<CommonReturnStates>> setCourseChapterOther({
  required int courseId,
  required int chapterId,
}) async {
  Map<String, dynamic> map = Map();
  map['courseid'] = courseId;
  map['chapterid'] = chapterId;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$user/creatcoursechatperother',
    data: map,
  );
  return Future.value(entity);
}

/// 获取综合测试、我的错题、高频记录
Future<BaseEntity<MemberTestDetailLog>> getMemberTestLog() async {
  dynamic entity = await HttpUtil.get<MemberTestDetailLog>(
    '$user/getmembercttestdetaillog',
    options: Options(
      extra: {
        'showLoading': false,
      },
    ),
  );
  return Future.value(entity);
}

/// 发送邮箱验证码
/// [email] 邮箱号
/// [imgCode] 片验证码
Future<BaseEntity<CommonReturnStates>> sendEmailValidateCode({
  required String email,
  required String imgCode,
}) async {
  Map<String, dynamic> map = Map();
  map['email'] = email;
  map['validatecode'] = imgCode;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$user/sendemaitochangebindemail',
    data: map,
  );
  return Future.value(entity);
}

/// 修改邮箱号
/// [email] 邮箱号
/// [validateCode] 邮箱验证码
Future<BaseEntity<CommonReturnStates>> changeBindEmail({
  required String email,
  required String validateCode,
}) async {
  Map<String, dynamic> map = Map();
  map['email'] = email;
  map['validatecode'] = validateCode;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$user/changebindemail',
    data: map,
  );
  return Future.value(entity);
}

/// 发送手机验证码
/// [phone] 手机号
/// [imgCode] 图片验证码
Future<BaseEntity<CommonReturnStates>> sendPhoneValidateCode({
  required String phone,
  required String imgCode,
}) async {
  Map<String, dynamic> map = Map();
  map['phone'] = phone;
  map['validatecode'] = imgCode;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$user/sendphonetochangebindphone',
    data: map,
  );
  return Future.value(entity);
}

/// 修改手机号
/// [phone] 手机号
/// [validateCode] 手机证码
Future<BaseEntity<CommonReturnStates>> changeBindPhone({
  required String phone,
  required String validateCode,
}) async {
  Map<String, dynamic> map = Map();
  map['phone'] = phone;
  map['validatecode'] = validateCode;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$user/changebindphone',
    data: map,
  );
  return Future.value(entity);
}

/// 修改用户密码
/// [newPassword] 旧密码，可以为空，有的老用户没有密码
/// [newPassword] 新密码
Future<BaseEntity<CommonReturnStates>> changeUserPassword({
  String? oldPassword,
  required String newPassword,
}) async {
  Map<String, dynamic> map = Map();
  map['oldpwd'] = oldPassword;
  map['newpwd'] = newPassword;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$user/changeuserpwd',
    data: map,
  );
  return Future.value(entity);
}

/// 修改用户信息
/// [userName] 用户名
/// [birthday] 出生年月日
/// [postcode] 邮编
/// [address] 地址
/// [sex] 性别
Future<BaseEntity<CommonReturnStates>> updateUserInfo({
  required String userName,
  required String birthday,
  required String postcode,
  required String address,
  required int sex,
}) async {
  Map<String, dynamic> map = Map();
  map['username'] = userName;
  map['birthdayyear'] = birthday;
  map['youbian'] = postcode;
  map['address'] = address;
  map['sex'] = sex;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$user/updateuserinfo',
    data: map,
  );
  return Future.value(entity);
}

/// 获取成功推荐的朋友列表
Future<BaseEntity<MyFloowMember>> getRecommendFriendList() async {
  dynamic entity = await HttpUtil.get<MyFloowMember>(
    '$user/getmyfloowmember',
  );
  return Future.value(entity);
}

/// 获取我的购买记录
/// [pageIndex] 页码
/// [pageSize] 条数
/// [status] 状态
Future<BaseEntity<MyBuyOrderData>> getMyOrderPageList({
  int pageIndex = 1,
  int pageSize = Config.page_size,
  int? status,
}) async {
  Map<String, dynamic> map = Map();
  map['pageindex'] = pageIndex;
  map['pagesize'] = pageSize;
  map['status'] = status;

  dynamic entity = await HttpUtil.get<MyBuyOrderData>(
    '$user/getmyorderpagelist',
    params: map,
  );
  return Future.value(entity);
}

/// 获取用户上一次学习的记录情况
Future<BaseEntity<UserLastLoginStudy>> getUserLastLoginStudyConst() async {
  dynamic entity = await HttpUtil.get<UserLastLoginStudy>(
    '$user/getuserlastloginstudyconst',
  );
  return Future.value(entity);
}

/// 获取当前用户章节学习最近详细记录
Future<BaseEntity<UserChapterStudyLog>> getUserChapterStudy(
  int chapterid,
) async {
  Map<String, dynamic> map = Map();
  map['chapterid'] = chapterid;

  dynamic entity = await HttpUtil.get<UserChapterStudyLog>(
    '$user/getmemberchapterdetaillog',
    params: map,
  );
  return Future.value(entity);
}

/// 删除用户
Future<BaseEntity<CommonReturnStates>> deleteUser() async {
  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$user/deleteUser',
  );
  return Future.value(entity);
}

///
///
///
///
///
///
/// 发送邮箱验证码 - 找回密码
/// [email] 邮箱号
/// [imgCode] 验证码
Future<BaseEntity<CommonReturnStates>> sendEmailValidateCodePassword({
  required String email,
  required String imgCode,
}) async {
  Map<String, dynamic> map = Map();
  map['email'] = email;
  map['validatecode'] = imgCode;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$user/sendfindpwdemailcode',
    data: map,
  );
  return Future.value(entity);
}

/// 发送手机验证码 - 找回密码
/// [phone] 手机号
/// [imgCode] 图片验证码
Future<BaseEntity<CommonReturnStates>> sendPhoneValidateCodePassword({
  required String phone,
  required String imgCode,
}) async {
  Map<String, dynamic> map = Map();
  map['phone'] = phone;
  map['validatecode'] = imgCode;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$user/sendfindpwdphonecode',
    data: map,
  );
  return Future.value(entity);
}

/// 找回密码
/// [account] 帐号
/// [password] 新密码
/// [findpwdcode] 验证码
Future<BaseEntity<CommonReturnStates>> retrievePassword({
  required String account,
  required String password,
  required String findpwdcode,
}) async {
  Map<String, dynamic> map = Map();
  map['account'] = account;
  map['password'] = password;
  map['findpwdcode'] = findpwdcode;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$user/updateuserpassword',
    data: map,
  );
  return Future.value(entity);
}
