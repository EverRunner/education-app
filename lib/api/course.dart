import 'dart:convert';
import 'package:yibei_app/utils/http/http.dart';
import 'package:dio/dio.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/common/common_return_states/common_return_states.dart';
import 'package:yibei_app/models/course/course_chapter_tree/course_chapter_tree.dart';
import 'package:yibei_app/models/course/user_progress/user_progress.dart';
import 'package:yibei_app/models/course/current_chapter_progress/current_chapter_progress.dart';
import 'package:yibei_app/models/course/course_chapter_data/course_chapter_data.dart';
import 'package:yibei_app/models/course/course_chapter_word_list/course_chapter_word_list.dart';
import 'package:yibei_app/models/course/word_audio/word_audio.dart';
import 'package:yibei_app/models/course/course_chapter_word_test_result/course_chapter_word_test_result.dart';
import 'package:yibei_app/models/course/course_request_info/course_request_info.dart';
import 'package:yibei_app/models/course/course_test_count/course_test_count.dart';
import 'package:yibei_app/models/course/course_test_list/course_test_list.dart';
import 'package:yibei_app/models/course/my_error_questtest/my_error_questtest.dart';
import 'package:yibei_app/models/course/course_compound_submit/course_compound_submit.dart';
import 'package:yibei_app/models/course/compound_test_request_list/compound_test_request_list.dart';
import 'package:yibei_app/models/course/compound_test_result_data/compound_test_result_data.dart';
import 'package:yibei_app/models/course/course_chapter_list_data/course_chapter_list_data.dart';
import 'package:yibei_app/models/course/member_study_logs/member_study_logs.dart';
import 'package:yibei_app/models/course/study_word_test_result/study_word_test_result.dart';

import 'package:yibei_app/models/course/submit_request_list/submit_request_list.dart';
import 'package:yibei_app/models/course/course_submit_test/course_submit_test.dart';
import 'package:yibei_app/models/course/chapter_test_result/chapter_test_result.dart';
import 'package:yibei_app/models/course/course_chapter_set_next/course_chapter_set_next.dart';
import 'package:yibei_app/models/course/chapter_test_request_list/chapter_test_request_list.dart';
import 'package:yibei_app/models/course/word_test_question_answer/word_test_question_answer.dart';
import 'package:yibei_app/models/course/submit_test_before_word/submit_test_before_word.dart';

const String course = '/course';
const String user = '/user';

/// 获取课程列表（免费、付费）
Future<BaseEntity<CourseChapterTree>> getCourseChapterTree({
  bool showLoading = true,
}) async {
  dynamic entity = await HttpUtil.get<CourseChapterTree>(
    '$course/getcoursechaptertree',
    options: Options(
      extra: {
        'showLoading': showLoading,
      },
    ),
  );
  return Future.value(entity);
}

/// 获取课程的章节列表
/// [courseId] 课程id
/// [showLoading] 是否显示加载器
Future<BaseEntity<CourseChapterListData>> getCourseChapterList({
  required int courseId,
  bool showLoading = false,
}) async {
  Map<String, dynamic> map = Map();
  map['courseid'] = courseId;

  dynamic entity = await HttpUtil.get<CourseChapterListData>(
    '$course/getcoursechapterlist',
    params: map,
    options: Options(
      extra: {
        'showLoading': showLoading,
      },
    ),
  );
  return Future.value(entity);
}

/// 获取用户学习进度
/// [type] 进度类型（0：试听进度，1：付费进度）
/// [showLoading] 是否显示加载器
Future<BaseEntity<UserProgress>> getUserProgress(
  int type, {
  bool showLoading = false,
}) async {
  Map<String, dynamic> map = Map();
  map['type'] = type;

  dynamic entity = await HttpUtil.get<UserProgress>(
    '$course/getuserprogress',
    params: map,
    options: Options(
      extra: {
        'showLoading': showLoading,
      },
    ),
  );
  return Future.value(entity);
}

/// 创建学习进度（付费的）
Future<BaseEntity<CommonReturnStates>> creatorUserProgress({
  bool showLoading = false,
}) async {
  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$course/creatcoursestart',
    options: Options(
      extra: {
        'showLoading': showLoading,
      },
    ),
  );
  return Future.value(entity);
}

