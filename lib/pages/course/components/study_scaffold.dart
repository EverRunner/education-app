import 'package:flutter/material.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/dialog/dialog_show.dart';

import 'package:yibei_app/models/course/course_chapter_step/course_chapter_step.dart';

// 子项的类型
enum ListItemStatus {
  none,
  pass,
  underway,
}

class StudyScaffold extends StatefulWidget {
  // appBar title
  final String appBarTitle;
  final Widget? bottomNavigationBar;
  final double? bodyPadding;
  final String? courseChapterName;
  final List<CourseChapterStep> drawerStepData;
  final bool bodyCenter;

  // 主体
  final Widget body;

  const StudyScaffold({
    super.key,
    required this.appBarTitle,
    required this.body,
    this.bottomNavigationBar,
    this.bodyPadding,
    this.courseChapterName,
    required this.drawerStepData,
    this.bodyCenter = false,
  });

  @override
  State<StudyScaffold> createState() => _StudyScaffoldState();
}

class _StudyScaffoldState extends State<StudyScaffold> {
  // 全局key，这里主要是为了打开Drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 处理退出页面
  void _handleOutPage() {
    onShowAlertDialog(
      context: context,
      title: '提示',
      detail: const Text('确定要退出当前学习？'),
      actions: <Widget>[
        TextButton(
          child: const Text(
            '取消',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryColor,
            ),
          ),
          onPressed: () {
            Navigator.pop(context); // 关闭弹窗
          },
        ),
        TextButton(
          child: const Text(
            '退出',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.colorBA1A1A,
            ),
          ),
          onPressed: () {
            Navigator.pop(context); // 关闭弹窗
            Navigator.pop(context); // 退出当前页面
          },
        ),
      ],
    );
  }

  // 列表子项目
  Widget _listItem({
    bool showIcon = true,
    required String text,
    ListItemStatus status = ListItemStatus.none,
    bool isDisabled = false,
    bool isActive = false,
    String? route,
  }) {
    // 根据类型获取颜色
    Color getColorByType() {
      switch (status) {
        case ListItemStatus.pass:
          return AppColors.color43474E;
        case ListItemStatus.underway:
          return AppColors.color001E31;
        default:
          return AppColors.color74777F;
      }
    }

    // 根据类型获取图标
    IconData getIconByType() {
      switch (status) {
        case ListItemStatus.pass:
          return Icons.check_circle_outline;
        case ListItemStatus.underway:
          return Icons.tour;
        default:
          return Icons.lock_outline;
      }
    }

    return InkWell(
      // onTap: isDisabled || route == null
      //     ? () {
      //         Navigator.pop(context); // 关闭抽屉
      //       }
      //     : () {
      //         // Navigator.pushNamed(context, route);
      //         print('------跳转页面----');
      //       },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        decoration: isActive
            ? const BoxDecoration(
                color: AppColors.colorCCE5FF,
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
              )
            : null,
        child: Row(
          children: [
            if (showIcon)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  getIconByType(),
                  size: 20,
                  color: getColorByType(),
                ),
              ),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: getColorByType(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 步骤项
  List<Widget> _getDrawerStepItems({
    String? currentRoute,
  }) {
    final List<Widget> drawerSteps = [];

    for (int i = 0; i < widget.drawerStepData.length; i++) {
      final stepItem = widget.drawerStepData[i];
      final text = '步骤${i + 1} ${stepItem.title}';
      ListItemStatus status;
      if (stepItem.progress != null) {
        if (stepItem.progress! >= 100) {
          status = ListItemStatus.pass;
        } else if (stepItem.progress! >= 1 && stepItem.progress! < 100) {
          status = ListItemStatus.underway;
        } else {
          status = ListItemStatus.none;
        }
      } else {
        status = ListItemStatus.none;
      }

      drawerSteps.add(_listItem(
        text: text,
        status: status,
        isDisabled: stepItem.progress! <= 0 ? true : false,
        isActive: stepItem.route == currentRoute ? true : false,
        route: stepItem.route,
      ));
    }
    return drawerSteps.toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return WillPopScope(
      onWillPop: () async {
        _handleOutPage();
        // 返回 false，阻止直接退出应用程序
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.cancel_outlined),
              onPressed: () {
                _handleOutPage();
              },
            ),
          ],
          backgroundColor: AppColors.primaryColor,
          title: Text(
            widget.appBarTitle,
            style: const TextStyle(color: AppColors.whiteColor),
          ),
          centerTitle: true,
        ),
        drawer: Drawer(
          backgroundColor: AppColors.colorFDFCFF,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: ListView(
              children: [
                _listItem(
                  text: widget.courseChapterName ?? '-',
                  status: ListItemStatus.pass,
                  showIcon: false,
                  isDisabled: true,
                ),
                ..._getDrawerStepItems(currentRoute: currentRoute),
              ],
            ),
          ),
        ),
        body: widget.bodyCenter
            ? Center(child: widget.body)
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.all(widget.bodyPadding ?? 8.0),
                  child: widget.body,
                ),
              ),
        bottomNavigationBar: widget.bottomNavigationBar,
      ),
    );
  }
}
