import 'package:flutter/material.dart';
import 'package:yibei_app/components/common/yb_text_field.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

/// 父组件可获取该值，操作子组件的函数
GlobalKey<_YbDatePickerState> ybDatePickerKey = GlobalKey();

class YbDatePicker extends StatefulWidget {
  // label文字
  final String labelText;

  /// 初始值
  final String? initValue;

  /// 必填提示内容
  final String? errorHint;

  /// 清空
  final VoidCallback? clearErrorHint;

  const YbDatePicker({
    super.key,
    required this.labelText,
    this.initValue,
    this.errorHint = '',
    this.clearErrorHint,
  });

  @override
  State<YbDatePicker> createState() => _YbDatePickerState();
}

class _YbDatePickerState extends State<YbDatePicker> {
  // 输入框控制器
  final textFieldController = TextEditingController();

  /// 确认选择
  _pickDateTime() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1940, 1, 1),
      maxTime: DateTime.now(),
      onConfirm: (dateTime) {
        textFieldController.text = DateFormat('yyyy/MM/dd').format(dateTime);
      },
      currentTime: DateTime.now(),
      locale: LocaleType.zh, // 设置语言为中文
    );
    if (widget.clearErrorHint != null) {
      widget.clearErrorHint!();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initValue != null) {
      textFieldController.text = widget.initValue!;
    }

    return YbTextField(
      labelText: widget.labelText,
      controller: textFieldController,
      readOnly: true,
      onTap: _pickDateTime,
      hintText: '选择日期',
      errorText: widget.errorHint == '' ? null : widget.errorHint,
      suffixIcon: const Icon(
        Icons.today_rounded,
        color: AppColors.color43474E,
        size: 20,
      ),
    );
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }
}