/// 创建学习进度（免费）
Future<BaseEntity<CommonReturnStates>> creatorUserProgressFree() async {
  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$course/creatcoursetrystart',
  );
  return Future.value(entity);
}

/// 获取章节的学习进度
/// [progressId] 学习进度id
/// [courseId] 课程id
/// [chapterId] 章节id
Future<BaseEntity<CurrentChapterProgress>> getCurrentChapterProgress({
  required int progressId,
  required int courseId,
  required int chapterId,
}) async {
  Map<String, dynamic> map = Map();
  map['progressid'] = progressId;
  map['courseid'] = courseId;
  map['chapterid'] = chapterId;

  dynamic entity = await HttpUtil.get<CurrentChapterProgress>(
    '$course/getcurrentchapterprogress',
    params: map,
  );
  return Future.value(entity);
}

/// 获取通过章节详情
/// [chapterId] 章节id
Future<BaseEntity<CourseChapterData>> getCourseChapterDataById({
  required int chapterId,
}) async {
  Map<String, dynamic> map = Map();
  map['id'] = chapterId;

  dynamic entity = await HttpUtil.get<CourseChapterData>(
    '$course/getcoursechapterdatabyid',
    params: map,
  );
  return Future.value(entity);
}

/// 开始学习某个课程
/// [progressId] 学习进度id
/// [courseId] 课程id
Future<BaseEntity<CommonReturnStates>> startStudyCourse({
  required int progressId,
  required int courseId,
}) async {
  Map<String, dynamic> map = Map();
  map['progressid'] = progressId;
  map['courseid'] = courseId;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$course/startstudycourse',
    data: map,
  );
  return Future.value(entity);
}

/// 修改课程进度状态和信息
/// [progressId] 学习进度id
/// [courseId] 课程id
/// [chapterId] 章节id
/// [status] 状态 -1:未开始 0：进行中 1：已完成
Future<BaseEntity<CommonReturnStates>> updateProgressCourseStatus({
  required int progressId,
  required int courseId,
  required int chapterId,
  required int status,
}) async {
  Map<String, dynamic> map = Map();
  map['progressid'] = progressId;
  map['courseid'] = courseId;
  map['currentcoursechapterid'] = chapterId;
  map['status'] = status;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$course/updateprogresscoursestatus',
    data: map,
  );
  return Future.value(entity);
}

/// 更新学习的步骤
/// [progressId] 学习进度id
/// [courseId] 课程id
/// [chapterId] 章节id
/// [status] 步骤 -1:未开始  0：观看视频中  1：单词中英  2：单词英  3：单元测试中  4：完成  5：单词中英（测试） 6：单词英（测试）
Future<BaseEntity<CommonReturnStates>> updateProgressCourseChapterStep({
  required int progressId,
  required int courseId,
  required int chapterId,
  required int status,
}) async {
  Map<String, dynamic> map = Map();
  map['progressid'] = progressId;
  map['courseid'] = courseId;
  map['chapterid'] = chapterId;
  map['status'] = status;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$course/updateprogresscoursechapterstatus',
    data: map,
  );
  return Future.value(entity);
}

/// 获取章节的单词列表
/// [paperId] 单词列表id
Future<BaseEntity<CourseChapterWordList>> getCourseChapterWordList({
  required int paperId,
}) async {
  Map<String, dynamic> map = Map();
  map['paperid'] = paperId;

  dynamic entity = await HttpUtil.get<CourseChapterWordList>(
    '$course/getnewdcwordpaperconstlist',
    params: map,
  );
  return Future.value(entity);
}

/// 获取单词音频的路径
/// [text] 单词
Future<BaseEntity<WordAudio>> getWordAudio({
  required String text,
}) async {
  Map<String, dynamic> map = Map();
  map['text'] = text;

  dynamic entity = await HttpUtil.get<WordAudio>(
    '$course/transvoicespeed',
    params: map,
    options: Options(
      extra: {
        'showLoading': false,
      },
    ),
  );
  return Future.value(entity);
}

