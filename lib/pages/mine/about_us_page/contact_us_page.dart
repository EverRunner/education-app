import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:yibei_app/components/common/yb_scaffold.dart';
import 'package:clipboard/clipboard.dart';

import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/utils/tools_util.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/config/config.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/utils/toast_util.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/course/study_const/study_const.dart';
import 'package:yibei_app/models/course/user_progress/progress.dart';
import 'package:yibei_app/models/course/course_chapter_step/course_chapter_step.dart';
import 'package:yibei_app/models/course/current_chapter_progress/current_chapter_progress.dart';
import 'package:yibei_app/models/course/course_chapter_data/course_chapter_data_item.dart';
import 'package:yibei_app/models/common/common_return_states/common_return_states.dart';
import 'package:yibei_app/models/course/course_chapter_set_next/course_chapter_set_next.dart';
import 'package:yibei_app/models/content/content_details/content_details.dart';
import 'package:yibei_app/models/content/content_details/content_details_data.dart';

import 'package:yibei_app/provider/user_progress_model.dart';
import 'package:yibei_app/provider/course_chapter_data_model.dart';

import 'package:yibei_app/api/course.dart';
import 'package:yibei_app/api/user.dart';
import 'package:yibei_app/api/content.dart';

import 'package:pod_player/pod_player.dart';

/// 联系我们
class ContactUsPage extends StatefulWidget {
  ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ResourceVideoPageState();
}

class _ResourceVideoPageState extends State<ContactUsPage> {
  /// 文本tWidget
  Widget textWidget({
    required String title,
    required String value,
    bool isPhone = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${title}：',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.color1A1C1E,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              if (isPhone) {
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: value,
                );
                await launchUrl(launchUri);
              } else {
                FlutterClipboard.copy(value).then((val) {
                  ToastUtil.shortToast('$title，复制成功！');
                });
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YbScaffold(
      appBarTitle: '联系我们',
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image.asset(
              'lib/assets/images/qr_code.png',
              height: 150,
            ),
            const SizedBox(height: 30),
            textWidget(
              title: '张老师微信',
              value: 'ybmblex',
            ),
            textWidget(
              title: '联络号码',
              value: '(702) 892-7688',
              isPhone: true,
            ),
            textWidget(
              title: '电子邮件',
              value: 'usual.rain3325@fastmail.com',
            ),
            textWidget(
              title: '地址',
              value: 'P.O. Box 30613 Las Vegas, NV 89173',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
