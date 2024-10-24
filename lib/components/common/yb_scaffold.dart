import 'package:flutter/material.dart';
import '../../utils/colors_util.dart';

class YbScaffold extends StatefulWidget {
  // appBar title
  final String appBarTitle;

  // 主体
  final Widget body;

  // 主体
  final EdgeInsetsGeometry bodyPadding;

  // body 背景色
  final Color backgroundColor;

  const YbScaffold({
    super.key,
    required this.appBarTitle,
    required this.body,
    this.bodyPadding = const EdgeInsets.all(12.0),
    this.backgroundColor = AppColors.whiteColor,
  });

  @override
  State<YbScaffold> createState() => _YbScaffoldState();
}

class _YbScaffoldState extends State<YbScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.color1A1C1E,
          size: 18,
        ),
        backgroundColor: AppColors.colorEBF1FF,
        elevation: 0, // 取消阴影
        title: Text(
          widget.appBarTitle,
          style: const TextStyle(
            color: AppColors.color1A1C1E,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: widget.bodyPadding,
            child: widget.body,
          ),
        ),
      ),
    );
  }
}
