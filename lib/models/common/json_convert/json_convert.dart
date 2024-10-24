import 'package:yibei_app/models/common/common_return_states/common_return_states.dart';
import 'package:yibei_app/models/common/validate_image_code/validate_image_code.dart';
import 'package:yibei_app/models/common/user_login/user_login.dart';
import 'package:yibei_app/models/common/upload_file/upload_file.dart';
import 'package:yibei_app/models/common/coordinates/coordinates.dart';
import 'package:yibei_app/models/common/version_update/version_update.dart';

import 'package:yibei_app/models/user/login_user_info/login_user_info.dart';
import 'package:yibei_app/models/user/week_study_statics/week_study_statics.dart';
import 'package:yibei_app/models/user/user_radar_statics/user_radar_statics.dart';
import 'package:yibei_app/models/user/member_test_detail_log/member_test_detail_log.dart';
import 'package:yibei_app/models/user/my_floow_member/my_floow_member.dart';
import 'package:yibei_app/models/user/my_buy_order_data/my_buy_order_data.dart';

import 'package:yibei_app/models/course/course_chapter_tree/course_chapter_tree.dart';
import 'package:yibei_app/models/course/user_progress/user_progress.dart';
import 'package:yibei_app/models/course/course_chapter_data/course_chapter_data.dart';
import 'package:yibei_app/models/course/current_chapter_progress/current_chapter_progress.dart';
import 'package:yibei_app/models/course/study_const/study_const.dart';
import 'package:yibei_app/models/course/course_chapter_word_list/course_chapter_word_list.dart';
import 'package:yibei_app/models/course/word_audio/word_audio.dart';
import 'package:yibei_app/models/course/course_chapter_word_test_result/course_chapter_word_test_result.dart';
import 'package:yibei_app/models/course/course_request_info/course_request_info.dart';
import 'package:yibei_app/models/course/course_test_count/course_test_count.dart';
import 'package:yibei_app/models/course/course_test_list/course_test_list.dart';
import 'package:yibei_app/models/course/course_final_test_pass/course_final_test_pass.dart';
import 'package:yibei_app/models/course/course_submit_test/course_submit_test.dart';
import 'package:yibei_app/models/course/chapter_test_result/chapter_test_result.dart';
import 'package:yibei_app/models/course/course_chapter_set_next/course_chapter_set_next.dart';
import 'package:yibei_app/models/course/chapter_test_request_list/chapter_test_request_list.dart';
import 'package:yibei_app/models/course/word_test_question_answer/word_test_question_answer.dart';
import 'package:yibei_app/models/course/submit_test_before_word/submit_test_before_word.dart';
import 'package:yibei_app/models/course/my_error_questtest/my_error_questtest.dart';
import 'package:yibei_app/models/course/course_compound_submit/course_compound_submit.dart';
import 'package:yibei_app/models/course/compound_test_request_list/compound_test_request_list.dart';
import 'package:yibei_app/models/course/compound_test_result_data/compound_test_result_data.dart';
import 'package:yibei_app/models/course/course_chapter_list_data/course_chapter_list_data.dart';
import 'package:yibei_app/models/course/member_study_logs/member_study_logs.dart';
import 'package:yibei_app/models/course/study_word_test_result/study_word_test_result.dart';

import 'package:yibei_app/models/user/user_last_login_study/user_last_login_study.dart';
import 'package:yibei_app/models/user/user_chapter_study_log/user_chapter_study_log.dart';

import 'package:yibei_app/models/order/create_order/create_order.dart';
import 'package:yibei_app/models/order/pay_callback/pay_callback.dart';

import 'package:yibei_app/models/content/content_list/content_list.dart';
import 'package:yibei_app/models/content/content_details/content_details.dart';

import 'package:yibei_app/models/bbs/bbs_list/bbs_list.dart';
import 'package:yibei_app/models/bbs/author_statistics_info/author_statistics_info.dart';
import 'package:yibei_app/models/bbs/post_details/post_details.dart';

typedef JsonConvertFunction<T> = T Function(Map<String, dynamic> json);