/// 提交关键词测试
/// [progressId] 学习进度id
/// [courseId] 课程id
/// [chapterId] 章节id
/// [category] 0：中英 1：英
/// [useTime] 答题时间，单位秒
/// [correctCount] 正确题数
/// [errorCount] 错误题数
/// [allWordCount] 总题数
/// [rightLv] 正确率
/// [startDate] 测试开始时间
/// [endTime] 测试结束时间
Future<BaseEntity<CourseChapterWordTestResult>> submitWordsTest({
  required int progressId,
  required int courseId,
  required int chapterId,
  required int category,
  required int useTime,
  required int correctCount,
  required int errorCount,
  required int allWordCount,
  required double rightLv,
  required DateTime startDate,
  required DateTime endTime,
}) async {
  Map<String, dynamic> map = Map();
  map['progressid'] = progressId;
  map['courseid'] = courseId;
  map['chapterid'] = chapterId;
  map['category'] = category;
  map['usetime'] = useTime;
  map['correctcount'] = correctCount;
  map['errorcount'] = errorCount;
  map['alldcwordscount'] = allWordCount;
  map['rightlv'] = rightLv;
  map['startdate'] = startDate.toString();
  map['enddate'] = endTime.toString();

  dynamic entity = await HttpUtil.post<CourseChapterWordTestResult>(
    '$course/subwordstestres',
    data: map,
  );
  return Future.value(entity);
}

/// 获取测试题列表
/// [paperId] 测试题id
Future<BaseEntity<CourseTestList>> getCourseTestList({
  required int requestPaperId,
}) async {
  Map<String, dynamic> map = Map();
  map['requestpaperid'] = requestPaperId;

  dynamic entity = await HttpUtil.get<CourseTestList>(
    '$course/getcoursetestlist',
    params: map,
  );
  return Future.value(entity);
}

/// 获取测试信息
/// [paperId] 测试题id
Future<BaseEntity<CourseRequestInfo>> getCourseTestInfo({
  required int paperId,
}) async {
  Map<String, dynamic> map = Map();
  map['paperid'] = paperId;

  dynamic entity = await HttpUtil.get<CourseRequestInfo>(
    '$course/getrequestpaper',
    params: map,
  );
  return Future.value(entity);
}

/// 获取章节的机会次数
/// [progressId] 学习进度id
/// [courseId] 课程id
/// [chapterId] 章节id
Future<BaseEntity<CourseTestCount>> getCourseTestCount({
  required int progressId,
  required int courseId,
  required int chapterId,
}) async {
  Map<String, dynamic> map = Map();
  map['progressid'] = progressId;
  map['courseid'] = courseId;
  map['chapterid'] = chapterId;

  dynamic entity = await HttpUtil.get<CourseTestCount>(
    '$course/getsubmitcount',
    params: map,
  );
  return Future.value(entity);
}

/// 移除三次flnal不过记录
/// [courseId] 课程id
/// [chapterId] 章节id
Future<BaseEntity<CommonReturnStates>> removeFinalError({
  required int courseId,
  required int chapterId,
}) async {
  Map<String, dynamic> map = Map();
  map['courseid'] = courseId;
  map['chapterid'] = chapterId;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$course/refundthreefinalerror',
    data: map,
  );
  return Future.value(entity);
}

/// 重置本章所有学习-三次final不过写记录
/// [courseId] 课程id
/// [chapterId] 章节id
Future<BaseEntity<CommonReturnStates>> setCourseChapterStudy({
  required int courseId,
  required int chapterId,
}) async {
  Map<String, dynamic> map = Map();
  map['courseid'] = courseId;
  map['chapterid'] = chapterId;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$course/createthreefinalerror',
    data: map,
  );
  return Future.value(entity);
}

