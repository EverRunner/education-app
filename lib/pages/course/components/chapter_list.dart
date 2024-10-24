import 'package:flutter/material.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:yibei_app/models/course/course_list_data/course_list_data.dart';

// 显示类型
enum FirstShowType {
  circularIndicator, // 圆形指示器
  text, // 文字
}

class ChapterList extends StatefulWidget {
  // 数据列表
  final List<CourseListData> data;

  // 显示的类型
  final FirstShowType firstShowType;

  // 右的边距
  final double firstMarginRight;

  // 圆形指示器线条宽度
  final double circularIndicatorLineWidth;

  // 按钮的回调函数
  final onButtonPressed;

  const ChapterList({
    super.key,
    required this.data,
    this.firstShowType = FirstShowType.circularIndicator,
    this.firstMarginRight = 8.0,
    this.circularIndicatorLineWidth = 5.0,
    required this.onButtonPressed,
  });

  @override
  State<ChapterList> createState() => _CourseListState();
}

class _CourseListState extends State<ChapterList> {
  /// 圆形进度条
  Widget firstShowWidget(int progress, int? index) {
    if (widget.firstShowType == FirstShowType.circularIndicator) {
      return CircularPercentIndicator(
        radius: 25.0,
        lineWidth: progress == 100 ? 3.0 : 5.0,
        percent: progress / 100,
        center: Text(
          "$progress%",
          style: TextStyle(
            fontSize: 12,
            color: progress > 0 ? AppColors.whiteColor : AppColors.primaryColor,
          ),
        ),
        progressColor:
            progress > 0 ? AppColors.whiteColor : AppColors.primaryColor,
        backgroundColor:
            progress > 0 ? AppColors.primaryColor : AppColors.colorF9F9FF,
        circularStrokeCap: CircularStrokeCap.round,
      );
    } else {
      return Text(
        '步骤 ${index ?? 0 + 1}',
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.color74777F,
        ),
      );
    }
  }

  /// 根据进度显示不同按钮
  Widget buttonWidget(
    int progress,
    int id,
    BuildContext context,
    String name,
    int isFinal,
    String? studyStep,
    int? type,
  ) {
    late String text = '查看';
    late Color textColor = AppColors.whiteColor;
    late Color backgroundColor = AppColors.primaryColor;
    late Color borderColor = AppColors.primaryColor;
    late IconData? icon = null;

    if (progress == 100) {
      // 学习完成
      text = '复习';
      textColor = AppColors.primaryColor;
      backgroundColor = AppColors.whiteColor;
      borderColor = AppColors.whiteColor;
    } else if (progress > 0 && progress < 100) {
      // 学习中
      text = '学习';
      textColor = AppColors.primaryColor;
      backgroundColor = AppColors.whiteColor;
      borderColor = AppColors.whiteColor;
    } else {
      text = '';
      textColor = AppColors.color74777F;
      backgroundColor = AppColors.colorF1F0F4;
      borderColor = AppColors.colorF1F0F4;
      icon = Icons.lock_outline;
    }
    // 学习未开始
    return YbButton(
      text: text,
      width: 90,
      circle: 50,
      textColor: textColor,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      icon: icon,
      onPressed: () {
        widget.onButtonPressed(
          context,
          id,
          progress,
          name,
          isFinal,
          studyStep,
          type,
        );
      },
    );
  }

  /// 子项背景颜色
  Color itemBackgroundColor(int progress) {
    if (progress == 100) {
      return AppColors.color86DC51;
    } else if (progress > 0 && progress < 100) {
      return AppColors.primaryColor;
    } else {}
    return AppColors.colorF9F9FF;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.data.map((chapterItem) {
        int index = widget.data.indexOf(chapterItem); // 获取当前元素的索引位置

        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 15,
          ),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: itemBackgroundColor(chapterItem.progress ?? 0),
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double parentWidth = constraints.maxWidth;
              return Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 指示器或文字
                  firstShowWidget(chapterItem.progress ?? 0, index),

                  SizedBox(width: widget.firstMarginRight),

                  // 标题
                  Container(
                    width: parentWidth - 157,
                    margin: const EdgeInsets.only(right: 8),
                    child: Text(
                      chapterItem.title ?? '-',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: (chapterItem.progress ?? 0) > 0
                            ? AppColors.whiteColor
                            : AppColors.color1A1C1E,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),

                  // 按钮
                  buttonWidget(
                    chapterItem.progress ?? -1,
                    chapterItem.id ?? 0,
                    context,
                    chapterItem.title ?? '-',
                    chapterItem.isFinal ?? 0,
                    chapterItem.studyStep ?? '',
                    chapterItem.type,
                  ),
                ],
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
