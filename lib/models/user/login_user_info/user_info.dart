import 'package:json_annotation/json_annotation.dart';

import 'yibei_member_category.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInfo {
  int? id;
  String? username;
  dynamic avatar;
  int? oldid;
  @JsonKey(name: 'unionid_wx')
  dynamic unionidWx;
  @JsonKey(name: 'openid_wx')
  dynamic openidWx;
  @JsonKey(name: 'openid_gg')
  dynamic openidGg;
  int? category;
  int? level;
  dynamic firstname;
  dynamic lastname;
  dynamic nickname;
  dynamic account;
  String? sharecode;
  dynamic tuijiancode;
  int? parentid;
  DateTime? birthdayyear;
  dynamic birthdaymonth;
  String? sex;
  int? sort;
  int? type;
  dynamic channel;
  String? email;
  String? phone;
  String? address;
  String? youbian;
  String? remark;
  int? allstudydate;
  int? allstudytime;
  DateTime? creathydate;
  DateTime? endhydate;
  DateTime? examdate;
  DateTime? kaoshidate;
  DateTime? laststudyworddate;
  dynamic studydate;
  int? isbuquan;
  int? isnewuser;
  int? progresstype;
  double? avgzhongwen;
  double? avgenglish;
  int? progresscourseid;
  int? progresschapterid;
  int? stepflag;
  int? isdel;
  int? payelsecount;
  String? aiycwctime;
  String? aiyctgtime;
  String? rotedegree;
  String? degreecontent;
  int? vipstatus;
  DateTime? vipchangedate;
  int? ismorereq;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  @JsonKey(name: 'yibei_member_category')
  YibeiMemberCategory? yibeiMemberCategory;
  int? payElseCount;
  double? hasStudyCourseFv;
  double? hasStudyFv;
  int? logincount;
  bool? isVip;
  int? chascount;
  int? allcount;
  int? xfpaycount;
  double? studytimeavg;

  UserInfo(
      {this.id,
      this.username,
      this.avatar,
      this.oldid,
      this.unionidWx,
      this.openidWx,
      this.openidGg,
      this.category,
      this.level,
      this.firstname,
      this.lastname,
      this.nickname,
      this.account,
      this.sharecode,
      this.tuijiancode,
      this.parentid,
      this.birthdayyear,
      this.birthdaymonth,
      this.sex,
      this.sort,
      this.type,
      this.channel,
      this.email,
      this.phone,
      this.address,
      this.youbian,
      this.remark,
      this.allstudydate,
      this.allstudytime,
      this.creathydate,
      this.endhydate,
      this.examdate,
      this.kaoshidate,
      this.laststudyworddate,
      this.studydate,
      this.isbuquan,
      this.isnewuser,
      this.progresstype,
      this.avgzhongwen,
      this.avgenglish,
      this.progresscourseid,
      this.progresschapterid,
      this.stepflag,
      this.isdel,
      this.payelsecount,
      this.aiycwctime,
      this.aiyctgtime,
      this.rotedegree,
      this.degreecontent,
      this.vipstatus,
      this.vipchangedate,
      this.ismorereq,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.yibeiMemberCategory,
      this.payElseCount,
      this.hasStudyCourseFv,
      this.hasStudyFv,
      this.logincount,
      this.isVip,
      this.chascount,
      this.allcount,
      this.xfpaycount,
      this.studytimeavg});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return _$UserInfoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
