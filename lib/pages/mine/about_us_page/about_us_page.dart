import 'dart:convert';
import 'dart:io';
import 'package:pub_semver/pub_semver.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/utils/cache_util.dart';
import 'package:yibei_app/provider/notifier_provider.dart';
import 'package:yibei_app/components/common/yb_scaffold.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/utils/toast_util.dart';
import 'package:yibei_app/routes/index.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/common/version_update/version_update.dart';
import 'package:yibei_app/models/common/version_update/version_update_data.dart';

import 'package:yibei_app/api/common.dart';

// 关于我们
class AboutUsPage extends StatefulWidget {
  const AboutUsPage({
    super.key,
  });

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  /// 当前app版本
  String _appVersion = '';

  /// 最新的app信息
  VersionUpdateData _versionUpdateInfo = VersionUpdateData();

  /// 是否更新
  bool _isUpdate = false;

  /// 当前应用信息
  queryAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  /// 获取更新信息
  queryVersionUpdate() async {
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

    // 当前应用信息
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // 需要更新的版本和当前版本对比
    Version updateVersion = Version.parse('${entity.data?.data?.version}');
    Version nowVersion = Version.parse(packageInfo.version);

    // 是否需要更新app
    if (updateVersion > nowVersion) {
      setState(() {
        _isUpdate = true;
        _versionUpdateInfo = entity.data!.data!;
      });
    }
  }

  /// 显示更新
  handleUpdateShow() async {
    if (!_isUpdate) return ToastUtil.shortToast('您使用的已是最新版本');

    // 更新的描述列表
    List<String> descriptionList = _versionUpdateInfo.description!.split("\n");

    if (context.mounted) {
      onShowAlertDialog(
        context: context,
        title: '更新提示 v${_versionUpdateInfo.version}',
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
              Uri uri = Uri.parse('${_versionUpdateInfo.downloadurl}');
              launchUrl(uri);
            },
          ),
        ],
      );
    }
  }

  /// 跳转
  handlGoto({
    required int id,
  }) {
    String route = AppRoutes.resourceContentPage;

    Navigator.pushNamed(
      context,
      route,
      arguments: {
        'courseId': 0,
        'chapterId': id,
      },
    );
  }

  /// 列表项
  Widget listItemWidget({
    required String title,
    String? tips,
    String? extras,
    String? type,
    Function? onTap,
  }) {
    return InkWell(
      onTap: () {
        if (onTap != null) onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          border: Border(
            bottom: BorderSide(
              // 设置下边框
              color: AppColors.colorF1F4FA, // 设置边框颜色
              width: 1.0, // 设置边框宽度
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '$title',
                  style: const TextStyle(
                    color: AppColors.color1A1C1E,
                    fontSize: 16,
                  ),
                ),
                if (tips != null)
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.red,
                    ),
                    child: Text(
                      '$tips',
                      style: const TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                if (extras != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: Text(
                      '$extras',
                      style: const TextStyle(
                        color: AppColors.greyColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                const Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: AppColors.greyColor,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    queryAppInfo();
    queryVersionUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return YbScaffold(
      appBarTitle: '关于易北',
      backgroundColor: AppColors.colorF1F4FA,
      bodyPadding: const EdgeInsets.all(0),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 25,
                bottom: 10,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'lib/assets/images/app_logo.png',
                  height: 100,
                ),
              ),
            ),
          ),
          Center(child: Text('当前版本：v$_appVersion')),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 300,
            child: ListView(
              children: <Widget>[
                listItemWidget(
                  title: '升级新版本',
                  tips: _isUpdate ? 'new' : null,
                  extras: _isUpdate ? 'v${_versionUpdateInfo.version}' : null,
                  onTap: () {
                    handleUpdateShow();
                  },
                ),
                listItemWidget(
                  title: '服务条款',
                  onTap: () {
                    handlGoto(id: 5);
                  },
                ),
                listItemWidget(
                  title: '隐私政策',
                  onTap: () {
                    handlGoto(id: 4);
                  },
                ),
                listItemWidget(
                    title: '联系我们',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.mineContactUs,
                      );
                    }),
                // 添加更多的列表项...
              ],
            ),
          ),
        ],
      ),
    );
  }
}
