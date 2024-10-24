import 'package:flutter/material.dart';
import 'package:yibei_app/pages/main/main_page.dart';
import 'package:yibei_app/pages/common/login_page.dart';
import 'package:yibei_app/pages/common/register_page.dart';
import 'package:yibei_app/pages/common/retrieve_password_page.dart';
import 'package:yibei_app/pages/common/introduce_page.dart';
import 'package:yibei_app/pages/home/study_data_page.dart';
import 'package:yibei_app/pages/home/study_analysis_page.dart';
import 'package:yibei_app/pages/course/chapter_list_page.dart';
import 'package:yibei_app/pages/course/study_step_list_page.dart';
import 'package:yibei_app/pages/course/free_study_step_list_page.dart';
import 'package:yibei_app/pages/course/study_final_step_list_page.dart';
import 'package:yibei_app/pages/course/study_video_page.dart';
import 'package:yibei_app/pages/course/study_word_ch_en_page.dart';
import 'package:yibei_app/pages/course/study_word_test_ch_en_page.dart';
import 'package:yibei_app/pages/course/study_word_en_page.dart';
import 'package:yibei_app/pages/course/study_word_test_en_page.dart';
import 'package:yibei_app/pages/course/study_word_final_test_page.dart';
import 'package:yibei_app/pages/course/study_test_page.dart';
import 'package:yibei_app/pages/course/study_test_result_page.dart';
import 'package:yibei_app/pages/course/study_compound_word_test_page.dart';
import 'package:yibei_app/pages/course/study_compound_test_page.dart';
import 'package:yibei_app/pages/course/study_compound_test_result_page.dart';
import 'package:yibei_app/pages/course/study_report_page.dart';
import 'package:yibei_app/pages/resource/resource_video_page.dart';
import 'package:yibei_app/pages/resource/resource_content_page.dart';
import 'package:yibei_app/pages/mine/personal_data/personal_data_page.dart';
import 'package:yibei_app/pages/mine/personal_data/personal_data_edit_page.dart';
import 'package:yibei_app/pages/mine/my_buy/my_buy_page.dart';
import 'package:yibei_app/pages/mine/recommend_friend/recommend_friend_page.dart';
import 'package:yibei_app/pages/mine/account_setting/account_setting_page.dart';
import 'package:yibei_app/pages/mine/account_setting/account_setting_email_page.dart';
import 'package:yibei_app/pages/mine/account_setting/account_setting_phone_page.dart';
import 'package:yibei_app/pages/mine/account_setting/account_setting_password_page.dart';
import 'package:yibei_app/pages/mine/about_us_page/about_us_page.dart';
import 'package:yibei_app/pages/mine/about_us_page/contact_us_page.dart';
import 'package:yibei_app/pages/common/index_course_list_page.dart';
import 'package:yibei_app/pages/common/index_resource_page.dart';
import 'package:yibei_app/pages/common/tourist_login_page.dart';
import 'package:yibei_app/pages/bbs/bbs_details_page.dart';
import 'package:yibei_app/pages/bbs/bbs_author_details_page.dart';
import 'package:yibei_app/pages/bbs/bbs_edit_page.dart';

import '../pages/course/study_word_test_result_page.dart';

/// 路由文件
class AppRoutes {
  // 公共
  static const String main = '/'; // 主页
  static const String login = '/login'; // 登录页
  static const String register = '/register'; // 注册页
  static const String introduce = '/introduce'; // app介绍页面
  static const String touristLogin = '/touristLogin'; // 游客登录
  static const String retrievePassword = '/retrievePassword'; // 打回密码

  static const String indexResource = '/indexResource'; // 主页 - 资源列表
  static const String indexCourseList = '/indexCourseList'; // 主页 - 课程列表

  // 主页
  static const String homeStudyData = '/home/studyData'; // 学习数据页面
  static const String studyAnalysis = '/home/studyAnalysis'; // 学习分析页面
  static const String freeStudyStepList =
      '/home/freeStudyStepListPage'; // 免费的学习页面

  // 课程
  static const String courseChapterList = '/course/chapterListPage'; // 章节页
  static const String studyStepList = '/course/studyStepListPage'; // 步骤页
  static const String studyFinalStepList =
      '/course/studyStepFinalListPage'; // final的步骤页
  static const String studyVideo = '/course/studyVideoPage'; // 视频学习页
  static const String studyWordChEn = '/course/studyWordChEnPage'; // 关键词学习（中英）
  static const String studyWordTestChEn =
      '/course/studyWordTestChEnPage'; // 关键词测试（中英）
  static const String studyWordEn = '/course/studyWordEnPage'; // 关键词学习（英）
  static const String studyWordTestEn =
      '/course/studyWordTestEnPage'; // 关键词测试（英）
  static const String studyWordFinalTest =
      '/course/studyWordFinalTestPage'; // final关键词测试
  static const String studyTest = '/course/studyFinalTest'; // 章节单元测试
  static const String studyTestResult = '/course/studyTestResult'; // 章节单元测试-结果页
  static const String studyCompoundWordTestPage =
      '/course/studyCompoundWordTestPage'; // 综合测试、应变测试-关键词测试
  static const String studyCompoundTestPage =
      '/course/studyCompoundTestPage'; // 综合测试、应变测试-题目测试
  static const String studyCompoundTestResultPage =
      '/course/studyCompoundTestResultPage'; // 综合测试、应变测试-结果页
  static const String studyWordTestResult =
      '/course/StudyWordTestResultPage'; // 单词测试-结果页
  static const String studyReport = '/course/studyReportPage'; // 学习报告

