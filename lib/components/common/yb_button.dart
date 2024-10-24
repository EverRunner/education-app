import 'package:flutter/material.dart';
import 'package:yibei_app/utils/colors_util.dart';

class YbButton extends StatelessWidget {
  final String text; // 按钮文字
  final Color? textColor; // 按钮文字颜色
  final double textSize; // 按钮文字色大小
  final Color? backgroundColor; // 按钮背景颜色
  final Color? borderColor; // 按钮边框颜色
  final IconData? icon; // 图标
  final IconData? rightIcon; // 图标
  final double? iconSize; // 图标大小
  final Color? iconColor; // 图标颜色
  final VoidCallback? onPressed; // 按钮点击事件
  final double? width; // 按钮宽度
  final double height; // 按钮高度
  final double circle; // 圆形值
  final bool disabled; // 是否禁用按钮
  final bool plain; // 是否禁用按钮
  final EdgeInsetsGeometry padding; // 按钮内边距

  const YbButton({
    Key? key,
    required this.text,
    this.icon,
    this.onPressed,
    this.width,
    this.height = 40,
    this.circle = 8,
    this.disabled = false,
    this.plain = false,
    this.textSize = 14,
    this.textColor = AppColors.whiteColor,
    this.backgroundColor = AppColors.primaryColor,
    this.borderColor = AppColors.primaryColor,
    this.iconSize = 18.0,
    this.iconColor,
    this.rightIcon,
    this.padding = const EdgeInsets.symmetric(horizontal: 5),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: textColor,
      fontSize: textSize,
      // fontWeight: FontWeight.bold,
    );

    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null)
          Icon(
            icon,
            color: iconColor ?? textColor,
            size: iconSize,
          ),
        if (text != '' && rightIcon == null && icon != null)
          const SizedBox(width: 10),
        Text(text, style: textStyle),
        if (rightIcon != null) const SizedBox(width: 10),
        if (rightIcon != null)
          Icon(
            rightIcon,
            color: textColor,
            size: iconSize,
          )
      ],
    );

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor!),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(circle),
              side: BorderSide(
                color: borderColor!,
                width: 1, // 设置边框宽度
              ),
            ),
          ),
          elevation: MaterialStateProperty.all(0), // 去掉阴影
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
