import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/utils/tools_util.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/config/config.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/components/common/yb_button.dart';

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

/// 资源文章、服务条款、隐私政策等文章
class ResourceContentPage extends StatefulWidget {
  /// 课程id
  late int courseId;

  /// 章节id
  late int chapterId;

  ResourceContentPage(this.courseId, this.chapterId, {Key? key})
      : super(key: key);

  @override
  State<ResourceContentPage> createState() => _ResourceVideoPageState();
}

class _ResourceVideoPageState extends State<ResourceContentPage> {
  // 是否可以弹框的标识
  ContentDetailsData _contentInfo = ContentDetailsData(
    title: '-',
    content: '加载中...',
  );

  /// 获取文章详情
  _queryContentInfo() async {
    BaseEntity<ContentDetails> entity = await getContentDetails(
      id: widget.chapterId,
    );
    if (entity.data?.status != true || entity.data?.data == null) {
      return;
    }

    setState(() {
      _contentInfo = entity.data!.data!;
    });
  }

  /// 处理跳转
  _handleGoto() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _queryContentInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 18,
            color: AppColors.blackColor,
          ),
          onPressed: _handleGoto,
        ),
        backgroundColor: AppColors.whiteColor,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${_contentInfo.title}',
            style: const TextStyle(
              color: AppColors.blackColor,
              fontSize: 16,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          color: AppColors.whiteColor,
          child: Html(
            data: _contentInfo.content,
            style: {
              "body": Style(
                fontSize: FontSize(16),
                lineHeight: const LineHeight(1.5),
                color: AppColors.color1A1C1E,
              ),
              // 'img': Style(
              //   width: Width.auto(),
              // ),
            },
            onLinkTap: (url, attributes, element) {
              if (url != null) {
                Uri uri = Uri.parse(url);
                launchUrl(uri); // 使用默认浏览器打开链接
              }
            },
            //  imgMaxWidth: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
