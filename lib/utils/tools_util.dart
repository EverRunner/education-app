import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:yibei_app/models/course/course_chapter_step/course_chapter_step.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/api/user.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// 工具类
class ToolsUtil {
  /// 调整步骤顺序
  static int adjustmentStepSort({
    required int step,
  }) {
    // 真实的step为：
    // "-1": "未开始",
    //  0: "视频课程",
    //  1: "中英文关键词卡",
    //  2: "英文关键词卡",
    //  3: "章节测试",
    //  4: "已完成此章节",
    //  5: "中英文关键词测试",
    //  6: "英文关键词测试",

    // 虚拟的step为：
    //  0: "视频课程",
    //  1: "中英文关键词卡",
    //  2: "中英文关键词测试",
    //  3: "英文关键词卡",
    //  4: "英文关键词测试",
    //  5: "章节测试",

    switch (step) {
      case 0:
        return 0;

      case 1:
        return 1;

      case 2:
        return 3;

      case 3:
        return 5;

      case 4:
        return 6;

      case 5:
        return 2;

      case 6:
        return 4;

      default:
        return 0;
    }
  }

  List<CourseChapterStep> courseChapterStepData = [
    CourseChapterStep(
      index: 0,
      progress: 0,
      title: "视频课程",
      route: AppRoutes.studyVideo,
    ),
    CourseChapterStep(
      index: 1,
      progress: 0,
      title: "中英文关键词卡",
      route: AppRoutes.studyWordChEn,
    ),
    CourseChapterStep(
      index: 2,
      progress: 0,
      title: "中英文关键词测试",
      route: AppRoutes.studyWordTestChEn,
    ),
    CourseChapterStep(
      index: 3,
      progress: 0,
      title: "英文关键词卡",
      route: AppRoutes.studyWordEn,
    ),
    CourseChapterStep(
      index: 4,
      progress: 0,
      title: "英文关键词测试",
      route: AppRoutes.studyWordTestEn,
    ),
    CourseChapterStep(
      index: 5,
      progress: 0,
      title: "章节测试",
      route: AppRoutes.studyTest,
    ),
  ];

  /// Final章节的步骤列表
  List<CourseChapterStep> courseChapterFinalStepData = [
    CourseChapterStep(
      index: 4,
      progress: 1,
      title: "关键词测试",
      route: AppRoutes.studyWordFinalTest,
    ),
    CourseChapterStep(
      index: 6,
      progress: 0,
      title: "章节测试",
      route: AppRoutes.studyTest,
    ),
  ];

  /// 综合测试、我的错题、高频、应变的步骤列表
  List<CourseChapterStep> courseCompoundStepData = [
    CourseChapterStep(
      index: 4,
      progress: 1,
      title: "关键词测试",
      route: AppRoutes.studyCompoundWordTestPage,
    ),
    CourseChapterStep(
      index: 5,
      progress: 0,
      title: "章节测试",
      route: AppRoutes.studyCompoundTestPage,
    ),
  ];

  /// 计算章节的步骤
  /// [chapterProgress] 当前章节的进度条
  /// [chapterId] 当前章节的id
  /// [currentCourseChapterId] 当前进度的章节号
  /// [stepFlag] 当前进度的步骤
  static List<CourseChapterStep> courseChapterStep({
    required int chapterProgress,
    required int chapterId,
    required int currentCourseChapterId,
    required int stepFlag,
    required List<CourseChapterStep> stepData,
  }) {
    // 章节进度为100时，所有步骤学习完成
    if (chapterProgress == 100) {
      for (var stepItem in stepData) {
        stepItem.progress = 100;
      }
    } else {
      final int newStepFlag = adjustmentStepSort(step: stepFlag);
      if (currentCourseChapterId == chapterId) {
        for (var stepItem in stepData) {
          // 视频课程
          if (stepItem.index == 0) {
            if (newStepFlag > 0) {
              stepItem.progress = 100;
            } else if (newStepFlag == 0) {
              stepItem.progress = 1;
            }
          }
          // 中英文关键词卡
          if (stepItem.index == 1) {
            if (newStepFlag > 1) {
              stepItem.progress = 100;
            } else if (newStepFlag == 1) {
              stepItem.progress = 1;
            }
          }
          // 中英文关键词测试
          if (stepItem.index == 2) {
            if (newStepFlag > 2) {
              stepItem.progress = 100;
            } else if (newStepFlag == 2) {
              stepItem.progress = 1;
            }
          }
          // 英文关键词卡
          if (stepItem.index == 3) {
            if (newStepFlag > 3) {
              stepItem.progress = 100;
            } else if (newStepFlag == 3) {
              stepItem.progress = 1;
            }
          }
          // 英文关键词测试
          if (stepItem.index == 4) {
            if (newStepFlag > 4) {
              stepItem.progress = 100;
            } else if (newStepFlag == 4) {
              stepItem.progress = 1;
            }
          }
          // 章节测试
          if (stepItem.index == 5) {
            if (newStepFlag == 5) {
              stepItem.progress = 1;
            }
          }
        }
      }
    }
    return stepData;
  }