/// 提交单元测试
/// [progressId] 学习进度id
/// [courseId] 课程id
/// [chapterId] 章节id
/// [requestPaperId] 测试id
/// [correctCount] 正确题数
/// [errorCount] 错误题数
/// [score] 得分
/// [startDate] 测试开始时间
/// [endTime] 测试结束时间
/// [status] 通过状态 1：测试通过 2：测试不通过
/// [isFinal] 是否为isFinal
/// [requestList] 测试结束时间
Future<BaseEntity<CourseSubmitTest>> courseSubmitTest({
  required int progressId,
  required int courseId,
  required int chapterId,
  required int requestPaperId,
  required int correctCount,
  required int errorCount,
  required double score,
  required DateTime startDate,
  required DateTime endTime,
  required int status,
  required int isFinal,
  required List<SubmitRequestList> requestList,
}) async {
  Map<String, dynamic> map = Map();
  map['progressid'] = progressId;
  map['courseid'] = courseId;
  map['chapterid'] = chapterId;
  map['requestpaperid'] = requestPaperId;
  map['correctcount'] = correctCount;
  map['errorcount'] = errorCount;
  map['score'] = score;
  map['startdate'] = startDate.toString();
  map['enddate'] = endTime.toString();
  map['status'] = status;
  map['isfinal'] = isFinal;
  map['requestList'] = requestList;

  dynamic entity = await HttpUtil.post<CourseSubmitTest>(
    '$course/submitrequestall',
    data: map,
  );
  return Future.value(entity);
}

/// 获取章节测试结果
/// [progressId] 进度id
/// [requestPaperId] 测试记录id
Future<BaseEntity<ChapterTestResult>> getChapterTestResult({
  required int progressId,
  required int requestPaperId,
}) async {
  Map<String, dynamic> map = Map();
  map['progressid'] = progressId;
  map['requestpaperid'] = requestPaperId;

  dynamic entity = await HttpUtil.get<ChapterTestResult>(
    '$course/getrequestreslut',
    params: map,
  );
  return Future.value(entity);
}

/// 获取章节测试结果-直接看记录的-首页跳过来的
/// [requestPaperId] 测试记录id
Future<BaseEntity<ChapterTestResult>> getTestResultInfo({
  required int testRequestId,
}) async {
  Map<String, dynamic> map = Map();
  map['requestid'] = testRequestId;

  dynamic entity = await HttpUtil.get<ChapterTestResult>(
    '$course/getrequestreslutbyrequestid',
    params: map,
  );
  return Future.value(entity);
}

/// 获取单词测试结果
/// [orderCode] 测试code
Future<BaseEntity<StudyWordTestResult>> getTestWordResultList({
  required String orderCode,
}) async {
  Map<String, dynamic> map = Map();
  map['ordercode'] = orderCode;

  dynamic entity = await HttpUtil.get<StudyWordTestResult>(
    '$course/getsubmitcqkeytestlist',
    params: map,
  );
  return Future.value(entity);
}

/// 获取章节测试的答题列表
/// [requestId] 答题id
/// [pageIndex] 当前页
/// [pageSize] 当前条数
Future<BaseEntity<ChapterTestRequestList>> getChapterTestRequestList({
  required int requestId,
  int? pageIndex,
  int? pageSize,
}) async {
  Map<String, dynamic> map = Map();
  map['requestid'] = requestId;
  map['pageindex'] = pageIndex;
  map['pagesize'] = pageSize;

  dynamic entity = await HttpUtil.get<ChapterTestRequestList>(
    '$course/getquestresbyrequestid',
    params: map,
    // options: Options(
    //   extra: {
    //     'showLoading': false,
    //   },
    // ),
  );
  return Future.value(entity);
}

/// 测试成功时，重置进度为下一章
/// [progressId] 课程id
/// [courseId] 课程id
/// [chapterId] 章节id
/// [isUpdateProgress] 是否重置
Future<BaseEntity<CourseChapterSetNext>> setNextCourseChapter({
  required int progressId,
  required int courseId,
  required int chapterId,
  required int isUpdateProgress,
}) async {
  Map<String, dynamic> map = Map();
  map['progressid'] = progressId;
  map['courseid'] = courseId;
  map['chapterid'] = chapterId;
  map['isupdateprogress'] = isUpdateProgress;

  dynamic entity = await HttpUtil.post<CourseChapterSetNext>(
    '$course/getnextcoursechatper',
    data: map,
  );
  return Future.value(entity);
}

