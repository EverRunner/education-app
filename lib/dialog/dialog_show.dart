import 'package:flutter/material.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'widget/dialog_public_center.dart';
import 'widget/dialog_word_test.dart';
import 'widget/dialog_recommend_friend.dart';
import 'widget/dialog_video.dart';
import 'package:yibei_app/models/user/my_floow_member/my_floow_member_datum.dart';
import 'package:yibei_app/dialog/widget/dialog_pic_select.dart';

/// 显示通用弹窗AlertDialog
Future<bool?> onShowAlertDialog({
  required BuildContext context,
  String? title,
  required Widget detail,
  TextAlign? titleTextAlign,
  EdgeInsetsGeometry? contentPadding,
  EdgeInsetsGeometry? actionsPadding,
  List<Widget>? actions,
  bool barrierDismissible = false,
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible, // 区域外点击不隐藏
    builder: (context) {
      return AlertDialogShow(
        title: title,
        contentPadding: contentPadding,
        actionsPadding: actionsPadding,
        detail: detail,
        titleTextAlign: titleTextAlign,
        actions: actions,
      );
    },
  );
}

/// 显示视频学习Dialog
Future<bool?> onShowVideoDialog({
  required BuildContext context,
  required VoidCallback onReplay,
  required VoidCallback onFinish,
  required VoidCallback onExitFullScreen,
  bool isHorizontal = false,
  bool barrierDismissible = false,
  bool isShowFinishButton = true,
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible, // 区域外点击是否隐藏
    builder: (context) {
      return DialogVideo(
        isHorizontal: isHorizontal,
        isShowFinishButton: isShowFinishButton,
        onExitFullScreen: onExitFullScreen,
        onFinish: onFinish,
        onReplay: onReplay,
      );
    },
  );
}

/// 显示单词测试AlertDialog
/// [testErrorCount] 未通过错误次数
/// [correctCount] 正确题数
/// [allWordCount] 总题数
/// [rightLv] 正确率
/// [onResetTest] 重新测试
/// [onResetVideo] 重学视频
/// [onResetWord] 重学关键词
/// [isFinal] 是否为final
Future<bool?> onShowWordTestDialog({
  required BuildContext context,
  String? title,
  int? testErrorCount,
  int? wordCategory,
  required int correctCount,
  required int allWordCount,
  required double rightLv,
  required VoidCallback onResetTest,
  required VoidCallback onResetVideo,
  required VoidCallback onResetWord,
  required VoidCallback onGotoNext,
  bool? isFinal,
  String? buttonText,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false, // 区域外点击不隐藏

    builder: (context) {
      return DialogWordTest(
        title: title,
        testErrorCount: testErrorCount ?? 0,
        correctCount: correctCount,
        allWordCount: allWordCount,
        wordCategory: wordCategory ?? 0,
        rightLv: rightLv,
        onResetTest: onResetTest,
        onResetVideo: onResetVideo,
        onResetWord: onResetWord,
        onGotoNext: onGotoNext,
        isFinal: isFinal ?? false,
        buttonText: buttonText ?? '前往单元测试',
      );
    },
  );
}

/// 显示推荐测试的AlertDialog
Future<bool?> onShowRecommendFriendDialog({
  required BuildContext context,
  String? title,
  int? friendNum,
  required List<MyFloowMemberDatum> friendList,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false, // 区域外点击不隐藏
    builder: (context) {
      return DialogRecommendFriend(
        title: title,
        friendNum: friendNum,
        friendList: friendList,
      );
    },
  );
}

/// 底部弹窗  sheet
Future<bool?> onShowBottomListDialog(
    BuildContext context, List<String> dataSource, Function(String) onTap,
    {double? height = 200}) {
  return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cleanColor,
      builder: (context) {
        return DialogPicSelect(
          dataSource,
          onTap: onTap,
          height: height,
        );
      });
}
