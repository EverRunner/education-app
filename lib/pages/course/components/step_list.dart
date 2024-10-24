import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yibei_app/utils/colors_util.dart';

import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/models/course/course_chapter_step/course_chapter_step.dart';

// 显示类型
enum FirstShowType {
  circularIndicator, // 圆形指示器
  text, // 文字
}

class StepList extends StatefulWidget {
  // 数据列表
  final List<CourseChapterStep> data;

  // 显示的类型
  final FirstShowType firstShowType;

  // 右的边距
  final double firstMarginRight;

  // 圆形指示器线条宽度
  final double circularIndicatorLineWidth;

  // 子项的背景色
  final Color itemBackgroundColor;

  // 按钮的回调函数
  final void Function(
    BuildContext context,
    int index,
    int progress,
    String routeName,
    String? title,
  ) onButtonPressed;

  const StepList({
    super.key,
    required this.data,
    this.firstShowType = FirstShowType.circularIndicator,
    this.firstMarginRight = 18.0,
    this.circularIndicatorLineWidth = 5.0,
    this.itemBackgroundColor = AppColors.whiteColor,
    required this.onButtonPressed,
  });

  @override
  State<StepList> createState() => _CourseListState();
}

class _CourseListState extends State<StepList> {
  /// 步骤
  Widget firstShowWidget(int progress, int index) {
    return Text(
      '步骤 ${index >= 0 ? index + 1 : '-'}',
      style: const TextStyle(
        fontSize: 12,
        color: AppColors.color74777F,
      ),
    );
  }

  /// 根据进度显示不同按钮
  Widget buttonWidget(
    int progress,
    int index,
    BuildContext context,
    String routeName,
    String? title,
  ) {
    late String text = '查看';
    late Color textColor = AppColors.whiteColor;
    late Color backgroundColor = AppColors.primaryColor;
    late Color borderColor = AppColors.primaryColor;
    late IconData? icon = null;

    if (progress == 100) {
      // 学习完成，包含两种情况（单元测试和其他步骤）
      text = index == 5 ? '' : '复习';
      textColor = index == 5 ? AppColors.color74777F : AppColors.primaryColor;
      backgroundColor =
          index == 5 ? AppColors.colorF1F0F4 : AppColors.whiteColor;
      borderColor = index == 5 ? AppColors.colorF1F0F4 : AppColors.primaryColor;
      icon = index == 5 ? Icons.lock_outline : null;
    } else if (progress > 0 && progress < 100) {
      // 学习中
      text = '学习';
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
          index,
          progress,
          routeName,
          title,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.data.map((stepItem) {
        int index = widget.data.indexOf(stepItem); // 获取当前元素的索引位置

        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 15,
          ),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(
            color: AppColors.colorF9F9FF,
            borderRadius: BorderRadius.all(
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
                  firstShowWidget(stepItem.progress ?? 0, index),

                  SizedBox(width: widget.firstMarginRight),

                  // 标题
                  Container(
                    width: parentWidth - 157,
                    margin: const EdgeInsets.only(right: 8),
                    child: Text(
                      stepItem.title ?? '-',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.color1A1C1E,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),

                  // 按钮
                  buttonWidget(
                    stepItem.progress ?? -1,
                    stepItem.index ?? 0,
                    context,
                    stepItem.route ?? '',
                    stepItem.title,
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
