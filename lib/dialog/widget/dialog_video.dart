import 'package:flutter/material.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/utils/colors_util.dart';

class DialogVideo extends StatelessWidget {
  /// 重新播放
  final VoidCallback onReplay;

  /// 完成播放
  final VoidCallback onFinish;

  /// 退出全屏
  final VoidCallback onExitFullScreen;

  final bool isHorizontal;

  final bool isShowFinishButton;

  const DialogVideo({
    super.key,
    required this.onReplay,
    required this.onFinish,
    required this.onExitFullScreen,
    this.isHorizontal = false,
    this.isShowFinishButton = true,
  });

  /// 关闭弹窗
  void close(context) {
    Navigator.of(context).pop(); // 关闭对话框
  }

  /// 重播按钮
  Widget replayButton(BuildContext context) => YbButton(
        text: '重新观看视频',
        icon: Icons.restore,
        borderColor: AppColors.whiteColor,
        backgroundColor: AppColors.whiteColor,
        textColor: AppColors.primaryColor,
        circle: 50,
        onPressed: () {
          close(context);
          onReplay();
        },
      );

  /// 完成按钮
  Widget finishButton(BuildContext context) => YbButton(
        text: '完成，下一步',
        icon: Icons.check_circle,
        borderColor: AppColors.primaryColor,
        backgroundColor: AppColors.primaryColor,
        textColor: AppColors.whiteColor,
        circle: 50,
        onPressed: () {
          close(context);
          onFinish();
        },
      );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const CircleBorder(
        side: BorderSide(color: Colors.transparent),
      ),
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isHorizontal)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                replayButton(context),
                const SizedBox(width: 20),
                if (isShowFinishButton) finishButton(context),
              ],
            )
          else
            Column(
              children: [
                replayButton(context),
                const SizedBox(height: 20),
                if (isShowFinishButton) finishButton(context),
              ],
            ),
          const SizedBox(height: 80),
          if (isHorizontal)
            YbButton(
              text: '退出横向全屏',
              icon: Icons.close_fullscreen,
              borderColor: AppColors.whiteColor,
              backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
              circle: 50,
              onPressed: () {
                onExitFullScreen();
                close(context);
              },
            ),
        ],
      ),
    );
  }
}
