import 'package:flutter/material.dart';

class YbCircularSizedBox extends StatelessWidget {
  final double radius;
  final Color color;

  const YbCircularSizedBox({
    Key? key,
    required this.radius,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
