import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/pages/home/home_page.dart';
import 'package:yibei_app/pages/course/course_list_page.dart';
import 'package:yibei_app/pages/resource/resource_page.dart';
import 'package:yibei_app/pages/mine/mine_page.dart';
import 'package:yibei_app/pages/bbs/bbs_page.dart';
import 'package:yibei_app/pages/common/login_page.dart';
import 'package:yibei_app/pages/common/Index_page.dart';
import 'package:yibei_app/pages/common/introduce_page.dart';
import 'package:provider/provider.dart';
import 'package:yibei_app/provider/notifier_provider.dart';
import 'package:yibei_app/utils/cache_util.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 当前激活的页面
  int _selectedIndex = 0;

  // 跳转  0:登录页  1:主页  2:易北简介
  int pageIndex = 0;

  // 底部TabBar的子项目
  BottomNavigationBarItem _bottomBarItem(
      int index, IconData select, IconData defaults, String name) {
    return BottomNavigationBarItem(
      icon: Container(
          width: 64,
          height: 32,
          decoration: BoxDecoration(
            color: _selectedIndex == index ? AppColors.colorCCE5FF : null,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            _selectedIndex == index ? select : defaults,
            size: 20,
          )),
      label: name,
    );
  }

  // 底部TabBar
  CupertinoTabBar _buildTabbar() => CupertinoTabBar(
        backgroundColor: AppColors.colorE4EAF5,
        currentIndex: _selectedIndex,
        border: const Border(),
        onTap: (value) => setState(() {
          _selectedIndex = value;
        }),
        height: 65,
        items: [
          _bottomBarItem(0, Icons.home, Icons.home_outlined, "首页"),
          _bottomBarItem(1, Icons.book, Icons.book_outlined, "课程"),
          _bottomBarItem(
              2, Icons.not_started, Icons.not_started_outlined, "资源"),
          _bottomBarItem(3, Icons.explore, Icons.explore_outlined, "发现 "),
          _bottomBarItem(
              4, Icons.account_circle, Icons.account_circle_outlined, "我的"),
        ],
        activeColor: AppColors.color001E31,
        inactiveColor: AppColors.color43474E,
      );

  // TabBar 对应的页面
  Widget _buildChildContent(int index) {
    switch (index) {
      case 0:
        return HomePage(); // 首页
      case 1:
        return CourseListPage(); // 课程页
      case 2:
        return ResourcePage(); // 资源
      case 3:
        return BbsPage(); // 发现
      case 4:
        return MinePage(); // 我的
      default:
        return HomePage();
    }
  }

  Widget get _getWidget {
    switch (pageIndex) {
      case 0:
        return LoginPage();

      case 1:
        return CupertinoTabScaffold(
          tabBar: _buildTabbar(),
          tabBuilder: (_, index) => _buildChildContent(index),
        );

      case 2:
        return IntroducePage(); //

      case 3:
        return IndexPage();

      default:
        return IndexPage();
    }
  }

  @override
  void initState() {
    super.initState();

    // 如果token存在，跳转到主页
    String? token = CacheUtils.instance.get<String>('token');

    // 是否已经打开过了
    bool? isFirstOpen = CacheUtils.instance.get<bool>('isAlreadyOpen');

    // 设置页面
    setState(() {
      if (token != null) {
        pageIndex = 1; // 主页
      } else if (isFirstOpen == null) {
        pageIndex = 2; // 介绍页
      } else {
        pageIndex = 3; // 首页
      }
    });

    // 全局监听 jumpPageProvider.value 值的变化
    jumpPageProvider.addListener(() {
      final index = jumpPageProvider.value;

      setState(() {
        pageIndex = index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _getWidget;
  }
}
