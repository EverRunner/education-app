import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/models/user/my_floow_member/my_floow_member_datum.dart';

class DialogRecommendFriend extends StatelessWidget {
  final String? title;
  final int? friendNum;
  final List<MyFloowMemberDatum> friendList;

  const DialogRecommendFriend({
    super.key,
    this.title,
    this.friendNum = 0,
    required this.friendList,
  });

  @override
  Widget build(BuildContext context) {
    /// 朋友项
    /// [name] 购买姓名
    /// [date] 购买日期
    /// [isBorder] 是否显示边框
    Widget friendItem({
      required String name,
      required String date,
      required bool isBorder,
    }) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: isBorder ? AppColors.colorC3C6CF : AppColors.whiteColor,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.color1A1C1E,
              ),
            ),
            Text(
              '$date 购课',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.color43474E,
              ),
            ),
          ],
        ),
      );
    }

    return AlertDialog(
      // 定义 Dialog 组件的样式
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      title: Text(
        title ?? '提示',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '当前已成功推荐 $friendNum 位朋友购课！',
            style: const TextStyle(
              color: AppColors.color43474E,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 15),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 350, // 设置最大高度为350
            ),
            child: SingleChildScrollView(
              child: Column(
                children: friendList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return friendItem(
                    name: item.username!,
                    date: DateFormat('yyyy/MM/dd').format(item.creathydate!),
                    isBorder: index != friendList.length - 1,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      actions: [
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
