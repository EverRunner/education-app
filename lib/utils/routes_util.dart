import 'package:yibei_app/routes/index.dart';
import 'package:flutter/material.dart';

/// 路由相关的工具类
class RoutesUtil {
  /// 传递一个新的路由替换当前页面
  /// [context] 页面上下文
  /// [routeName] 路由名字
  /// [arguments] 参数
  static void pushReplacement({
    required BuildContext context,
    required String routeName,
    Map<String, dynamic>? arguments,
  }) {
    final route = AppRoutes.getRoutes()[routeName];

    debugPrint(arguments.toString());
    if (route != null && route is Widget Function(BuildContext)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: route,
          settings: RouteSettings(arguments: arguments),
        ),
      );
    }
  }
}
