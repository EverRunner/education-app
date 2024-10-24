import 'package:flutter/material.dart';

// 全局颜色管理

class AppColors {
  static const Color primaryColor = Color(0xFF1D5FA6); // 定义主色调
  static const Color secondaryColor = Color(0xFFfca311); // 定义次主色调

  static const Color successColor = Color(0xFF86DC51); // 定义成功颜色
  static const Color infoColor = Color(0xFFFCA311); // 定义信息颜色
  static const Color warningColor = Color(0xFFFFBA20); // 定义警告颜色
  static const Color dangerColor = Color(0xFFBA1A1A); // 定义错误颜色

  static const Color blackColor = Color(0xFF000000); // 定义黑色
  static const Color greyColor = Color(0xFF74777F); // 定义灰色
  static const Color whiteColor = Color(0xFFFFFFFF); // 定义白色

  static const Color cleanColor = Color(0x00ffffff); // 透明

  static const Color backgroundColor = Color(0xFFF5F5F5); // 定义背景色

  static const Color colorF56C6C = Color(0XFFF56C6C);
  static const Color color67C23A = Color(0XFF67C23A);
  static const Color color004785 = Color(0XFF004785);
  static const Color color9C6F00 = Color(0XFF9C6F00);
  static const Color colorBC8700 = Color(0XFFBC8700);
  static const Color color7d5700 = Color(0XFF7d5700);
  static const Color color412d00 = Color(0XFF412d00);
  static const Color colordea000 = Color(0XFFdea000);
  static const Color colorFF5449 = Color(0XFFFF5449);

  static const Color colorBA1A1A = Color(0XFFBA1A1A);
  static const Color color2E6C00 = Color(0XFF2E6C00);
  static const Color color86DC51 = Color(0XFF86DC51);
  static const Color color2EC100 = Color(0XFF2EC100);

  static const Color color271900 = Color(0XFF271900);
  static const Color color001E31 = Color(0xFF001E31);
  static const Color color1A1C1E = Color(0xFF1A1C1E);
  static const Color color43474E = Color(0xFF43474E);
  static const Color colorC3C6CF = Color(0xFFC3C6CF);
  static const Color colorCCE5FF = Color(0xFFCCE5FF);
  static const Color colorE4EAF5 = Color(0XFFE4EAF5);
  static const Color colorF7F9FF = Color(0XFFF7F9FF);
  static const Color color74777F = Color(0XFF74777F);
  static const Color color8D9199 = Color(0XFF8D9199);
  static const Color colorFFF8F3 = Color(0XFFFFF8F3);
  static const Color colorEBF1FF = Color(0XFFEBF1FF);
  static const Color colorE0E2EC = Color(0XFFE0E2EC);
  static const Color colorE7F2FF = Color(0XFFE7F2FF);
  static const Color colorFDF6EC = Color(0XFFFDF6EC);
  static const Color colorF1F4FA = Color(0XFFF1F4FA);
  static const Color colorF1F0F4 = Color(0XFFF1F0F4);
  static const Color colorFBFCFF = Color(0XFFFBFCFF);
  static const Color colorC0C4CC = Color(0XFFC0C4CC);
  static const Color colorEEEFF3 = Color(0XFFEEEFF3);
  static const Color colorE3E2E6 = Color(0XFFE3E2E6);
  static const Color colorC7C6CA = Color(0XFFC7C6CA);
  static const Color colorF5F7FA = Color(0XFFF5F7FA);
  static const Color colorF9F9FF = Color(0XFFF9F9FF);
  static const Color colorA8A9A9 = Color(0XFFA8A9A9);
  static const Color colorECEFF5 = Color(0XFFECEFF5);
  static const Color colorEBF0F8 = Color(0XFFEBF0F8);
  static const Color colorF1F1F1 = Color(0XFFF1F1F1);
  static const Color colorCBCBCB = Color(0XFFCBCBCB);
  static const Color colorFDFCFF = Color(0XFFFDFCFF);
  static const Color colorE7EBF2 = Color(0XFFE7EBF2);
  static const Color color77ADF9 = Color(0XFF77ADF9);
  static const Color color00315E = Color(0XFF00315E);
  static const Color color7C5800 = Color(0XFF7C5800);
  static const Color colorFFEED8 = Color(0XFFFFEED8);
  static const Color colorC2C6CF = Color(0XFFC2C6CF);
  static const Color color76777A = Color(0XFF76777A);
  static const Color colorF6F6F6 = Color(0XFFF6F6F6);
}

// app 主题颜色
class AppThemeColor {
  static const MaterialColor primarySwatch = MaterialColor(
      0xFF1D5FA6, //primary value(主色调)
      <int, Color>{
        50: Color.fromRGBO(29, 95, 166, .1),
        100: Color.fromRGBO(29, 95, 166, .2),
        200: Color.fromRGBO(29, 95, 166, .3),
        300: Color.fromRGBO(29, 95, 166, .4),
        400: Color.fromRGBO(29, 95, 166, .5),
        500: Color.fromRGBO(29, 95, 166, .6), //default primary value(默认的主色调值)
        600: Color.fromRGBO(29, 95, 166, .7),
        700: Color.fromRGBO(29, 95, 166, .8),
        800: Color.fromRGBO(29, 95, 166, .9),
        900: Color.fromRGBO(29, 95, 166, 1),
      });
}

/// 处理颜色
/// 调用方法 ColorsUtil.hexStringColor('#cddc39', alpha: 0.5),
Color hexStringColor(String colorString, {double alpha = 1}) {
  final buffer = StringBuffer();
  // 如果传入的十六进制颜色值不合法，就返回默认值
  if (colorString.length != 6 && colorString.length != 7) {
    return AppColors.whiteColor;
  }

  if (colorString.length == 7) colorString = colorString.substring(1);

  buffer.write('ff');
  buffer.write(colorString);
  int color = int.parse(buffer.toString(), radix: 16);

  if (alpha >= 1) {
    alpha = 1;
  } else if (alpha <= 0) {
    alpha = 0;
  }
  return Color.fromRGBO(
      (color & 0xFF0000) >> 16, (color & 0xFF00) >> 8, (color & 0xFF), alpha);
}