/// 将进度重置到某一课程的第一章
/// [progressId] 进度id
/// [courseId] 课程id
Future<BaseEntity<CommonReturnStates>> resetProgressToCourse({
  required int progressId,
  required int courseId,
}) async {
  Map<String, dynamic> map = Map();
  map['progressid'] = progressId;
  map['courseid'] = courseId;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$course/resetprogresstocourse',
    data: map,
  );
  return Future.value(entity);
}

/// 提交测前关键词及答题
/// [title] 类型
/// [jsonString] 题目及答案
Future<BaseEntity<WordTestQuestionAnswer>> submitWordTestQuestionAnswer({
  required String title,
  required String jsonString,
}) async {
  Map<String, dynamic> map = Map();
  map['title'] = title;
  map['jonstring'] = jsonString;

  dynamic entity = await HttpUtil.post<WordTestQuestionAnswer>(
    '$course/submitcqkeytest',
    data: map,
  );
  return Future.value(entity);
}

/// 提交final测前单词
/// [progressId] 学习进度id
/// [courseId] 课程id
/// [chapterId] 章节id
/// [correctCount] 正确题数
/// [errorCount] 错误题数
/// [startDate] 测试开始时间
/// [endTime] 测试结束时间
/// [orderCode] 记录编码
Future<BaseEntity<SubmitTestBeforeWord>> submitFinalTestWord({
  int? progressId,
  required int courseId,
  required int chapterId,
  required int correctCount,
  required int errorCount,
  required DateTime startDate,
  required DateTime endTime,
  required String orderCode,
}) async {
  Map<String, dynamic> map = Map();
  map['progressid'] = progressId;
  map['courseid'] = courseId;
  map['chapterid'] = chapterId;
  map['correctcount'] = correctCount;
  map['errorcount'] = errorCount;
  map['startdate'] = startDate.toString();
  map['enddate'] = endTime.toString();
  map['ordercode'] = orderCode;

  dynamic entity = await HttpUtil.post<SubmitTestBeforeWord>(
    '$course/submittestbeforeword',
    data: map,
  );
  return Future.value(entity);
}

/// 获取我的错题列表
/// [randomCount] 条数
Future<BaseEntity<MyErrorQuesttest>> getErrorTestList({
  required int randomCount,
}) async {
  Map<String, dynamic> map = Map();
  map['randomCount'] = randomCount;

  dynamic entity = await HttpUtil.get<MyErrorQuesttest>(
    '$course/geterrorrequesttest',
    params: map,
  );
  return Future.value(entity);
}

/// 获取高频错题列表
/// [randomCount] 条数
Future<BaseEntity<MyErrorQuesttest>> getHighErrorTestList({
  required int randomCount,
}) async {
  Map<String, dynamic> map = Map();
  map['randomCount'] = randomCount;

  dynamic entity = await HttpUtil.get<MyErrorQuesttest>(
    '$course/getallerrorlist',
    params: map,
  );
  return Future.value(entity);
}

/// 获取综合题列表
/// [randomCount] 条数
Future<BaseEntity<MyErrorQuesttest>> getCompositeTestList({
  required int randomCount,
}) async {
  Map<String, dynamic> map = Map();
  map['randomCount'] = randomCount;

  dynamic entity = await HttpUtil.get<MyErrorQuesttest>(
    '$course/getcomprehensivetest',
    params: map,
  );
  return Future.value(entity);
}

/// 提交我的错题-关键词测试
/// [correctCount] 正确题数
/// [errorCount] 错误题数
/// [score] 得分
/// [startDate] 测试开始时间
/// [endTime] 测试结束时间
/// [orderCode] 记录编码
Future<BaseEntity<SubmitTestBeforeWord>> submitMyErrorWordsTest({
  required int correctCount,
  required int errorCount,
  required double score,
  required String orderCode,
  required DateTime startDate,
  required DateTime endTime,
}) async {
  Map<String, dynamic> map = Map();
  map['correctcount'] = correctCount;
  map['errorcount'] = errorCount;
  map['startdate'] = startDate.toString();
  map['enddate'] = endTime.toString();
  map['score'] = score;
  map['ordercode'] = orderCode;

  dynamic entity = await HttpUtil.post<SubmitTestBeforeWord>(
    '$course/submitusreerrortestbeforeword',
    data: map,
  );
  return Future.value(entity);
}

