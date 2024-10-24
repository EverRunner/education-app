import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:yibei_app/utils/cache_util.dart';
import 'package:yibei_app/models/bbs/bbs_type_item/bbs_type_item.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/models/user/login_user_info/user_info.dart';
import 'package:yibei_app/config/config.dart';

import 'package:yibei_app/provider/notifier_provider.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/bbs/post_details/post_details.dart';
import 'package:yibei_app/models/bbs/post_details/post_details_data.dart';

import 'package:yibei_app/api/bbs.dart';

class BbsDetailsPage extends StatefulWidget {
  /// 文章id
  late int artId;

  BbsDetailsPage(this.artId, {Key? key}) : super(key: key);

  @override
  State<BbsDetailsPage> createState() => _BbsDetailsPageState();
}

class _BbsDetailsPageState extends State<BbsDetailsPage> {
  Timer? _timer;

  // 轮播图的按钮控制器
  final CarouselController _carouselSlider = CarouselController();

  // 图片列表
  List<String> _imageList = [];

  // 图片列表
  PostDetailsData _details = PostDetailsData();

  /// 处理跳转
  _handleGoto() {
    Navigator.of(context).pop();
  }

  /// 获取帖子详情
  _queryDetails() async {
    BaseEntity<PostDetails> entity = await getPostDetails(artid: widget.artId);
    if (entity.data?.status != true) {
      return;
    }
    setState(() {
      _details = entity.data!.data!;
      _imageList = entity.data?.data?.images != null
          ? entity.data?.data?.images.split(',')
          : [];
    });
  }

  /// 处理点击事件
  void _handleTap() {
    Navigator.pushNamed(
      context,
      AppRoutes.bbsAuthorDetailsPage,
      arguments: {
        'authorId': _details.memberid,
      },
    );
  }

  /// 信息项 Widget
  Widget itemInfoWidget({
    required IconData icon,
    required String title,
    String content = '',
    Widget? extraWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: AppColors.colorF1F0F4,
          thickness: 1.0,
          height: 1.0,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.color8D9199,
              size: 12,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.color74777F,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.color1A1C1E,
            height: 1.7,
            fontWeight: FontWeight.bold,
          ),
        ),

