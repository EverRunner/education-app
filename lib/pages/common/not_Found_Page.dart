import 'package:flutter/material.dart';

// 404页面

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('未找到页面'),
        ),
        body: const Center(
          child: Text('未找到相关页面，返回请'),
        ),
      ),
    );
  }
}