/// 提交高频错题-关键词测试
/// [correctCount] 正确题数
/// [errorCount] 错误题数
/// [score] 得分
/// [startDate] 测试开始时间
/// [endTime] 测试结束时间
/// [orderCode] 记录编码
Future<BaseEntity<SubmitTestBeforeWord>> submitHighErrorWordsTest({
  required int correctCount,
  required int errorCount,
  required double score,
  required String orderCode,
  required DateTime startDate,
  required DateTime endTime,
}) async {
  Map<String, dynamic> map = Map();
  map['correctcount'] = correctCount;
  map['errorcount'] = errorCount;
  map['startdate'] = startDate.toString();
  map['enddate'] = endTime.toString();
  map['score'] = score;
  map['ordercode'] = orderCode;

  dynamic entity = await HttpUtil.post<SubmitTestBeforeWord>(
    '$course/submitalltesttestbeforeword',
    data: map,
  );
  return Future.value(entity);
}

/// 提交综合题-关键词测试
/// [correctCount] 正确题数
/// [errorCount] 错误题数
/// [score] 得分
/// [startDate] 测试开始时间
/// [endTime] 测试结束时间
/// [orderCode] 记录编码
Future<BaseEntity<SubmitTestBeforeWord>> submitCompositeWordsTest({
  required int correctCount,
  required int errorCount,
  required double score,
  required String orderCode,
  required DateTime startDate,
  required DateTime endTime,
}) async {
  Map<String, dynamic> map = Map();
  map['correctcount'] = correctCount;
  map['errorcount'] = errorCount;
  map['startdate'] = startDate.toString();
  map['enddate'] = endTime.toString();
  map['score'] = score;
  map['ordercode'] = orderCode;

  dynamic entity = await HttpUtil.post<SubmitTestBeforeWord>(
    '$course/submitcomprehensivetestbeforeword',
    data: map,
  );
  return Future.value(entity);
}

/// 提交应变-关键词测试
/// [correctCount] 正确题数
/// [errorCount] 错误题数
/// [score] 得分
/// [startDate] 测试开始时间
/// [endTime] 测试结束时间
/// [orderCode] 记录编码
Future<BaseEntity<SubmitTestBeforeWord>> submitStrainsWordsTest({
  required int correctCount,
  required int errorCount,
  required double score,
  required String orderCode,
  required DateTime startDate,
  required DateTime endTime,
}) async {
  Map<String, dynamic> map = Map();
  map['correctcount'] = correctCount;
  map['errorcount'] = errorCount;
  map['startdate'] = startDate.toString();
  map['enddate'] = endTime.toString();
  map['score'] = score;
  map['ordercode'] = orderCode;

  dynamic entity = await HttpUtil.post<SubmitTestBeforeWord>(
    '$course/submitstrainsivetestbeforeword',
    data: map,
  );
  return Future.value(entity);
}

/// 提交测试 - 我的错题
/// [correctCount] 正确题数
/// [errorCount] 错误题数
/// [score] 得分
/// [startDate] 测试开始时间
/// [endTime] 测试结束时间
/// [status] 通过状态 1：测试通过 2：测试不通过
/// [requestList] 测试结束时间
Future<BaseEntity<CourseCompoundSubmit>> submitMyErrorTest({
  required int correctCount,
  required int errorCount,
  required double score,
  required DateTime startDate,
  required DateTime endTime,
  required int status,
  required List<SubmitRequestList> requestList,
}) async {
  Map<String, dynamic> map = Map();
  map['correctcount'] = correctCount;
  map['errorcount'] = errorCount;
  map['score'] = score;
  map['startdate'] = startDate.toString();
  map['enddate'] = endTime.toString();
  map['status'] = status;
  map['requestList'] = requestList;

  dynamic entity = await HttpUtil.post<CourseCompoundSubmit>(
    '$course/submiterrorrequesttest',
    data: map,
  );
  return Future.value(entity);
}

