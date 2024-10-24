import 'package:flutter/material.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/utils/colors_util.dart';

class DialogWordTest extends StatefulWidget {
  final String? title;
  final int testErrorCount;
  final int correctCount;
  final int allWordCount;
  final int wordCategory;
  final double rightLv;
  final VoidCallback onResetTest;
  final VoidCallback onResetVideo;
  final VoidCallback onResetWord;
  final VoidCallback onGotoNext;
  final bool isFinal;
  final String buttonText;

  const DialogWordTest({
    super.key,
    this.title,
    required this.correctCount,
    required this.allWordCount,
    required this.rightLv,
    required this.onResetTest,
    required this.onResetVideo,
    required this.onResetWord,
    required this.onGotoNext,
    this.wordCategory = 0,
    this.testErrorCount = 0,
    this.isFinal = false,
    this.buttonText = '前往单元测试',
  });

  @override
  State<DialogWordTest> createState() => _DialogWordTestState();
}

class _DialogWordTestState extends State<DialogWordTest> {
  /// 文字widget
  Widget _textWidget({
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // 阻止返回按钮关闭对话框
      child: AlertDialog(
        // 定义 Dialog 组件的样式
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 30,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        title: Text(
          widget.title ?? '单词测试',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 信息
            Container(
              width: 500,
              padding: const EdgeInsets.symmetric(
                vertical: 3,
              ),
              decoration: const BoxDecoration(
                color: AppColors.colorF5F7FA,
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 5,
                      top: 2,
                      bottom: 2,
                    ),
                    child: Row(
                      children: [
                        _textWidget(text: '总共'),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 3,
                          ),
                          child: _textWidget(
                            text: '${widget.allWordCount}',
                            color: AppColors.color43474E,
                          ),
                        ),
                        _textWidget(
                          text: '道',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: Row(
                      children: [
                        _textWidget(text: '正确'),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          child: _textWidget(
                            text: '${widget.correctCount}',
                            color: widget.rightLv >= 90
                                ? AppColors.color2E6C00
                                : AppColors.colorBA1A1A,
                          ),
                        ),
                        _textWidget(text: '题'),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 5,
                      right: 10,
                      top: 2,
                      bottom: 2,
                    ),
                    child: Row(
                      children: [
                        _textWidget(text: '正确率'),
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: _textWidget(
                            text: '${widget.rightLv}',
                            color: widget.rightLv >= 90
                                ? AppColors.color2E6C00
                                : AppColors.colorBA1A1A,
                          ),
                        ),
                        _textWidget(text: '%'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 结果
            Container(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '结果：',
                    style: TextStyle(
                      color: AppColors.color1A1C1E,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    widget.rightLv >= 90 ? '通过' : '失败',
                    style: TextStyle(
                      color: widget.rightLv >= 90
                          ? AppColors.color2E6C00
                          : AppColors.colorBA1A1A,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            // 提示
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 25,
              ),
              child: Column(
                children: [
                  const Text(
                    '正确率大于 90% 可通过测试！',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.color74777F,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '已做错 ${widget.testErrorCount} 次',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.color74777F,
                    ),
                  ),
                ],
              ),
            ),

            // 按钮
            Container(
              child: Row(
                mainAxisAlignment:
                    (widget.rightLv < 90 && widget.testErrorCount == 3) ||
                            widget.isFinal
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.end,
                children: widget.isFinal
                    ? [
                        if (widget.rightLv >= 90)
                          YbButton(
                            text: widget.buttonText,
                            circle: 50,
                            onPressed: () {
                              Navigator.pop(context);
                              widget.onGotoNext();
                            },
                          )
                        else
                          YbButton(
                            text: '再试一次',
                            circle: 50,
                            onPressed: () {
                              widget.onResetTest();
                              Navigator.pop(context);
                            },
                          )
                      ]
                    : [
                        if (widget.rightLv >= 90 || widget.testErrorCount == 1)
                          YbButton(
                            text: '再试一次',
                            borderColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            textColor: AppColors.color74777F,
                            onPressed: () {
                              widget.onResetTest();
                              Navigator.pop(context);
                            },
                          ),
                        if (widget.rightLv < 90 && widget.testErrorCount == 2)
                          YbButton(
                            text: widget.wordCategory == 0
                                ? '重学中英关键词'
                                : '重学英文关键词',
                            borderColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            textColor: AppColors.color74777F,
                            onPressed: () {
                              Navigator.pop(context);
                              widget.onResetWord();
                            },
                          ),
                        const SizedBox(
                          width: 7,
                        ),
                        if (widget.rightLv >= 90)
                          YbButton(
                            text: '前往下一步骤',
                            circle: 50,
                            onPressed: () {
                              Navigator.pop(context);
                              widget.onGotoNext();
                            },
                          ),
                        if (widget.rightLv < 90 && widget.testErrorCount >= 1)
                          YbButton(
                            text: '重学视频',
                            circle: 50,
                            onPressed: () {
                              Navigator.pop(context);
                              widget.onResetVideo();
                            },
                          ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
