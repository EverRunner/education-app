import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yibei_app/models/course/course_chapter_word_list/answer_list_item.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:yibei_app/models/course/course_chapter_word_list/course_chapter_word_list_item.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/utils/tools_util.dart';

class StudyWordTest extends StatefulWidget {
  /// 关键词列表
  final List<CourseChapterWordListItem> courseWordTestList;

  /// 关键词类型  0：中文 1：英文
  final int courseWordCategory;

  /// 提交
  final Future<int?> Function({
    required int useTime,
    required int correctCount,
    required int allWordCount,
    required double rightLv,
    required DateTime startDate,
    required DateTime endTime,
    List<CourseChapterWordListItem>? wordTestData,
    List<int>? allAnswerData,
  }) onSubmit;

  const StudyWordTest(
      {Key? key,
      required this.courseWordTestList,
      required this.courseWordCategory,
      required this.onSubmit})
      : super(key: key);

  @override
  State<StudyWordTest> createState() => StudyWordTestState();
}

class StudyWordTestState extends State<StudyWordTest> {
  // 单词测试列表
  List<CourseChapterWordListItem> _wordTestList = [];

  /// 当前单词的index
  int _wordListIndex = 0;

  /// 正确数
  int _correctNumber = 0;

  /// 错误数
  int _errorNumber = 0;

  /// 当前选择的答案id
  int _nowAnswerSelectId = 0;

  /// 当前按钮的状态
  String _nowButtonStatus = 'show';

  /// 下一按钮的文字
  String _nextButtonText = '前往下一题';

  /// 获取开始测试的时间
  late DateTime _startDate;

  /// 提交加载
  bool _isLoading = false;

  // 用户选择的全部答案
  List<int> _allAnswerList = [];

  /// 显示答案（开发环境中显示）
  final bool _showAnswer =
      (const String.fromEnvironment('APP_ENV') == 'dev') ? true : false;

