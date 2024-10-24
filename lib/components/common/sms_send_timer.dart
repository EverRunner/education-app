import 'package:flutter/material.dart';
import 'dart:async';

import 'package:yibei_app/utils/colors_util.dart';

/// 父组件可获取该值，操作子组件的函数
GlobalKey<_SmsSendTimerState> smsSendTimerKey = GlobalKey();

class SmsSendTimer extends StatefulWidget {
  final int countdownTime;
  final Function sendCallback;

  const SmsSendTimer({
    super.key,
    this.countdownTime = 60,
    required this.sendCallback,
  });

  @override
  State<SmsSendTimer> createState() => _SmsSendTimerState();
}

class _SmsSendTimerState extends State<SmsSendTimer> {
  Timer? _timer;

  // 倒计时
  late int _countdownTime;

  // 倒计时是否开始
  bool isStart = false;

  /// 倒计时
  startTimer() {
    setState(() {
      isStart = true;
    });

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_countdownTime < 1) {
            timer.cancel();
            _countdownTime = 60;
            isStart = false;
          } else {
            _countdownTime = _countdownTime - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _countdownTime = widget.countdownTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (isStart) return;

        widget.sendCallback();
        startTimer();
      },
      child: Text(
        !isStart ? '重新寄送' : '重新寄送（${_countdownTime}s）',
        style: TextStyle(
          color: !isStart ? AppColors.primaryColor : AppColors.color74777F,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }
}