/// 提交测试 - 高频错题
/// [correctCount] 正确题数
/// [errorCount] 错误题数
/// [score] 得分
/// [startDate] 测试开始时间
/// [endTime] 测试结束时间
/// [status] 通过状态 1：测试通过 2：测试不通过
/// [requestList] 测试结束时间
Future<BaseEntity<CourseCompoundSubmit>> submitHighErrorTest({
  required int correctCount,
  required int errorCount,
  required double score,
  required DateTime startDate,
  required DateTime endTime,
  required int status,
  required List<SubmitRequestList> requestList,
}) async {
  Map<String, dynamic> map = Map();
  map['correctcount'] = correctCount;
  map['errorcount'] = errorCount;
  map['score'] = score;
  map['startdate'] = startDate.toString();
  map['enddate'] = endTime.toString();
  map['status'] = status;
  map['requestList'] = requestList;

  dynamic entity = await HttpUtil.post<CourseCompoundSubmit>(
    '$course/submitallerrorrequesttest',
    data: map,
  );
  return Future.value(entity);
}

/// 提交测试 - 综合测试
/// [correctCount] 正确题数
/// [errorCount] 错误题数
/// [score] 得分
/// [startDate] 测试开始时间
/// [endTime] 测试结束时间
/// [status] 通过状态 1：测试通过 2：测试不通过
/// [requestList] 测试结束时间
Future<BaseEntity<CourseCompoundSubmit>> submitCompositeTest({
  required int correctCount,
  required int errorCount,
  required double score,
  required DateTime startDate,
  required DateTime endTime,
  required int status,
  required List<SubmitRequestList> requestList,
}) async {
  Map<String, dynamic> map = Map();
  map['correctcount'] = correctCount;
  map['errorcount'] = errorCount;
  map['score'] = score;
  map['startdate'] = startDate.toString();
  map['enddate'] = endTime.toString();
  map['status'] = status;
  map['requestList'] = requestList;

  dynamic entity = await HttpUtil.post<CourseCompoundSubmit>(
    '$course/submitcomprehensivetest',
    data: map,
  );
  return Future.value(entity);
}

/// 提交测试 - 应变测试
/// [correctCount] 正确题数
/// [errorCount] 错误题数
/// [score] 得分
/// [startDate] 测试开始时间
/// [endTime] 测试结束时间
/// [status] 通过状态 1：测试通过 2：测试不通过
/// [requestList] 测试结束时间
Future<BaseEntity<CourseCompoundSubmit>> submitStrainsTest({
  required int correctCount,
  required int errorCount,
  required double score,
  required DateTime startDate,
  required DateTime endTime,
  required int status,
  required List<SubmitRequestList> requestList,
}) async {
  Map<String, dynamic> map = Map();
  map['correctcount'] = correctCount;
  map['errorcount'] = errorCount;
  map['score'] = score;
  map['startdate'] = startDate.toString();
  map['enddate'] = endTime.toString();
  map['status'] = status;
  map['requestList'] = requestList;

  dynamic entity = await HttpUtil.post<CourseCompoundSubmit>(
    '$course/submitstrainsivetest',
    data: map,
  );
  return Future.value(entity);
}

/// 获取测试结果 - 我的错题
/// [requestPaperId] 测试记录id
Future<BaseEntity<CompoundTestResultData>> getMyErrorTestResult({
  required int requestPaperId,
}) async {
  Map<String, dynamic> map = Map();
  map['id'] = requestPaperId;

  dynamic entity = await HttpUtil.get<CompoundTestResultData>(
    '$course/getmembererrorrequesttestbyid',
    params: map,
  );
  return Future.value(entity);
}

/// 获取测试结果 - 高频错题
/// [requestPaperId] 测试记录id
Future<BaseEntity<CompoundTestResultData>> getHighErrorTestResult({
  required int requestPaperId,
}) async {
  Map<String, dynamic> map = Map();
  map['id'] = requestPaperId;

  dynamic entity = await HttpUtil.get<CompoundTestResultData>(
    '$course/getmemberallerrorrequesttestbyid',
    params: map,
  );
  return Future.value(entity);
}

