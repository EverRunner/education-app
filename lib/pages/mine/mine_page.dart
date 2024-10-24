import 'package:flutter/material.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/utils/cache_util.dart';
import 'package:yibei_app/models/mine/mine_menu_item/mine_menu_item.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/models/user/login_user_info/user_info.dart';

import 'package:yibei_app/provider/notifier_provider.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
// 菜单列表
  final List<MineMenuItem> _menuData = [
    MineMenuItem(
      title: '学习数据',
      path: AppRoutes.homeStudyData,
      icon: 'description_outlined',
      display: false,
    ),
    MineMenuItem(
      title: '学习分析',
      path: AppRoutes.studyAnalysis,
      icon: 'data_thresholding_outlined',
      display: false,
    ),
    MineMenuItem(
      title: '帐号设置',
      path: AppRoutes.mineAccountSettingPage,
      icon: 'settings_outlined',
      display: true,
    ),
    MineMenuItem(
      title: '个人资料',
      path: AppRoutes.minePersonalData,
      icon: 'person_outlined',
      display: true,
    ),
    MineMenuItem(
      title: '我的购买',
      path: AppRoutes.mineMyBuyPage,
      icon: 'shopping_bag_outlined',
      display: true,
    ),
    MineMenuItem(
      title: '推荐朋友',
      path: AppRoutes.mineRecommendFriendPage,
      icon: 'supervisor_account_outlined',
      display: true,
    ),
    MineMenuItem(
      title: '关于易北',
      path: AppRoutes.mineAboutUs,
      icon: 'info_outlined',
      display: true,
    ),
    MineMenuItem(
      title: '退出登录',
      path: 'logout',
      icon: 'logout',
      display: true,
    ),
  ];

  IconData _icon(String? iconType) {
    switch (iconType) {
      case 'description_outlined':
        return Icons.description_outlined;

      case 'data_thresholding_outlined':
        return Icons.data_thresholding_outlined;

      case 'settings_outlined':
        return Icons.settings_outlined;

      case 'person_outlined':
        return Icons.person_outlined;

      case 'shopping_bag_outlined':
        return Icons.shopping_bag_outlined;

      case 'supervisor_account_outlined':
        return Icons.supervisor_account_outlined;

      case 'info_outlined':
        return Icons.info_outlined;

      case 'logout':
        return Icons.logout;

      default:
        return Icons.logout;
    }
  }

  /// 处理退出登录
  void _handleLogout() {
    onShowAlertDialog(
      context: context,
      title: '提示',
      actionsPadding: const EdgeInsets.only(
        bottom: 15,
        right: 20,
      ),
      detail: const Text('您确认要退出系统吗？'),
      actions: [
        TextButton(
          child: const Text('关闭'),
          onPressed: () {
            Navigator.pop(context); // 关闭弹窗
          },
        ),
        YbButton(
          text: '确认',
          circle: 25,
          height: 38,
          onPressed: () {
            // 删除缓存
            CacheUtils.instance.remove('token');
            CacheUtils.instance.remove('userInfo');

            Navigator.pop(context); // 关闭弹窗
            jumpPageProvider.value = 3; // 跳转到登录
          },
        ),
      ],
    );
  }

  /// 处理点击事件
  void _handleTap(String path) {
    switch (path) {
      case AppRoutes.introduce:
        Navigator.pushNamed(
          context,
          path,
          arguments: {
            'showBack': true,
          },
        );
        break;

      case 'logout':
        _handleLogout();
        break;

      default:
        Navigator.pushNamed(context, path);
    }
  }

  @override
  void initState() {
    super.initState();

    // 获取用户信息的缓存
    UserInfo? userInfo = CacheUtils.instance.get<UserInfo>('userInfo');

    // 当前日期
    DateTime currentDate = DateTime.now();

    setState(() {
      if (userInfo?.level == 1 &&
          !currentDate.isAfter(userInfo?.endhydate ?? currentDate)) {
        _menuData[0].display = true;
        _menuData[1].display = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // 设置为0表示不显示AppBar
        child: AppBar(
          backgroundColor: AppColors.colorF1F4FA,
          elevation: 0.0, // 设置阴影为0.0
        ),
      ),
      backgroundColor: AppColors.colorF1F4FA,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 20,
            left: 12,
            right: 12,
          ),
          child: Column(
            children: _menuData.map((menuItem) {
              if (menuItem.display == true) {
                return Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    right: 30,
                    left: 20,
                    bottom: 20,
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor, // 背景颜色
                    borderRadius: BorderRadius.circular(5), // 圆角
                  ),
                  child: InkWell(
                    onTap: () {
                      _handleTap(menuItem.path!);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              _icon(
                                menuItem.icon,
                              ),
                              size: 20,
                              color: AppColors.color43474E,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              menuItem.title!,
                              style: const TextStyle(
                                color: AppColors.color1A1C1E,
                                fontSize: 16,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_right,
                          color: AppColors.color1A1C1E,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Text('');
              }
            }).toList(),
          ),
        ),
      ),
    );
  }
}