  /// 文字widget
  Widget _textWidget({
    required String text,
    Color? color = AppColors.color74777F,
    double? fontSize = 14,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
      ),
    );
  }

  /// 生成测试列表
  _handleQueryPair() {
    // 新的关键词列表（带有选项）
    List<CourseChapterWordListItem> wordList = widget.courseWordTestList;

    if (widget.courseWordTestList.isEmpty) return;

    // 获取选项的集合
    List<AnswerListItem> bTitleOptions = wordList.map((e) {
      return AnswerListItem(
        id: e.id,
        title: e.btitle,
        iscorrectoption: null,
      );
    }).toList();

    // 对每个元素添加 answerList 字段
    for (var item in wordList) {
      List<AnswerListItem> answerList = [];

      // 将自身的 btitle 添加到 answerList 中
      answerList.add(AnswerListItem(
        id: item.id,
        title: item.btitle,
        iscorrectoption: 1,
      ));

      // 随机选择值
      bTitleOptions.forEach((item) {
        // 随机index
        final randomIndex = Random().nextInt(bTitleOptions.length);
        // 随机btitle
        final selectedAnswer = bTitleOptions[randomIndex];

        // 去掉多余的符号，再比较
        if (answerList.any((option) =>
                ToolsUtil.checkContain(option.title!, selectedAnswer.title!)) ||
            answerList.length >= 4) return;

        answerList.add(selectedAnswer);
      });

      item.answerList = answerList..shuffle();
    }

    // 题目随机排序
    setState(() {
      _wordTestList = wordList..shuffle();
    });

    _startDate = DateTime.now();
  }

  /// 处理选项的状态
  OptionItemState _handleOptionItemState(int answerId) {
    // 选择答案时
    if (_nowButtonStatus == 'show' && _nowAnswerSelectId == answerId) {
      return OptionItemState.select;
    }

    // 显示答案（正确时）
    if (_nowButtonStatus != 'show' &&
        answerId == _wordTestList[_wordListIndex].id) {
      return OptionItemState.correct;
    }

    // 显示答案（错误时）
    if (_nowButtonStatus != 'show' &&
        _nowAnswerSelectId == answerId &&
        _nowAnswerSelectId != _wordTestList[_wordListIndex].id) {
      return OptionItemState.error;
    }

    // 显示答案（无效时）
    if (_nowButtonStatus != 'show') {
      return OptionItemState.disabled;
    }

    return OptionItemState.enabled;
  }

  /// 答案列表
  List<Widget> _answerListWidget() {
    final answerList = _wordTestList[_wordListIndex].answerList;

    return List.generate(
      answerList?.length ?? 0,
      (index) {
        final answer = answerList?[index] ?? AnswerListItem(title: '');

        return OptionItem(
          text: answer.title ?? '',
          onPressed: () {
            _handleConfirmAnswer(answer.id ?? 0);
          },
          state: _handleOptionItemState(answer.id ?? 0),
          answer: _showAnswer
              ? answer.id == _wordTestList[_wordListIndex].id
              : null,
        );
      },
    );
  }

  /// 处理选择答案
  /// [selectAnswerId] 选择的答案
  _handleConfirmAnswer(int selectAnswerId) {
    setState(() {
      _nowAnswerSelectId = selectAnswerId;
    });
  }

  /// 显示答案
  _handleShowAnswer() {
    // 没有选择时
    if (_nowAnswerSelectId == 0) return;

    setState(() {
      _allAnswerList.add(_nowAnswerSelectId);

      // 保存答案
      _wordTestList[_wordListIndex].answer = _nowAnswerSelectId;

      if (_nowAnswerSelectId == _wordTestList[_wordListIndex].id) {
        // 正确
        _correctNumber++;
        // 按钮状态
        _nowButtonStatus = 'correctNext';
        if (_wordListIndex >= _wordTestList.length - 1) {
          _nextButtonText = '正确！完成测试';
        } else {
          _nextButtonText = '正确！前往下一题';
        }
      } else {
        // 错误
        _errorNumber++;
        _nowButtonStatus = 'errorNext';
        if (_wordListIndex >= _wordTestList.length - 1) {
          _nextButtonText = '记住了！完成测试';
        } else {
          _nextButtonText = '记住了！前往下一题';
        }
      }
    });
  }

  /// 进入一题（提交）
  _handleNext() async {
    if (_wordListIndex >= _wordTestList.length - 1) {
      setState(() {
        _isLoading = true;
      });

      // 用时秒数
      final DateTime endTime = DateTime.now();
      final Duration difference = endTime.difference(_startDate);
      final int useTime = difference.inSeconds;

      // 总数
      final allWordCount = _wordTestList.length;

      // 正确率
      final double accuracy = _correctNumber / (allWordCount) * 100;
      final double rightLv = double.parse(accuracy.toStringAsFixed(1));

      // 提交函数
      int? resData = await widget.onSubmit(
        useTime: useTime,
        correctCount: _correctNumber,
        allWordCount: allWordCount,
        rightLv: rightLv,
        startDate: _startDate,
        endTime: endTime,
        wordTestData: _wordTestList,
        allAnswerData: _allAnswerList,
      );
      // 接口发生错误时，取消loading
      if (resData == 1) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _nowAnswerSelectId = 0;
        _nowButtonStatus = 'show';
        _wordListIndex++;
      });
    }
  }

  /// 处理重新测试
  handleResetTest() {
    _handleQueryPair();
    setState(() {
      _correctNumber = 0;
      _errorNumber = 0;
      _wordListIndex = 0;
      _nowButtonStatus = 'show';
      _nowAnswerSelectId = 0;
      _allAnswerList = [];
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _handleQueryPair();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 屏幕的高度
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        minHeight: screenHeight - 96,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: [
              // 题目和标题部分
              Container(
                color: AppColors.colorF1F0F4,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 0,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.colorECEFF5,
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                _textWidget(text: '题号'),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: _textWidget(
                                    text: '${_wordListIndex + 1}',
                                    color: AppColors.color43474E,
                                  ),
                                ),
                                _textWidget(
                                  text: '/${_wordTestList.length}',
                                  fontSize: 12,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                _textWidget(text: '正确'),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: _textWidget(
                                    text: '$_correctNumber',
                                    color: AppColors.color2E6C00,
                                  ),
                                ),
                                _textWidget(text: '题'),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                _textWidget(text: '错误'),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: _textWidget(
                                    text: '$_errorNumber',
                                    color: AppColors.colorBA1A1A,
                                  ),
                                ),
                                _textWidget(text: '题'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 5,
                      ),
                      child: const Text(
                        '请选择对应的关键词',
                        style: TextStyle(
                          color: AppColors.color74777F,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        bottom: 1,
                      ),
                      child: Html(
                        data: _wordTestList.isNotEmpty
                            ? _wordTestList[_wordListIndex].atitle
                            : '',
                        style: {
                          "body": Style(
                            textAlign: TextAlign.center,
                            fontSize: FontSize(30),
                            lineHeight: const LineHeight(1.4),
                            color: AppColors.color1A1C1E,
                            fontWeight: FontWeight.w700,
                          ),
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // 选择项部分
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _wordTestList.isNotEmpty ? _answerListWidget() : [],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              top: 20,
              bottom: 70,
            ),
            child: _nowButtonStatus == 'show'
                ? YbButton(
                    text: '送出答案',
                    width: double.infinity,
                    height: 40,
                    circle: 20,
                    disabled: _isLoading,
                    onPressed: () {
                      _handleShowAnswer();
                    },
                  )
                : YbButton(
                    text: _nextButtonText,
                    width: double.infinity,
                    height: 40,
                    circle: 20,
                    disabled: _isLoading,
                    backgroundColor: _nowButtonStatus == 'correctNext'
                        ? AppColors.color86DC51
                        : AppColors.colorBA1A1A,
                    borderColor: _nowButtonStatus == 'correctNext'
                        ? AppColors.color86DC51
                        : AppColors.colorBA1A1A,
                    onPressed: () {
                      _handleNext();
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// 选择项的状态枚举
enum OptionItemState {
  disabled,
  select,
  correct,
  error,
  enabled,
}

/// 选择项
class OptionItem extends StatefulWidget {
  final String text;
  final Function onPressed;
  final OptionItemState state;
  final bool? answer;

  const OptionItem({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.state,
    this.answer,
  }) : super(key: key);

  @override
  _OptionItemState createState() => _OptionItemState();
}

class _OptionItemState extends State<OptionItem> {
  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    Color borderColor;
    bool isClickable;

    switch (widget.state) {
      case OptionItemState.disabled:
        bgColor = AppColors.colorF1F1F1;
        textColor = AppColors.colorCBCBCB;
        borderColor = AppColors.colorF1F1F1;
        isClickable = false;
        break;
      case OptionItemState.select:
        bgColor = AppColors.colorEBF0F8;
        textColor = Colors.black;
        borderColor = AppColors.primaryColor;
        isClickable = false;
        break;
      case OptionItemState.correct:
        bgColor = Colors.white;
        textColor = Colors.black;
        borderColor = AppColors.color86DC51;
        isClickable = false;
        break;
      case OptionItemState.error:
        bgColor = Colors.white;
        textColor = Colors.black;
        borderColor = AppColors.dangerColor;
        isClickable = false;
        break;
      case OptionItemState.enabled:
        bgColor = Colors.white;
        textColor = Colors.black;
        borderColor = Colors.transparent;
        isClickable = true;
        break;
      default:
        bgColor = Colors.white;
        textColor = Colors.black;
        borderColor = Colors.transparent;
        isClickable = true;
    }

    return GestureDetector(
      onTap: isClickable ? widget.onPressed as void Function()? : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 15,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: widget.state == OptionItemState.enabled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.state == OptionItemState.correct)
              const Icon(
                Icons.check_circle_outline,
                size: 18,
                color: AppColors.successColor,
              ),
            if (widget.state == OptionItemState.error)
              const Icon(
                Icons.cancel_outlined,
                size: 18,
                color: AppColors.dangerColor,
              ),
            Expanded(
              child: Html(
                data: '${widget.text}${widget.answer == true ? ' --1' : ''}',
                style: {
                  "body": Style(
                    textAlign: TextAlign.center,
                    fontSize: FontSize(16),
                    lineHeight: const LineHeight(1.4),
                    color: textColor,
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
