import 'dart:convert';
import 'dart:io';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yibei_app/utils/cache_util.dart';
import 'package:yibei_app/utils/colors_util.dart';

import 'free_record.dart';
import 'already_buy_record.dart';
import 'package:yibei_app/provider/course_chapter_tree_model.dart';
import 'package:yibei_app/provider/user_progress_model.dart';
import 'package:yibei_app/provider/test_detail_logs_model.dart';
import 'package:yibei_app/models/user/login_user_info/user_info.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/components/common/yb_button.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/common/version_update/version_update.dart';

import 'package:yibei_app/api/common.dart';

// 首页
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// 获取课程、章节列表
  Future<void> _setCourseChapterList(CourseChapterTreeModel model) async {
    await model.setCourseChapterList();
  }

  /// 获取学习进度（付费）
  Future<void> _setUserProgress(UserProgressModel model) async {
    // 获取用户信息的缓存
    UserInfo? userInfo = CacheUtils.instance.get<UserInfo>('userInfo');

    await model.setUserProgress(userInfo?.level ?? 0, showLoading: false);

    // 用户学习完成后，
    var userProgress = Provider.of<UserProgressModel>(context, listen: false)
        .getUserProgressData;
    if (userProgress.status == 1) {
      _setTestDetailLogs();
    }
  }

  /// 获取综合、错误、高频错题记录
  Future<void> _setTestDetailLogs() async {
    final testDetailLogsModel =
        Provider.of<TestDetailLogsModel>(context, listen: false);
    testDetailLogsModel.setTestDetailLogs();
  }

  /// 显示更新
  showUpdate() async {
    String os = Platform.operatingSystem;
    String platform = 'ios';

    // 判断系统类型
    if (os == 'android') {
      platform = 'android';
    }

    BaseEntity<VersionUpdate> entity =
        await getVersionUpdate(platform: platform);
    if (entity.data?.status != true || entity.data?.data?.version == null)
      return;

    // 需要更新的版本信息
    final versionUpdateInfo = entity.data!.data;

    // 当前应用信息
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // 需要更新的版本和当前版本对比
    Version updateVersion = Version.parse('${versionUpdateInfo!.version}');
    Version nowVersion = Version.parse('${packageInfo.version}');

    // 更新的描述列表
    List<String> descriptionList = versionUpdateInfo.description!.split("\n");

    if (context.mounted && updateVersion > nowVersion) {
      onShowAlertDialog(
        context: context,
        title: '更新提示 v${versionUpdateInfo.version}',
        detail: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 垂直方向上自适应文本内容高度
            crossAxisAlignment: CrossAxisAlignment.start,
            children: descriptionList
                .map((text) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        actions: [
          if (versionUpdateInfo.isforceupdate == 0)
            TextButton(
              child: const Text(
                '关闭',
                style: TextStyle(color: AppColors.color8D9199),
              ),
              onPressed: () {
                Navigator.pop(context); // 关闭弹窗
              },
            ),
          YbButton(
            text: '去更新',
            circle: 25,
            onPressed: () {
              // 跳转去 App Store 下载
              Uri uri = Uri.parse('${versionUpdateInfo.downloadurl}');
              launchUrl(uri);
            },
          ),
        ],
      );
    }
  }

  Future _onRefresh() async {
    final userProgressModel =
        Provider.of<UserProgressModel>(context, listen: false);
    await _setUserProgress(userProgressModel);
  }

  @override
  void initState() {
    super.initState();

    // CacheUtils.instance
    //     .set<String>('token', '38fd291ce88f9b67f6254defa75a628f');

    () async {
      final courseChapterTreeModel =
          Provider.of<CourseChapterTreeModel>(context, listen: false);
      final userProgressModel =
          Provider.of<UserProgressModel>(context, listen: false);

      await _setCourseChapterList(courseChapterTreeModel);
      await _setUserProgress(userProgressModel);
      showUpdate();
    }();
  }

  @override
  Widget build(BuildContext context) {
    // 获取用户信息的缓存
    UserInfo? userInfo = CacheUtils.instance.get<UserInfo>('userInfo');

    // 当前日期
    DateTime currentDate = DateTime.now();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // 设置为0表示不显示AppBar
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0, // 设置阴影为0.0
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: (userInfo?.level == 1 &&
                  !currentDate.isAfter(userInfo?.endhydate ?? currentDate))
              ? AlreadyBuyRecord()
              : FreeRecord(),
        ),
      ),
    );
  }
}
