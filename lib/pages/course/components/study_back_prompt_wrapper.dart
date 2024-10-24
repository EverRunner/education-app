import 'package:flutter/material.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/dialog/dialog_show.dart';

import 'package:yibei_app/models/course/course_chapter_step/course_chapter_step.dart';

class StudyBackPromptWrapper extends StatefulWidget {
  // 主体
  final Widget body;

  const StudyBackPromptWrapper({
    super.key,
    required this.body,
  });

  @override
  State<StudyBackPromptWrapper> createState() => _StudyBackPromptWrapperState();
}

class _StudyBackPromptWrapperState extends State<StudyBackPromptWrapper> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onShowAlertDialog(
          context: context,
          title: '提示',
          detail: const Text('确定要退出当前学习？'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                '取消',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // 关闭弹窗
              },
            ),
            TextButton(
              child: const Text(
                '退出',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.colorBA1A1A,
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // 关闭弹窗
                Navigator.pop(context); // 退出当前页面
              },
            ),
          ],
        );
        // 返回 false，阻止直接退出应用程序
        return false;
      },
      child: widget.body,
    );
  }
}
