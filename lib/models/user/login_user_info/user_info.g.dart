// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      id: json['id'] as int?,
      username: json['username'] as String?,
      avatar: json['avatar'],
      oldid: json['oldid'] as int?,
      unionidWx: json['unionid_wx'],
      openidWx: json['openid_wx'],
      openidGg: json['openid_gg'],
      category: json['category'] as int?,
      level: json['level'] as int?,
      firstname: json['firstname'],
      lastname: json['lastname'],
      nickname: json['nickname'],
      account: json['account'],
      sharecode: json['sharecode'] as String?,
      tuijiancode: json['tuijiancode'],
      parentid: json['parentid'] as int?,
      birthdayyear: json['birthdayyear'] == null
          ? null
          : DateTime.parse(json['birthdayyear'] as String),
      birthdaymonth: json['birthdaymonth'],
      sex: json['sex'] as String?,
      sort: json['sort'] as int?,
      type: json['type'] as int?,
      channel: json['channel'],
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      youbian: json['youbian'] as String?,
      remark: json['remark'] as String?,
      allstudydate: json['allstudydate'] as int?,
      allstudytime: json['allstudytime'] as int?,
      creathydate: json['creathydate'] == null
          ? null
          : DateTime.parse(json['creathydate'] as String),
      endhydate: json['endhydate'] == null
          ? null
          : DateTime.parse(json['endhydate'] as String),
      examdate: json['examdate'] == null
          ? null
          : DateTime.parse(json['examdate'] as String),
      kaoshidate: json['kaoshidate'] == null
          ? null
          : DateTime.parse(json['kaoshidate'] as String),
      laststudyworddate: json['laststudyworddate'] == null
          ? null
          : DateTime.parse(json['laststudyworddate'] as String),
      studydate: json['studydate'],
      isbuquan: json['isbuquan'] as int?,
      isnewuser: json['isnewuser'] as int?,
      progresstype: json['progresstype'] as int?,
      avgzhongwen: (json['avgzhongwen'] as num?)?.toDouble(),
      avgenglish: (json['avgenglish'] as num?)?.toDouble(),
      progresscourseid: json['progresscourseid'] as int?,
      progresschapterid: json['progresschapterid'] as int?,
      stepflag: json['stepflag'] as int?,
      isdel: json['isdel'] as int?,
      payelsecount: json['payelsecount'] as int?,
      aiycwctime: json['aiycwctime'] as String?,
      aiyctgtime: json['aiyctgtime'] as String?,
      rotedegree: json['rotedegree'] as String?,
      degreecontent: json['degreecontent'] as String?,
      vipstatus: json['vipstatus'] as int?,
      vipchangedate: json['vipchangedate'] == null
          ? null
          : DateTime.parse(json['vipchangedate'] as String),
      ismorereq: json['ismorereq'] as int?,
      status: json['status'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      yibeiMemberCategory: json['yibei_member_category'] == null
          ? null
          : YibeiMemberCategory.fromJson(
              json['yibei_member_category'] as Map<String, dynamic>),
      payElseCount: json['payElseCount'] as int?,
      hasStudyCourseFv: (json['hasStudyCourseFv'] as num?)?.toDouble(),
      hasStudyFv: (json['hasStudyFv'] as num?)?.toDouble(),
      logincount: json['logincount'] as int?,
      isVip: json['isVip'] as bool?,
      chascount: json['chascount'] as int?,
      allcount: json['allcount'] as int?,
      xfpaycount: json['xfpaycount'] as int?,
      studytimeavg: (json['studytimeavg'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'avatar': instance.avatar,
      'oldid': instance.oldid,
      'unionid_wx': instance.unionidWx,
      'openid_wx': instance.openidWx,
      'openid_gg': instance.openidGg,
      'category': instance.category,
      'level': instance.level,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'nickname': instance.nickname,
      'account': instance.account,
      'sharecode': instance.sharecode,
      'tuijiancode': instance.tuijiancode,
      'parentid': instance.parentid,
      'birthdayyear': instance.birthdayyear?.toIso8601String(),
      'birthdaymonth': instance.birthdaymonth,
      'sex': instance.sex,
      'sort': instance.sort,
      'type': instance.type,
      'channel': instance.channel,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'youbian': instance.youbian,
      'remark': instance.remark,
      'allstudydate': instance.allstudydate,
      'allstudytime': instance.allstudytime,
      'creathydate': instance.creathydate?.toIso8601String(),
      'endhydate': instance.endhydate?.toIso8601String(),
      'examdate': instance.examdate?.toIso8601String(),
      'kaoshidate': instance.kaoshidate?.toIso8601String(),
      'laststudyworddate': instance.laststudyworddate?.toIso8601String(),
      'studydate': instance.studydate,
      'isbuquan': instance.isbuquan,
      'isnewuser': instance.isnewuser,
      'progresstype': instance.progresstype,
      'avgzhongwen': instance.avgzhongwen,
      'avgenglish': instance.avgenglish,
      'progresscourseid': instance.progresscourseid,
      'progresschapterid': instance.progresschapterid,
      'stepflag': instance.stepflag,
      'isdel': instance.isdel,
      'payelsecount': instance.payelsecount,
      'aiycwctime': instance.aiycwctime,
      'aiyctgtime': instance.aiyctgtime,
      'rotedegree': instance.rotedegree,
      'degreecontent': instance.degreecontent,
      'vipstatus': instance.vipstatus,
      'vipchangedate': instance.vipchangedate?.toIso8601String(),
      'ismorereq': instance.ismorereq,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'yibei_member_category': instance.yibeiMemberCategory,
      'payElseCount': instance.payElseCount,
      'hasStudyCourseFv': instance.hasStudyCourseFv,
      'hasStudyFv': instance.hasStudyFv,
      'logincount': instance.logincount,
      'isVip': instance.isVip,
      'chascount': instance.chascount,
      'allcount': instance.allcount,
      'xfpaycount': instance.xfpaycount,
      'studytimeavg': instance.studytimeavg,
    };
