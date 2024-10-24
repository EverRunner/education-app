import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/utils/tools_util.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/config/config.dart';
import 'package:yibei_app/components/common/yb_button.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/course/course_chapter_data/course_chapter_data_item.dart';
import 'package:yibei_app/models/content/content_details/content_details.dart';


import 'package:yibei_app/provider/course_chapter_data_model.dart';
import 'package:yibei_app/api/content.dart';

import 'package:pod_player/pod_player.dart';

/// 资源视频
class ResourceVideoPage extends StatefulWidget {
  /// 课程id
  late int courseId;

  /// 章节id
  late int chapterId;

  ResourceVideoPage(this.courseId, this.chapterId, {Key? key})
      : super(key: key);

  @override
  State<ResourceVideoPage> createState() => _ResourceVideoPageState();
}

class _ResourceVideoPageState extends State<ResourceVideoPage> {
  /// 课程章节详情信息
  late CourseChapterDataItem? _courseChapterInfo;

  // 视频控制器
  late final PodPlayerController _videoResourceController;

  // 视频加载
  bool _videoLoading = true;

  // 是否可以弹框的标识
  bool _isShowDialog = true;

  // 是否可以弹框的标识
  String _pageTitle = '-';

  /// 获取课程详情
  _queryCourseInfo() async {
    // 如果provider中没有课程详情，就从接口用去获取
    if (_courseChapterInfo == null) {
      // 设置值详情
      await Provider.of<CourseChapterDataModel>(context, listen: false)
          .setCourseChapterDataItem(chapterId: widget.chapterId);

      // 设置值
      setState(() {
        // 再次课程详情
        _courseChapterInfo =
            Provider.of<CourseChapterDataModel>(context, listen: false)
                .getCourseChapterDataItem(widget.chapterId);
      });
    }

    setState(() {
      _pageTitle = _courseChapterInfo?.title ?? '-';
    });

    // 初始化视频
    videoPlayInit(videoUrl: _courseChapterInfo!.videopath!);
  }

  /// 获取文章详情
  _queryContentInfo() async {
    BaseEntity<ContentDetails> entity = await getContentDetails(
      id: widget.chapterId,
    );
    if (entity.data?.status != true || entity.data?.data?.description == null) {
      return;
    }

    setState(() {
      _pageTitle = entity.data?.data?.title ?? '-';
    });

    // 初始化视频
    videoPlayInit(videoUrl: entity.data!.data!.description!);
  }

  /// 处理跳转
  _handleGoto() {
    Navigator.of(context).pop();
  }

  /// 处理播放完成后的弹窗
  _handleShowVideoDialog() {
    onShowVideoDialog(
      context: context,
      isHorizontal: _videoResourceController.isFullScreen,
      barrierDismissible: true,
      isShowFinishButton: false,

      // 退出全屏
      onExitFullScreen: () {
        _videoResourceController.disableFullScreen(context);
        // 2秒后现调用弹窗
        Future.delayed(const Duration(seconds: 2), () {
          _handleShowVideoDialog();
        });
      },

      // 完成，下一步
      onFinish: () {},

      // 重新播放
      onReplay: () {
        _isShowDialog = false;
        // 视频播放重置
        _videoResourceController.videoSeekTo(const Duration(seconds: 1));
        // 视频暂停
        _videoResourceController.pause();
        // 视频播放
        _videoResourceController.play();
        Future.delayed(const Duration(seconds: 2), () {
          _isShowDialog = true;
        });
      },
    );
  }

  /// 视频播放初始化
  /// [videoUrl] 视频的地址
  videoPlayInit({
    required String videoUrl,
  }) {
    // 使用正则获取视频的id
    final pattern = RegExp(r'\/video\/(\d+)');
    final match = pattern.firstMatch(videoUrl);
    final videoId = match?.group(1);
    if (videoId == null || videoId == '') return;

    final Map<String, String> headers = <String, String>{};
    headers['Authorization'] = 'Bearer ${Config.vimeo_access_token}';
    setState(() {
      _videoResourceController = PodPlayerController(
        playVideoFrom: PlayVideoFrom.vimeoPrivateVideos(
          videoId,
          httpHeaders: headers,
        ),
      )..initialise();
      _videoLoading = false;
    });

    /// 节流 3秒钟只执行一次
    final throttledDoSomething = ToolsUtil.throttle(
      _handleShowVideoDialog,
      const Duration(seconds: 3),
    );

    // 视频监听函数（判断是否播放完成）
    const oneSecond = Duration(seconds: 1); // 1秒钟
    _videoResourceController.addListener(() {
      // 剩余时间
      final timeRemaining = _videoResourceController.totalVideoLength -
          _videoResourceController.currentVideoPosition;
      if (timeRemaining <= oneSecond && _isShowDialog) {
        throttledDoSomething();
      }
    });
  }

  @override
  void initState() {
    // 设置值
    setState(() {
      // 课程章节详情信息
      _courseChapterInfo =
          Provider.of<CourseChapterDataModel>(context, listen: false)
              .getCourseChapterDataItem(widget.chapterId);
    });

    if (widget.courseId == 0) {
      _queryContentInfo();
    } else {
      _queryCourseInfo();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 18,
          ),
          onPressed: _handleGoto,
        ),
        backgroundColor: AppColors.blackColor,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _pageTitle,
            style: const TextStyle(
              color: AppColors.whiteColor,
              fontSize: 16,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: AppColors.blackColor,
        child: _videoLoading == false
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PodVideoPlayer(controller: _videoResourceController),
                  const SizedBox(height: 40),
                  YbButton(
                    text: '横向全屏播放',
                    icon: Icons.open_in_full,
                    borderColor: AppColors.whiteColor,
                    backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
                    circle: 50,
                    onPressed: () {
                      // 全屏
                      if (_videoResourceController != null) {
                        _videoResourceController.enableFullScreen();
                      }
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              )
            : Text('视频加载中...'),
      ),
    );
  }

  @override
  void dispose() {
    // 如果视频控制器已经初始化，则释放资源
    if (_videoLoading == false) {
      _videoResourceController?.dispose();
    }

    super.dispose();
  }
}
