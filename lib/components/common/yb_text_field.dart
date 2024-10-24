import 'package:flutter/material.dart';
import 'package:yibei_app/utils/colors_util.dart';

class YbTextField extends StatefulWidget {
  // label文字
  final String labelText;

  // 提示文字
  final String? hintText;

  // 是否显示密码
  final bool? obscureText;

  // 是否是密码框
  final bool? isPassword;

  // 文本框控制器
  final TextEditingController? controller;

  // 自动获取光标
  final FocusNode? focusNode;

  // 错误提示信息
  final String? errorText;

  // 值改变回调
  final ValueChanged? onChanged;

  // 点击回调
  final VoidCallback? onTap;

  // 后缀图标
  final Widget? suffixIcon;

  // 最大行数
  final int? maxLines;

  // 输入类型
  final TextInputType? keyboardType;

  // 禁止打开输入法
  final bool? readOnly;

  // 禁用
  final bool? enabled;

  // 字符长度
  final int? maxLength;

  // 样式
  final TextStyle? style;

  const YbTextField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.obscureText,
    this.focusNode,
    this.errorText,
    this.onChanged,
    this.suffixIcon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    this.isPassword = false,
    this.maxLength,
    this.style,
  });

  @override
  State<YbTextField> createState() => _YbTextFieldState();
}

class _YbTextFieldState extends State<YbTextField> {
  late bool _isObscureText;

  @override
  void initState() {
    super.initState();
    _isObscureText = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _isObscureText,
      controller: widget.controller,
      focusNode: widget.focusNode,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      maxLength: widget.maxLength,
      readOnly: widget.readOnly!,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => FocusScope.of(context).unfocus(), // 触发提交事件时，隐藏键盘
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorText: widget.errorText,
        enabled: widget.enabled ?? false,
        errorStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.dangerColor,
          decoration: TextDecoration.none,
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.dangerColor, width: 2.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: const OutlineInputBorder(borderSide: BorderSide(width: 0.5)),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: widget.isPassword == true
            ? IconButton(
                icon: Icon(
                  _isObscureText == true
                      ? Icons.visibility_off
                      : Icons.visibility,
                  size: 16,
                ),
                onPressed: () {
                  setState(() {
                    _isObscureText = !_isObscureText;
                  });
                },
              )
            : widget.suffixIcon,
      ),
      style: widget.style ?? const TextStyle(color: AppColors.color1A1C1E),
    );
  }
}