  // 资源页
  static const String resourceVideoPage = '/resourc/resourceVideoPage'; // 视频播放
  static const String resourceContentPage =
      '/resourc/resourceContentPage'; // 文章页

  // 论坛
  static const String bbsDetailsPage = '/bbs/bbsDetailsPage'; // 论坛-帖子详情
  static const String bbsAuthorDetailsPage =
      '/bbs/bbsAuthorDetailsPage'; // 论坛-作者详情
  static const String bbsEditPage = '/bbs/bbsEditPage'; // 论坛-发布

// 个人中心
  static const String minePersonalData =
      '/mine/personalData/personalData'; // 个人资料
  static const String minePersonalDataEdit =
      '/mine/personalData/personalDataEdit'; // 个人资料-编辑
  static const String mineMyBuyPage = '/mine/myBuy/myBuyPage'; // 我的购买
  static const String mineRecommendFriendPage =
      '/mine/recommendFriend/recommendFriendPage'; // 推荐朋友
  static const String mineAccountSettingPage =
      '/mine/acountSetting/acountSettingPage'; // 帐号设置
  static const String mineAccountSettingEmailPage =
      '/mine/acountSetting/accountSettingEmailPage'; // 帐号设置-邮件
  static const String mineAccountSettingPhonePage =
      '/mine/acountSetting/accountSettingPhonePage'; // 帐号设置-手机
  static const String mineAccountSettingPasswordPage =
      '/mine/acountSetting/accountSettingPasswordPage'; // 帐号设置-密码
  static const String mineAboutUs = '/mineAboutUsPage'; // 关于易北
  static const String mineContactUs = '/mineContactUsPage'; // 联系我们

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      main: (context) => MainPage(),
      login: (context) => LoginPage(),
      register: (context) => RegisterPage(),
      indexCourseList: (context) => IndexCourseListPage(),
      touristLogin: (context) => TouristLoginPage(),
      retrievePassword: (context) => RetrievePasswordPage(),
      indexResource: (context) => IndexResourcePage(),
      introduce: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        bool showBack = args['showBack'];
        return IntroducePage(showBack: showBack);
      },
      homeStudyData: (context) => StudyDataPage(),
      studyAnalysis: (context) => StudyAnalysisPage(),
      courseChapterList: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int courseId = args['courseId'];
        return ChapterListPage(courseId);
      },
      freeStudyStepList: (context) => FreeStudyStepListPage(),
      studyStepList: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int courseId = args['courseId'];
        int chapterId = args['chapterId'];
        String chapterName = args['chapterName'];
        int chapterProgress = args['chapterProgress'];
        String studyStep = args['studyStep'];
        return StudyStepListPage(
          courseId,
          chapterId,
          chapterName,
          chapterProgress,
          studyStep,
        );
      },
      studyFinalStepList: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int courseId = args['courseId'];
        int chapterId = args['chapterId'];
        String chapterName = args['chapterName'];
        int chapterProgress = args['chapterProgress'];
        int? type = args['type'];

        return StudyFinalStepListPage(
          courseId,
          chapterId,
          chapterName,
          chapterProgress,
          type,
        );
      },
      studyVideo: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int courseId = args['courseId'];
        int chapterId = args['chapterId'];
        int? isReviewWordTest = args['isReviewWordTest'];
        int? isReview = args['isReview'];
        int? courseType = args['courseType'];
        return StudyVideoPage(
          courseId,
          chapterId,
          isReviewWordTest,
          isReview,
          courseType,
        );
      },
      studyWordChEn: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int courseId = args['courseId'];
        int chapterId = args['chapterId'];
        int? isReviewWordTest = args['isReviewWordTest'];
        int? isReview = args['isReview'];
        int? courseType = args['courseType'];
        return StudyWordChEnPage(
          courseId,
          chapterId,
          isReviewWordTest,
          isReview,
          courseType,
        );
      },
      studyWordTestChEn: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int courseId = args['courseId'];
        int chapterId = args['chapterId'];
        int? isReviewWordTest = args['isReviewWordTest'];
        int? isReview = args['isReview'];
        int? courseType = args['courseType'];
        return StudyWordTestChEnPage(
          courseId,
          chapterId,
          isReviewWordTest,
          isReview,
          courseType,
        );
      },
      studyWordEn: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int courseId = args['courseId'];
        int chapterId = args['chapterId'];
        int? isReviewWordTest = args['isReviewWordTest'];
        int? isReview = args['isReview'];
        int? courseType = args['courseType'];
        return StudyWordEnPage(
          courseId,
          chapterId,
          isReviewWordTest,
          isReview,
          courseType,
        );
      },
      studyWordTestEn: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int courseId = args['courseId'];
        int chapterId = args['chapterId'];
        int? isReviewWordTest = args['isReviewWordTest'];
        int? isReview = args['isReview'];
        int? courseType = args['courseType'];
        return StudyWordTestEnPage(
          courseId,
          chapterId,
          isReviewWordTest,
          isReview,
          courseType,
        );
      },
      studyWordFinalTest: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int courseId = args['courseId'];
        int chapterId = args['chapterId'];
        int? courseType = args['courseType'];
        return StudyWordFinalTestPage(
          courseId: courseId,
          chapterId: chapterId,
          courseType: courseType,
        );
      },
      studyTest: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int courseId = args['courseId'];
        int chapterId = args['chapterId'];
        int? isReviewWordTest = args['isReviewWordTest'];
        int? isReview = args['isReview'];
        int? courseType = args['courseType'];
        return StudyTestPage(
            courseId, chapterId, isReviewWordTest, isReview, courseType);
      },
      studyTestResult: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int? courseId = args['courseId'];
        int? chapterId = args['chapterId'];
        int? requestPaperId = args['requestPaperId'];
        int? leftTestCount = args['leftTestCount'];
        int? rank = args['rank'];
        bool? isThreeErrorCount = args['isThreeErrorCount'];
        int? progressStatus = args['progressStatus'];
        int? isFinal = args['isFinal'];
        double? passScore = args['passScore'];
        int? testRequestId = args['testRequestId'];
        int? isReview = args['isReview'];
        int? isReviewWordTest = args['isReviewWordTest'];
        int? nextCourseId = args['nextCourseId'];
        int? nextChapterId = args['nextChapterId'];
        int? isIndex = args['isIndex'];

        return StudyTestResultPage(
          courseId: courseId,
          chapterId: chapterId,
          requestPaperId: requestPaperId,
          leftTestCount: leftTestCount,
          rank: rank,
          isThreeErrorCount: isThreeErrorCount,
          progressStatus: progressStatus,
          isFinal: isFinal,
          testRequestId: testRequestId,
          passScore: passScore,
          isReview: isReview,
          isReviewWordTest: isReviewWordTest,
          nextCourseId: nextCourseId,
          nextChapterId: nextChapterId,
          isIndex: isIndex,
        );
      },
      studyCompoundWordTestPage: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int type = args['type'];
        return StudyCompoundWordTestPage(type);
      },
      studyCompoundTestPage: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int type = args['type'];
        return StudyCompoundTestPage(type);
      },
      studyCompoundTestResultPage: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int type = args['type'];
        int testRequestId = args['testRequestId'];
        int? isIndex = args['isIndex'];

        return StudyCompoundTestResultPage(
          type: type,
          testRequestId: testRequestId,
          isIndex: isIndex,
        );
      },
      studyWordTestResult: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int type = args['type'];
        int status = args['status'];
        DateTime startDate = args['startDate'];
        DateTime endDate = args['endDate'];
        String orderCode = args['orderCode'];
        int allRequestCount = args['allRequestCount'];
        int correctCount = args['correctCount'];
        int score = args['score'];

        return StudyWordTestResultPage(
          type: type,
          status: status,
          startDate: startDate,
          endDate: endDate,
          orderCode: orderCode,
          allRequestCount: allRequestCount,
          correctCount: correctCount,
          score: score,
        );
      },
      studyReport: (context) => StudyReportPage(),
      resourceVideoPage: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int courseId = args['courseId'];
        int chapterId = args['chapterId'];
        return ResourceVideoPage(
          courseId,
          chapterId,
        );
      },
      resourceContentPage: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int courseId = args['courseId'];
        int chapterId = args['chapterId'];
        return ResourceContentPage(
          courseId,
          chapterId,
        );
      },
      bbsDetailsPage: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int artId = args['artId'];
        return BbsDetailsPage(
          artId,
        );
      },
      bbsAuthorDetailsPage: (context) {
        Map<String, dynamic> args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        int authorId = args['authorId'];
        return BbsAuthorDetailsPage(
          authorId,
        );
      },
      bbsEditPage: (context) => BbsEditPage(),
      minePersonalData: (context) => PersonalDataPage(),
      minePersonalDataEdit: (context) => PersonalDataEditPage(),
      mineMyBuyPage: (context) => MyBuyPage(),
      mineRecommendFriendPage: (context) => RecommendFriendPage(),
      mineAccountSettingPage: (context) => AccountSettingPage(),
      mineAccountSettingEmailPage: (context) => AccountSettingEmailPage(),
      mineAccountSettingPhonePage: (context) => AccountSettingPhonePage(),
      mineAccountSettingPasswordPage: (context) => AccountSettingPasswordPage(),
      mineAboutUs: (context) => AboutUsPage(),
      mineContactUs: (context) => ContactUsPage(),
    };
  }
}