  /// 节流函数
  /// [function] 执行的函数
  /// [delay] 时间
  static Function throttle(Function function, Duration delay) {
    bool isThrottled = false;

    return () {
      if (isThrottled) {
        return;
      }

      isThrottled = true;
      function();

      Timer(delay, () {
        isThrottled = false;
      });
    };
  }

  /// 防抖函数
  /// [function] 执行的函数
  /// [delay] 时间
  static Function debounce(Function function, Duration delay) {
    Timer? timer;

    return () {
      if (timer != null) {
        timer?.cancel();
      }
      timer = Timer(delay, () {
        function();
      });
    };
  }

  /// 去掉文本中的html标签、把&nbsp;替换成空格、去除中文字符
  /// [textHtml] html文本
  /// [isRemoveChinese] 是否去掉中文
  static String removeHtmlTags({
    required String textHtml,
    bool isRemoveChinese = false,
  }) {
    // 去除HTML标签
    String text = textHtml.replaceAll(RegExp(r'<[^>]*>'), '');

    // 替换&nbsp;为空格
    text = text.replaceAll('&nbsp;', ' ');

    // 去除中文字符
    if (isRemoveChinese) {
      text = text.replaceAll(RegExp(r'[^\x00-\xff]'), '');
    }

    return text;
  }

  /// 计算两个时间之差，并转换为时分秒的格式
  /// [startTime] 开始时间
  /// [endTime] 结束时间
  static String formatDuration({
    required DateTime startTime,
    required DateTime endTime,
  }) {
    Duration duration = endTime.difference(startTime);

    String hours = duration.inHours.toString().padLeft(2, '0');
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

  /// 格式化秒数为 xx天xx时xx分xx秒
  /// [seconds] 开始时间
  static String formatSeconds({
    required int seconds,
  }) {
    int days = (seconds ~/ (24 * 60 * 60));
    int hours = (seconds % (24 * 60 * 60)) ~/ (60 * 60);
    int minutes = ((seconds % (24 * 60 * 60)) % (60 * 60)) ~/ 60;

    String formattedTime = '';

    if (days > 0) {
      formattedTime += '$days天';
    }

    if (hours > 0) {
      formattedTime += '$hours小时';
    }

    if (minutes > 0) {
      formattedTime += '$minutes分';
    }

    return formattedTime;
  }

  /// 校验密码长度为6至16位
  /// [password] 密码
  static bool isValidPassword(String password) {
    RegExp regExp = RegExp(r'^.{6,16}$');
    return regExp.hasMatch(password);
  }

  /// 去掉HTML标签、去掉空格、去掉-、去掉\n
  /// [str] 字符串
  static String replaceLabel(String str) {
    RegExp reg = RegExp(r'</?[^>]+(>|$)');
    str = str.replaceAll(reg, ''); // 替换HTML标签
    str = str.replaceAll('&nbsp;', ''); // 替换HTML空格
    str = str.replaceAll(RegExp(r'\s+'), ''); // 替换所有空格
    str = str.replaceAll(RegExp(r'\r\n'), ''); // 替换\r\n
    str = str.replaceAll(RegExp(r'\n'), ''); // 替换\n
    str = str.replaceAll('-', ''); // 替换-
    str = str.replaceAll(RegExp(r'[\u4e00-\u9fa5]'), ''); // 过滤掉所有中文
    str = str.toLowerCase(); //转为小写
    return str;
  }

  /// 判断两个字符串，是否存在包含关系
  ///  1. the 开头，"Sympathetic nervous system 交感神经系统"  ==  "the sympathetic nervous system 交感神经系统"
  ///  2. 大小写， "Span"  == "span"
  ///  3. x单字，"Spleen 脾脏"  == "Spleen 脾"
  static bool checkContain(String strA, String strB) {
    String str1 = replaceLabel(strA);
    String str2 = replaceLabel(strB);

    if (str1.contains(str2) || str2.contains(str1)) {
      return true;
    }
    return false;
  }
}

/// 获取当前设备信息
Future<Map<String, dynamic>> getDeviceDetails() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = {};

  try {
    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      deviceData['platform'] = 'android';
      deviceData['model'] = androidInfo.model;
      deviceData['manufacturer'] = androidInfo.manufacturer;
      deviceData['androidVersion'] = androidInfo.version.release;
      deviceData['sdkVersion'] = androidInfo.version.sdkInt;
      deviceData['deviceId'] = androidInfo.id;
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      deviceData['platform'] = 'ios';
      deviceData['model'] = iosInfo.model;
      deviceData['manufacturer'] = 'Apple';
      deviceData['iosVersion'] = iosInfo.systemVersion;
      deviceData['deviceId'] = iosInfo.identifierForVendor;
    }
  } catch (e) {
    print(e);
  }

  return deviceData;
}