        // 额外的内容
        if (extraWidget != null) extraWidget,
        const SizedBox(height: 16),
      ],
    );
  }

  // 当前页
  int _current = 0;

  /// 图片加载中显示的widget
  Widget _imagePlaceholder() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
        ],
      ),
    );
  }

  /// 处理点赞
  void _handleLike() {
    setState(() {
      _details.likecount = _details.islike == 1
          ? _details.likecount! - 1
          : _details.likecount! + 1;
      _details.islike = _details.islike == 1 ? 0 : 1;
    });
    setPostLike(id: widget.artId);
  }

  /// 关注作者
  void _handleLikeAuthor() {
    setState(() {
      _details.islikeuser = _details.islikeuser == 1 ? 0 : 1;
    });
    setAuthorLike(authorId: _details.memberid!);
  }

  /// 停留3秒后，增加浏览记录
  void _handleaddPostbrowse() {
    const duration = Duration(seconds: 3);
    _timer = Timer(duration, () {
      addPostbrowse(artid: widget.artId);
    });
  }

  @override
  void initState() {
    super.initState();

    _queryDetails();
    _handleaddPostbrowse();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            size: 24,
            color: AppColors.color43474E,
          ),
          onPressed: _handleGoto,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.color1A1C1E,
          size: 18,
        ),
        backgroundColor: AppColors.whiteColor,
        elevation: 0, // 取消阴影
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '帖子内容',
            style: TextStyle(
              color: AppColors.color1A1C1E,
              fontSize: 16,
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头部
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: _handleTap,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: _details.yibeiMember?.avatar == null
                              ? Image.asset(
                                  'lib/assets/images/head_avatar_default.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  _details.yibeiMember?.avatar.contains('https')
                                      ? '${_details.yibeiMember?.avatar}'
                                      : '${Config.file_root}${_details.yibeiMember?.avatar}',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _details.yibeiMember?.username ?? "-",
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.color1A1C1E,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_details.postcount ?? 1} 则帖子',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.color74777F,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _details.islikeuser == 1
                      ? InkWell(
                          onTap: _handleLikeAuthor,
                          child: Container(
                            height: 34,
                            width: 75,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.colorEEEFF3,
                            ),
                            child: const Text(
                              '已关注',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.color8D9199,
                              ),
                            ),
                          ),
                        )
                      : YbButton(
                          text: '关注作者',
                          textColor: AppColors.color74777F,
                          icon: Icons.add,
                          circle: 30,
                          height: 34,
                          borderColor: AppColors.color74777F,
                          backgroundColor: AppColors.whiteColor,
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          onPressed: _handleLikeAuthor,
                        ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(
                color: AppColors.colorF1F0F4,
                thickness: 1.0,
                height: 1.0,
              ),
              const SizedBox(height: 16),

              // 轮播图
              CarouselSlider(
                items: _imageList.map((url) {
                  return CachedNetworkImage(
                    fit: BoxFit.cover, // 设置图片适应方式
                    imageUrl: '${Config.file_root}$url',
                    placeholder: (context, url) =>
                        _imagePlaceholder(), // 加载中显示的widget
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error), // 加载失败显示的widget
                  );
                }).toList(),
                carouselController: _carouselSlider,
                options: CarouselOptions(
                  height: 300.0,
                  enlargeCenterPage: false,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _imageList.map((url) {
                  int index = _imageList.indexOf(url);
                  return Container(
                    width: 6.0,
                    height: 6.0,
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? AppColors.color43474E
                          : AppColors.colorC3C6CF,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // 标题
              Text(
                _details.title ?? "-",
                style: const TextStyle(
                  fontSize: 28,
                  color: AppColors.color1A1C1E,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '浏览次数：${_details.browsecount ?? 0}次',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.color74777F,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 1.0, // 设置竖线的宽度
                    height: 12, // 设置竖线的高度为无限大，以填充整个父容器
                    color: AppColors.colorE0E2EC, // 设置竖线的颜色为灰色
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '发布日期：${_details?.createdAt?.year ?? ''}/${_details?.createdAt?.month ?? ''}/${_details?.createdAt?.day ?? ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.color74777F,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  YbButton(
                    text: '${_details.likecount ?? "0"}',
                    circle: 20,
                    icon: _details.islike == 1
                        ? Icons.favorite_rounded
                        : Icons.favorite_border,
                    iconColor: _details.islike == 1
                        ? AppColors.colorFF5449
                        : AppColors.color76777A,
                    backgroundColor: AppColors.colorEBF0F8,
                    borderColor: AppColors.colorEBF0F8,
                    textColor: AppColors.color001E31, // AppColors.colorFF5449
                    onPressed: _handleLike,
                  ),
                  const SizedBox(width: 8),
                  // YbButton(
                  //   text: '转发',
                  //   circle: 20,
                  //   icon: Icons.open_in_new,
                  //   backgroundColor: AppColors.colorEBF0F8,
                  //   borderColor: AppColors.colorEBF0F8,
                  //   textColor: AppColors.color001E31,
                  //   onPressed: () {},
                  // ),
                ],
              ),
              const SizedBox(height: 16),

              itemInfoWidget(
                icon: Icons.info_outline,
                title: '内容',
                content: '${_details.content ?? '-'}',
              ),
              itemInfoWidget(
                icon: Icons.room_outlined,
                title: '位置',
                content: '${_details.location ?? "-"}',
              ),
              itemInfoWidget(
                icon: Icons.perm_phone_msg_outlined,
                title: '电话',
                content: '${_details.contact ?? "-"}',
                extraWidget: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    '${_details.contactnumber ?? "-"}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.colorBA1A1A,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
