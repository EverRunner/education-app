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

class CourseList extends StatefulWidget {
  // 数据列表
  final List<CourseListData> data;

  // 显示的类型
  final FirstShowType firstShowType;

  // 右的边距
  final double firstMarginRight;

  // 圆形指示器线条宽度
  final double circularIndicatorLineWidth;

  // 子项的背景色
  final Color itemBackgroundColor;

  // 按钮的回调函数
  final onButtonPressed;

  // 禁用
  final bool disabled;

  const CourseList({
    super.key,
    required this.data,
    this.firstShowType = FirstShowType.circularIndicator,
    this.firstMarginRight = 8.0,
    this.circularIndicatorLineWidth = 5.0,
    this.itemBackgroundColor = AppColors.whiteColor,
    required this.onButtonPressed,
    this.disabled = false,
  });

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  /// 圆形进度条
  Widget firstShowWidget(int progress, int? index) {
    if (widget.firstShowType == FirstShowType.circularIndicator) {
      return CircularPercentIndicator(
        radius: 25.0,
        lineWidth: progress == 100 ? 3.0 : 5.0,
        percent: progress / 100,
        center: Text(
          "$progress%",
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.primaryColor,
          ),
        ),
        progressColor: AppColors.primaryColor,
        backgroundColor: AppColors.whiteColor,
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
  Widget buttonWidget(int progress, int id, BuildContext context) {
    // 禁用时
    if (widget.disabled) {
      return YbButton(
        text: '',
        width: 90,
        circle: 50,
        textColor: AppColors.color74777F,
        backgroundColor: AppColors.colorF1F0F4,
        borderColor: AppColors.colorF1F0F4,
        icon: Icons.lock_outline,
        onPressed: () {
          widget.onButtonPressed();
        },
      );
    }

    // 启用时
    late String text = '查看';
    late Color textColor = AppColors.whiteColor;
    late Color backgroundColor = AppColors.primaryColor;
    late Color borderColor = AppColors.primaryColor;

    if (progress == 100) {
      // 学习完成
      text = '复习';
      textColor = AppColors.primaryColor;
      backgroundColor = AppColors.whiteColor;
    } else if (progress > 0 && progress < 100) {
      // 学习中
      text = '学习';
    } else {
      text = '查看';
      textColor = AppColors.color74777F;
      backgroundColor = AppColors.colorF1F0F4;
      borderColor = AppColors.colorF1F0F4;
    }
    // 学习未开始
    return YbButton(
      text: text,
      width: 90,
      circle: 50,
      textColor: textColor,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      onPressed: () {
        widget.onButtonPressed(context, id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.data.map((courseData) {
        int index = widget.data.indexOf(courseData); // 获取当前元素的索引位置

        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 15,
          ),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: widget.itemBackgroundColor,
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
                  firstShowWidget(courseData.progress ?? 0, index),

                  SizedBox(width: widget.firstMarginRight),

                  // 标题
                  Container(
                    width: parentWidth - 157,
                    margin: const EdgeInsets.only(right: 8),
                    child: Text(
                      courseData.title ?? '-',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.color1A1C1E,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),

                  buttonWidget(
                    courseData.progress ?? -1,
                    courseData.id ?? 0,
                    context,
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
