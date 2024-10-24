import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yibei_app/utils/colors_util.dart';

GlobalKey<_CountdownTimerState> countdownTimerGlobalKey = GlobalKey();

class CountdownTimer extends StatefulWidget {
  /// 秒数
  final int seconds;

  /// 清除定时器
  final Function? onTimerClear;

  const CountdownTimer({
    Key? key,
    required this.seconds,
    this.onTimerClear,
  }) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late int seconds = widget.seconds;

  String get _formattedTime {
    Duration duration = Duration(seconds: seconds);

    if (seconds <= 0) return '00:00:00';

    return '${(duration.inHours).toString().padLeft(2, '0')}'
        ':${(duration.inMinutes % 60).toString().padLeft(2, '0')}'
        ':${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  /// 清除定时器
  void handleTimerClear() {
    _timer.cancel();
  }

  /// 定时器完成
  void _handleTimerFinish() {
    if (widget.onTimerClear != null) {
      widget.onTimerClear!();
    }
    _timer.cancel();
  }

// 初始化组件时
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
      if (seconds <= 0) {
        _handleTimerFinish();
      }
      setState(() {
        seconds--;
      });
    });
  }

  // 销毁组件时
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formattedTime,
      style: const TextStyle(
        fontSize: 16,
        color: AppColors.color43474E,
      ),
    );
  }
}