class JsonConvert {
  // 类型映射
  static final Map<String, JsonConvertFunction> _convertFuncMap = {
    (CommonReturnStates).toString(): CommonReturnStates.fromJson,
    (ValidateImageCode).toString(): ValidateImageCode.fromJson,
    (UserLogin).toString(): UserLogin.fromJson,
    (WeekStudyStatics).toString(): WeekStudyStatics.fromJson,
    (LoginUserInfo).toString(): LoginUserInfo.fromJson,
    (CourseChapterTree).toString(): CourseChapterTree.fromJson,
    (UserProgress).toString(): UserProgress.fromJson,
    (UserRadarStatics).toString(): UserRadarStatics.fromJson,
    (CourseChapterData).toString(): CourseChapterData.fromJson,
    (CurrentChapterProgress).toString(): CurrentChapterProgress.fromJson,
    (StudyConst).toString(): StudyConst.fromJson,
    (CourseChapterWordList).toString(): CourseChapterWordList.fromJson,
    (WordAudio).toString(): WordAudio.fromJson,
    (CourseChapterWordTestResult).toString():
        CourseChapterWordTestResult.fromJson,
    (CourseRequestInfo).toString(): CourseRequestInfo.fromJson,
    (CourseTestCount).toString(): CourseTestCount.fromJson,
    (CourseTestList).toString(): CourseTestList.fromJson,
    (CourseFinalTestPass).toString(): CourseFinalTestPass.fromJson,
    (CourseSubmitTest).toString(): CourseSubmitTest.fromJson,
    (ChapterTestResult).toString(): ChapterTestResult.fromJson,
    (CourseChapterSetNext).toString(): CourseChapterSetNext.fromJson,
    (ChapterTestRequestList).toString(): ChapterTestRequestList.fromJson,
    (WordTestQuestionAnswer).toString(): WordTestQuestionAnswer.fromJson,
    (SubmitTestBeforeWord).toString(): SubmitTestBeforeWord.fromJson,
    (MemberTestDetailLog).toString(): MemberTestDetailLog.fromJson,
    (MyErrorQuesttest).toString(): MyErrorQuesttest.fromJson,
    (CourseCompoundSubmit).toString(): CourseCompoundSubmit.fromJson,
    (CompoundTestResultData).toString(): CompoundTestResultData.fromJson,
    (CompoundTestRequestList).toString(): CompoundTestRequestList.fromJson,
    (ContentDetails).toString(): ContentDetails.fromJson,
    (ContentList).toString(): ContentList.fromJson,
    (CourseChapterListData).toString(): CourseChapterListData.fromJson,
    (MyBuyOrderData).toString(): MyBuyOrderData.fromJson,
    (MyFloowMember).toString(): MyFloowMember.fromJson,
    (UserLastLoginStudy).toString(): UserLastLoginStudy.fromJson,
    (CreateOrder).toString(): CreateOrder.fromJson,
    (PayCallback).toString(): PayCallback.fromJson,
    (UserChapterStudyLog).toString(): UserChapterStudyLog.fromJson,
    (UploadFile).toString(): UploadFile.fromJson,
    (Coordinates).toString(): Coordinates.fromJson,
    (BbsList).toString(): BbsList.fromJson,
    (AuthorStatisticsInfo).toString(): AuthorStatisticsInfo.fromJson,
    (PostDetails).toString(): PostDetails.fromJson,
    (VersionUpdate).toString(): VersionUpdate.fromJson,
    (MemberStudyLogs).toString(): MemberStudyLogs.fromJson,
    (StudyWordTestResult).toString(): StudyWordTestResult.fromJson,
  };

  // 通过类型找到fromJson函数
  static T? asT<T>(dynamic json) {
    final String type = T.toString();
    try {
      return _convertFuncMap[type]!(json) as T;
    } catch (e) {
      print('/models/json_convert/报错了，类型映射未添加');
      print(e);
      return null;
    }
  }

  //
  static T? fromJsonAsT<T>(dynamic json) {
    return asT<T>(json);
  }
}
