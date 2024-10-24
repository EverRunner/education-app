import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/config/config.dart';
import 'package:flip_card/flip_card.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/models/course/course_chapter_word_list/course_chapter_word_list_item.dart';
import 'package:yibei_app/utils/audio_player_util.dart';
import 'package:yibei_app/models/course/word_audio/word_audio.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';

import 'package:yibei_app/api/course.dart';
import 'package:yibei_app/utils/tools_util.dart';

/// 关键词组件
class StudyWord extends StatefulWidget {
  /// 关键词列表
  final List<CourseChapterWordListItem> courseWordList;

  // 完成的函数
  final VoidCallback onFinish;

  const StudyWord({
    super.key,
    required this.courseWordList,
    required this.onFinish,
  });

  @override
  State<StudyWord> createState() => _StudyWordState();
}

class _StudyWordState extends State<StudyWord> {
  // 翻转的 GlobalKey
  final GlobalKey<FlipCardState> _flipCardKey = GlobalKey<FlipCardState>();

  // 音频播放
  final _audioPlayer = AudioPlayerUtil();

  // 音频加载
  bool _audioLoading = false;

  // 当前单词的index
  int _wordListIndex = 0;

  // 是否正面
  bool _isFront = true;

  /// 获取音频播放的链接
  _queryWordAudio(String textHtml) async {
    final String text = ToolsUtil.removeHtmlTags(
      textHtml: textHtml,
      isRemoveChinese: true,
    );
    setState(() {
      _audioLoading = true;
    });

    BaseEntity<WordAudio> entity = await getWordAudio(text: text);
    // 播放音频文件
    if (entity.data?.status == true &&
        entity.data?.path != '' &&
        entity.data?.path != null) {
      _audioPlayer.play('${Config.file_root}${entity.data!.path}');
    }

    // 延时一秒后，取消加载图标
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _audioLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 屏幕的高度
    final screenHeight = MediaQuery.of(context).size.height;

    /// 卡片组件
    Widget card({
      bool isFront = true,
      required String textData,
    }) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isFront ? AppColors.colorF5F7FA : AppColors.primaryColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 30,
                ),
                child: Container(
                  height: 26,
                  width: 26,
                  child: _audioLoading == true
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isFront
                                ? AppColors.color74777F
                                : AppColors.whiteColor,
                          ),
                          strokeWidth: 2,
                        )
                      : InkWell(
                          onTap: () {
                            _queryWordAudio(isFront
                                ? (widget.courseWordList[_wordListIndex]
                                        .atitle ??
                                    '')
                                : (widget.courseWordList[_wordListIndex]
                                        .btitle ??
                                    ''));
                          },
                          child: Icon(
                            Icons.volume_up,
                            color: isFront
                                ? AppColors.color74777F
                                : AppColors.whiteColor,
                            size: 26,
                          ),
                        ),
                ),
              ),
              Html(
                data: textData,
                style: {
                  "body": Style(
                    textAlign: TextAlign.center,
                    fontSize: FontSize(30),
                    lineHeight: const LineHeight(1.4),
                    color:
                        isFront ? AppColors.color1A1C1E : AppColors.whiteColor,
                  ),
                },
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: screenHeight - 96,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 进度
          Expanded(
            flex: 1,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_wordListIndex + 1}',
                    style: const TextStyle(
                      fontSize: 32,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Text(
                    '/${widget.courseWordList.length}',
                    style: const TextStyle(
                      fontSize: 24,
                      color: AppColors.color74777F,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 内容
          Expanded(
            flex: 2,
            child: FlipCard(
              key: _flipCardKey,
              fill: Fill.fillBack,
              direction: FlipDirection.VERTICAL,
              side: CardSide.FRONT,
              flipOnTouch: false,
              onFlipDone: (bool isBack) {
                setState(() {
                  _isFront = !isBack;
                });
              },
              front: card(
                textData: (widget.courseWordList.isNotEmpty &&
                        _wordListIndex < widget.courseWordList.length)
                    ? (widget.courseWordList[_wordListIndex].atitle ?? '-')
                    : '-',
              ),
              back: card(
                isFront: false,
                textData: (widget.courseWordList.isNotEmpty &&
                        _wordListIndex < widget.courseWordList.length)
                    ? (widget.courseWordList[_wordListIndex].btitle ?? '-')
                    : '-',
              ),
            ),
          ),

          // 按钮
          Expanded(
            flex: 1,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  YbButton(
                    text: '上一个',
                    width: 110,
                    circle: 50,
                    icon: Icons.arrow_back,
                    iconSize: 14,
                    backgroundColor: _wordListIndex == 0
                        ? AppColors.whiteColor
                        : AppColors.whiteColor,
                    borderColor: _wordListIndex == 0
                        ? AppColors.colorA8A9A9
                        : AppColors.primaryColor,
                    textColor: _wordListIndex == 0
                        ? AppColors.colorA8A9A9
                        : AppColors.primaryColor,
                    disabled: _wordListIndex == 0 ? true : false,
                    onPressed: () {
                      if (_wordListIndex <= 0) {
                        return;
                      }
                      // 翻转到正面
                      if (_isFront == false) {
                        _flipCardKey.currentState?.toggleCardWithoutAnimation();
                      }
                      setState(() {
                        _wordListIndex--;
                      });
                    },
                  ),
                  YbButton(
                    text: '翻面',
                    width: 110,
                    circle: 50,
                    icon: Icons.swap_vert,
                    iconSize: 14,
                    onPressed: () {
                      _flipCardKey.currentState?.toggleCard();
                    },
                  ),
                  YbButton(
                    text: _wordListIndex == widget.courseWordList.length - 1
                        ? '学习完成'
                        : '下一个',
                    width: 110,
                    circle: 50,
                    rightIcon:
                        _wordListIndex == widget.courseWordList.length - 1
                            ? null
                            : Icons.arrow_forward,
                    iconSize: 14,
                    backgroundColor: _isFront == true
                        ? AppColors.whiteColor
                        : AppColors.whiteColor,
                    borderColor: _isFront == true
                        ? AppColors.colorA8A9A9
                        : AppColors.primaryColor,
                    textColor: _isFront == true
                        ? AppColors.colorA8A9A9
                        : AppColors.primaryColor,
                    disabled: _isFront == true ? true : false,
                    onPressed: () {
                      // 只有为反面时，才能下一步
                      if (_isFront == false &&
                          _wordListIndex < widget.courseWordList.length - 1) {
                        // 翻转到正面
                        _flipCardKey.currentState?.toggleCardWithoutAnimation();
                        setState(() {
                          _wordListIndex++;
                        });
                      } else {
                        widget.onFinish();
                      }
                    },
                  ),

                  // ActionButton(
                  //   type: ActionButtonType.disabled,
                  //   text: '上一个',
                  //   icon: Icons.arrow_back,
                  //   onPressed: () {},
                  // ),
                  // ActionButton(
                  //   type: ActionButtonType.primary,
                  //   text: '翻面',
                  //   icon: Icons.swap_vert,
                  //   onPressed: () {
                  //     _flipCardKey.currentState?.toggleCard();
                  //   },
                  // ),
                  // ActionButton(
                  //   type: ActionButtonType.plain,
                  //   text: '下一个',
                  //   icon: Icons.arrow_forward,
                  //   onPressed: () {},
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // 关闭音频
    _audioPlayer.close();
    super.dispose();
  }
}

// /// 按钮类型
// enum ActionButtonType {
//   disabled, // 禁用
//   primary, // 主要
//   plain, // 朴素
// }

// /// 按钮
// class ActionButton extends StatelessWidget {
//   final ActionButtonType type;
//   final VoidCallback? onPressed; // 按钮点击事件
//   final IconData icon;
//   final String text;

//   ActionButton({
//     super.key,
//     required this.type,
//     this.onPressed,
//     required this.icon,
//     required this.text,
//   });

//   late bool disabled = false;
//   late Color backgroundColor = AppColors.primaryColor;
//   late Color iconColor = AppColors.whiteColor;
//   late Color borderSideColor = AppColors.primaryColor;
//   late Color textColor = AppColors.whiteColor;

//   void _setOptions() {
//     if (type == ActionButtonType.disabled) {
//       disabled = true;
//       backgroundColor = AppColors.whiteColor;
//       iconColor = AppColors.colorA8A9A9;
//       borderSideColor = AppColors.colorA8A9A9;
//       textColor = AppColors.colorA8A9A9;
//     }
//     if (type == ActionButtonType.plain) {
//       disabled = true;
//       backgroundColor = AppColors.whiteColor;
//       iconColor = AppColors.primaryColor;
//       borderSideColor = AppColors.primaryColor;
//       textColor = AppColors.primaryColor;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     _setOptions();
//     return SizedBox(
//       width: 110,
//       height: 40,
//       child: ElevatedButton(
//         onPressed: disabled ? null : onPressed,
//         style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
//           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//               side: BorderSide(
//                 color: borderSideColor,
//                 width: 1, // 设置边框宽度
//               ),
//             ),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               size: 14,
//               color: iconColor,
//             ),
//             const SizedBox(width: 10),
//             Text(
//               courseWordList[_wordListIndex].atitle ?? '-'
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
