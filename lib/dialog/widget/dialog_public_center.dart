import 'package:flutter/material.dart';

class AlertDialogShow extends StatelessWidget {
  final String? title;
  final Widget? detail;
  final TextAlign? titleTextAlign;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? actionsPadding;

  const AlertDialogShow({
    super.key,
    this.title,
    this.detail,
    this.actions,
    this.titleTextAlign,
    this.contentPadding,
    this.actionsPadding,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // 定义 Dialog 组件的样式
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      contentPadding: contentPadding,
      actionsPadding: actionsPadding,
      title: Text(
        title ?? '标题',
        textAlign: titleTextAlign,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
      ),
      content: detail ?? const Text('内容'),
      actions: actions ??
          [
            TextButton(
              child: const Text('关闭'),
              onPressed: () {
                Navigator.pop(context); // 关闭弹窗
              },
            ),
          ],
    );
  }
}