/// 获取测试结果 - 综合测试
/// [requestPaperId] 测试记录id
Future<BaseEntity<CompoundTestResultData>> getCompositeTestResult({
  required int requestPaperId,
}) async {
  Map<String, dynamic> map = Map();
  map['id'] = requestPaperId;

  dynamic entity = await HttpUtil.get<CompoundTestResultData>(
    '$course/getmembercomprehensivetestbyid',
    params: map,
  );
  return Future.value(entity);
}

/// 获取测试的答题列表 - 我的错题
/// [requestId] 答题id
/// [pageIndex] 当前页
/// [pageSize] 当前条数
Future<BaseEntity<CompoundTestRequestList>> getMyErrorTestRequestList({
  required int requestId,
  int? pageIndex,
  int? pageSize,
}) async {
  Map<String, dynamic> map = Map();
  map['requestid'] = requestId;
  map['pageindex'] = pageIndex;
  map['pagesize'] = pageSize;

  dynamic entity = await HttpUtil.get<CompoundTestRequestList>(
    '$course/getmembererrorquestdetail',
    params: map,
    options: Options(
      extra: {
        'showLoading': false,
      },
    ),
  );
  return Future.value(entity);
}

/// 获取测试的答题列表 - 高频错题
/// [requestId] 答题id
/// [pageIndex] 当前页
/// [pageSize] 当前条数
Future<BaseEntity<CompoundTestRequestList>> getHighErrorTestRequestList({
  required int requestId,
  int? pageIndex,
  int? pageSize,
}) async {
  Map<String, dynamic> map = Map();
  map['requestid'] = requestId;
  map['pageindex'] = pageIndex;
  map['pagesize'] = pageSize;

  dynamic entity = await HttpUtil.get<CompoundTestRequestList>(
    '$course/getmemberallerrorrequesttestdetail',
    params: map,
    options: Options(
      extra: {
        'showLoading': false,
      },
    ),
  );
  return Future.value(entity);
}

/// 获取测试的答题列表 - 我的错题
/// [requestId] 答题id
/// [pageIndex] 当前页
/// [pageSize] 当前条数
Future<BaseEntity<CompoundTestRequestList>> getCompositeTestRequestList({
  required int requestId,
  int? pageIndex,
  int? pageSize,
}) async {
  Map<String, dynamic> map = Map();
  map['requestid'] = requestId;
  map['pageindex'] = pageIndex;
  map['pagesize'] = pageSize;

  dynamic entity = await HttpUtil.get<CompoundTestRequestList>(
    '$course/getmembercomprehensivedetail',
    params: map,
    options: Options(
      extra: {
        'showLoading': false,
      },
    ),
  );
  return Future.value(entity);
}

/// 获取学习学习记录
/// [pageIndex] 当前页
/// [pageSize] 当前条数
Future<BaseEntity<MemberStudyLogs>> getMemberStudyLogs({
  int? pageIndex,
  int? pageSize,
}) async {
  Map<String, dynamic> map = Map();
  map['pageindex'] = pageIndex;
  map['pagesize'] = pageSize;

  dynamic entity = await HttpUtil.get<MemberStudyLogs>(
    '$user/getmemberstudylogs',
    params: map,
    options: Options(
      extra: {
        'showLoading': false,
      },
    ),
  );
  return Future.value(entity);
}

/// 三次final章节不过，写记录
/// [progressId] 学习进度id
/// [courseId] 课程id
/// [chapterId] 章节id
Future<BaseEntity<CommonReturnStates>> updateThreeNoPassFinal({
  required int progressId,
  required int courseId,
  required int chapterId,
}) async {
  Map<String, dynamic> map = Map();
  map['progressid'] = progressId;
  map['courseid'] = courseId;
  map['chapterid'] = chapterId;

  dynamic entity = await HttpUtil.post<CommonReturnStates>(
    '$course/threeprogresstocourse',
    data: map,
  );
  return Future.value(entity);
}
