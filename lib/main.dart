import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yibei_app/provider/course_chapter_tree_model.dart';
import 'package:yibei_app/provider/course_chapter_data_model.dart';
import 'package:yibei_app/provider/user_progress_model.dart';
import 'package:yibei_app/provider/test_detail_logs_model.dart';

// import 'package:flutter_config/flutter_config.dart';

import 'package:yibei_app/config/config.dart';
import 'package:yibei_app/config/config_prod.dart' as prod;
import 'package:yibei_app/config/config_dev.dart' as dev;
import 'pages/main/main_page.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/pages/common/not_Found_Page.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:flutter/services.dart';
import 'package:yibei_app/utils/http/http.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:yibei_app/utils/custom_animation.dart';
import 'package:yibei_app/utils/cache_util.dart';

void main() async {
  // 根据当前的运行环境，调用不同的配置
  if (const String.fromEnvironment('APP_ENV') == 'dev') {
    Config.base_url = dev.Config.base_url;
    Config.debug_enabled = dev.Config.debug_enabled;
    Config.file_root = dev.Config.file_root;
  } else {
    Config.base_url = prod.Config.base_url;
    Config.debug_enabled = prod.Config.debug_enabled;
    Config.file_root = prod.Config.file_root;
  }

  // 确保引擎已经初始化完成
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化缓存工具类
  await CacheUtils.instance.init();

  // 设置 EasyLoading 的配置
  configLoading();

  // 添加请求拦截器
  HttpUtil.addInterceptors();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // 顶部设置状态栏背景颜色
    // statusBarIconBrightness: Brightness.dark, // 设置状态栏文本颜色为暗色
    // systemNavigationBarColor: Colors.white, // 底部导航颜色
    // systemNavigationBarDividerColor: null,
    // systemNavigationBarIconBrightness: Brightness.dark, // 底部导航图标颜色
  ));

  // 初始化
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CourseChapterTreeModel()),
        ChangeNotifierProvider(create: (context) => UserProgressModel()),
        ChangeNotifierProvider(create: (context) => CourseChapterDataModel()),
        ChangeNotifierProvider(create: (context) => TestDetailLogsModel())
      ],
      child: MaterialApp(
        // debugShowCheckedModeBanner: Config.debugEnabled, // 显示debug弹窗
        debugShowCheckedModeBanner: false, // 显示debug弹窗
        title: Config.app_name,
        theme: ThemeData(
          // 自定义主题颜色
          primarySwatch: AppThemeColor.primarySwatch,
          scaffoldBackgroundColor: Colors.white, // 设置全局 scaffold 背景色
        ),
        // routes: MyAppRoutes.getRoutes,
        // onGenerateRoute: (RouteSettings settings) => {},
        initialRoute: AppRoutes.main,
        onGenerateRoute: (RouteSettings settings) {
          final routes = AppRoutes.getRoutes();
          final builder = routes[settings.name];

          // print('打印routes的值：---  ${settings.name}'); // 打印routes的值

          return MaterialPageRoute(
            builder: builder!,
            settings: settings,
          );
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (context) => const NotFoundPage(),
            settings: settings,
          );
        },
        // SafeArea 自动根据当前设备类型和屏幕方向计算出安全区域
        home: MainPage(),

        // 初始化EasyLoading
        builder: EasyLoading.init(),
      ),
    );
  }
}

// 设置 EasyLoading 的配置
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..maskType = EasyLoadingMaskType.black
    ..customAnimation = CustomAnimation();
}
