import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:yibei_app/components/common/countdown_timer.dart';
import 'package:yibei_app/models/course/course_test_list/course_test_list_item.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/models/course/submit_request_list/submit_request_list.dart';
import 'package:yibei_app/models/course/course_test_list/yibei_requestion_const_option.dart';
import 'package:yibei_app/utils/toast_util.dart';

class StudyTest extends StatefulWidget {
  // 单元测试列表
  final List<CourseTestListItem> courseTestList;

  /// 测试时间（默认15分钟）
  final int testTime;

  /// 提交
  final Future<int?> Function({
    required int correctCount,
    required int errorCount,
    required double score,
    required DateTime startDate,
    required List<SubmitRequestList> requestList,
  }) onSubmit;

  const StudyTest({
    super.key,
    required this.courseTestList,
    required this.onSubmit,
    required this.testTime,
  });

  @override
  State<StudyTest> createState() => _StudyTestState();
}

class _StudyTestState extends State<StudyTest> {
  /// 倒计时
  late final CountdownTimer _countdownTimer;

  // 单元测试列表
  List<CourseTestListItem> _courseTestList = [];

  /// 当前测试的index
  int _testListIndex = 0;

  /// 获取开始测试的时间
  late DateTime _startDate;

  /// 随机对象
  final _random = Random();

  /// 提交加载
  bool _isLoading = false;

  /// 显示答案（开发环境中显示）
  final bool _showAnswer =
      (const String.fromEnvironment('APP_ENV') == 'dev') ? true : false;

  /// 获取单元测试列表（选择项随机排序）
  _handleQueryTest() {
    // 单元测试列表
    List<CourseTestListItem> wordList = widget.courseTestList;

    if (widget.courseTestList.isEmpty) return;

    for (var i = 0; i < wordList.length; i++) {
      wordList[i].yibeiRequestionConstOption!.shuffle(_random);
    }

    setState(() {
      _courseTestList = wordList;
    });

    // 开始倒计时
    _countdownTimer = CountdownTimer(
      key: countdownTimerGlobalKey,
      seconds: widget.testTime,
      onTimerClear: () {
        ToastUtil.shortToast(
          "测试时间已到",
        );
        _handleSubmit();
      },
    );

    // 测试开始时间
    _startDate = DateTime.now();
  }

  /// 进入一题
  _handleNext() async {
    if (_courseTestList[_testListIndex].answer == null) {
      return ToastUtil.shortToast(
        "请选择答案",
      );
    }
    if (_testListIndex >= _courseTestList.length - 1) {
      // 清空定时器
      countdownTimerGlobalKey.currentState?.handleTimerClear();
      // 提交
      _handleSubmit();
    } else {
      setState(() {
        _testListIndex++;
      });
    }
  }

  /// 处理提交测试
  Future<void> _handleSubmit() async {
    setState(() {
      _isLoading = true;
    });

    // 结束时间
    final DateTime endTime = DateTime.now();

    // 总数
    final allWordCount = _courseTestList.length;

    // 所有题目及答案
    List<SubmitRequestList> requestList = [];

    // 正确数
    int correctCount = 0;
    for (var item in _courseTestList) {
      var row = item.yibeiRequestionConstOption?.firstWhere(
        (a) => a.id == item.answer && a.iscorrectoption == 1,
        orElse: () => YibeiRequestionConstOption(),
      );
      if (row?.id != null) {
        correctCount++;
      }

      var requestData = SubmitRequestList(
        requestid: item.requestionid,
        title: item.yibeiRequestionConst?.content,
        category: item.yibeiRequestionConst?.category,
        memberanswser: item.answer,
        status: row?.id != null ? 1 : 2,
      );
      requestList.add(requestData);
    }

    // 得分
    final double accuracy = correctCount / (allWordCount) * 100;
    final double score = double.parse(accuracy.toStringAsFixed(1));

    // 提交完成后的操作
    int? resData = await widget.onSubmit(
      correctCount: correctCount,
      errorCount: allWordCount - correctCount,
      score: score,
      startDate: _startDate,
      requestList: requestList,
    );
    // 接口发生错误时，取消loading
    if (resData == 1) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _handleQueryTest();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 屏幕的高度
    final screenHeight = MediaQuery.of(context).size.height;

    // 文字widget
    Widget textWidget({
      required String text,
      Color? color = AppColors.color74777F,
      double? fontSize = 16,
    }) {
      return Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
        minHeight: screenHeight - 96,
      ),
      child: _courseTestList.isEmpty
          ? const Center(
              child: Text('题目加载中...'),
            )
          : Column(
              children: [
                Column(
                  children: [
                    // 题目和标题部分
                    Container(
                      color: AppColors.colorF1F0F4,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 0,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: AppColors.colorF1F0F4,
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      textWidget(
                                        text: '题号',
                                        fontSize: 14,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        child: textWidget(
                                          text: '${_testListIndex + 1}',
                                          color: AppColors.color43474E,
                                        ),
                                      ),
                                      textWidget(
                                        text: '/${_courseTestList.length}',
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      textWidget(
                                        text: '测试剩余时间：',
                                        fontSize: 14,
                                      ),
                                      _countdownTimer,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Html(
                              data: _courseTestList.isNotEmpty
                                  ? _courseTestList[_testListIndex]
                                      .yibeiRequestionConst!
                                      .content!
                                  : '',
                              style: {
                                "body": Style(
                                  fontSize: FontSize(16),
                                  lineHeight: const LineHeight(1.5),
                                  color: AppColors.color1A1C1E,
                                ),
                              },
                              //  imgMaxWidth: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 选项部分
                    Container(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        children: <Widget>[
                          ..._courseTestList[_testListIndex]
                              .yibeiRequestionConstOption!
                              .map((optionItem) {
                            return RadioListTile(
                                title: Text(
                                    '${optionItem.title} ${_showAnswer && optionItem.iscorrectoption == 1 ? '--1' : ''}'),
                                activeColor: AppColors.primaryColor,
                                value: optionItem.id,
                                groupValue:
                                    _courseTestList[_testListIndex].answer,
                                onChanged: (value) {
                                  setState(() {
                                    _courseTestList[_testListIndex].answer =
                                        value;
                                  });
                                });
                          }).toList(),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                    top: 50,
                    bottom: 50,
                  ),
                  color: AppColors.whiteColor,
                  child: YbButton(
                    width: double.infinity,
                    disabled: _isLoading,
                    text: _testListIndex >= _courseTestList.length - 1
                        ? '完成测试'
                        : '下一题',
                    height: 40,
                    circle: 20,
                    onPressed: () {
                      _handleNext();
                    },
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
