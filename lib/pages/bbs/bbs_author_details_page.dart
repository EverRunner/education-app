import 'package:flutter/material.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yibei_app/config/config.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:yibei_app/models/bbs/bbs_type_item/bbs_type_item.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/bbs/bbs_list/bbs_list.dart';
import 'package:yibei_app/models/bbs/bbs_list/bbs_list_row.dart';
import 'package:yibei_app/models/bbs/author_statistics_info/author_statistics_info.dart';
import 'package:yibei_app/models/bbs/author_statistics_info/author_statistics_info_data.dart';

import 'package:yibei_app/models/bbs/bbs_list/bbs_list_row.dart';

import 'package:yibei_app/api/bbs.dart';

class BbsAuthorDetailsPage extends StatefulWidget {
  /// 作者id
  late int authorId;

  BbsAuthorDetailsPage(this.authorId, {Key? key}) : super(key: key);

  @override
  State<BbsAuthorDetailsPage> createState() => _BbsAuthorDetailsPageState();
}

class _BbsAuthorDetailsPageState extends State<BbsAuthorDetailsPage> {
// 分类列表
  final List<BbsTypeItem> _typeData = [
    BbsTypeItem(
      title: '关注',
      id: '1',
      radiusType: 'left',
    ),
    BbsTypeItem(
      title: '探索',
      id: '2',
    ),
    BbsTypeItem(
      title: '附近',
      id: '3',
      radiusType: 'right',
    ),
  ];

  // 帖子列表
  List<BbsListRow> _dataBbsList = [];

  // 帖子列表总数量
  int _dataBbsCount = 0;

  AuthorStatisticsInfoData _authorInfo = AuthorStatisticsInfoData();

  /// 选中的类型
  int _pageIndex = 1;

  /// 选中的类型
  int _pageSize = 30;

  /// 处理点击事件
  void _handleTap() {
    Navigator.pushNamed(context, AppRoutes.bbsDetailsPage);
  }

  /// 处理跳转
  _handleGoto({
    required String type,
    int id = 0,
  }) {
    // switch (type) {
    //   case 'author':
    //     Navigator.pushNamed(
    //       context,
    //       AppRoutes.bbsAuthorDetailsPage,
    //       arguments: {
    //         'authorId': id,
    //       },
    //     );
    //     break;
    //   case 'details':
    //     Navigator.pushNamed(
    //       context,
    //       AppRoutes.bbsDetailsPage,
    //       arguments: {
    //         'artId': id,
    //       },
    //     );
    //     break;
    //   case 'edit':
    //     Navigator.pushNamed(context, AppRoutes.bbsEditPage);
    //     break;
    //   default:
    //     Navigator.pushNamed(
    //       context,
    //       AppRoutes.bbsDetailsPage,
    //       arguments: {
    //         'artId': id,
    //       },
    //     );
    // }

    // 在需要阻止冒泡的情况下返回true
    // return true;
  }

  /// 信息项 Widget
  Widget itemInfoWidget({
    required String num,
    required String title,
  }) {
    return Column(
      children: [
        Text(
          num,
          style: const TextStyle(
            fontSize: 32,
            color: AppColors.color43474E,
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.color74777F,
          ),
        ),
      ],
    );
  }

  /// 获取作者详情
  _queryAuthorInfo() async {
    BaseEntity<AuthorStatisticsInfo> entity = await getAuthorStatistics(
      authorId: widget.authorId,
    );
    if (entity.data?.status != true) {
      return;
    }
    setState(() {
      _authorInfo = entity.data!.data!;
    });
  }

  /// 获取帖子列表
  _queryBbsList() async {
    BaseEntity<BbsList> entity = await getBbsList(
      userId: widget.authorId,
      pageSize: _pageSize,
      pageIndex: _pageIndex,
    );
    if (entity.data?.status != true) {
      return;
    }
    setState(() {
      _dataBbsList = entity.data?.data?.rows ?? [];
      _dataBbsCount = entity.data?.data?.count ?? 0;
      _pageIndex++;
    });
  }

  /// 处理点赞
  void handleLike(int? id) {
    if (id == null) return;
    setState(() {
      _dataBbsList.forEach((item) {
        if (item.id == id) item.islike = item.islike == 1 ? 0 : 1;
      });
    });
    setPostLike(id: id);
  }

  /// 关注作者
  void _handleLikeAuthor() {
    setState(() {
      _authorInfo.islikeuser = _authorInfo.islikeuser == 1 ? 0 : 1;
      _authorInfo.likecount = _authorInfo.islikeuser == 1
          ? _authorInfo.followcount! - 1
          : _authorInfo.followcount! + 1;
    });
    setAuthorLike(authorId: widget.authorId);
  }

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

  @override
  void initState() {
    super.initState();

    _queryBbsList();
    _queryAuthorInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 24,
            color: AppColors.color43474E,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
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
            '作者个人页',
            style: TextStyle(
              color: AppColors.color1A1C1E,
              fontSize: 16,
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: _handleTap,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(78.0),
                          child: _authorInfo.avatar == null
                              ? Image.asset(
                                  'lib/assets/images/head_avatar_default.png',
                                  width: 78,
                                  height: 78,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  _authorInfo.avatar!.contains('https')
                                      ? '${_authorInfo.avatar}'
                                      : '${Config.file_root}${_authorInfo.avatar}',
                                  width: 78,
                                  height: 78,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _authorInfo.username ?? "-",
                              style: const TextStyle(
                                fontSize: 24,
                                color: AppColors.color1A1C1E,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _authorInfo.islikeuser == 1
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    onPressed: _handleLikeAuthor,
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.colorF1F0F4,
                      width: 1.0,
                    ),
                    bottom: BorderSide(
                      color: AppColors.colorF1F0F4,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    itemInfoWidget(
                        num: '${_authorInfo.followcount ?? 0}', title: '个关注者'),
                    itemInfoWidget(
                        num: '${_authorInfo.postcount ?? 0}', title: '则帖子'),
                    itemInfoWidget(
                        num: '${_authorInfo.likecount ?? 0}', title: '个点赞'),
                    itemInfoWidget(
                        num: '${_authorInfo.viewcount ?? 0}', title: '浏览次数'),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 24, bottom: 12),
                width: double.infinity,
                child: const Text(
                  '已发布帖子',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.color74777F,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 12,
                    itemCount: _dataBbsList.length, // 数据总数
                    itemBuilder: (context, index) {
                      final bbsRow = _dataBbsList[index];
                      final String imageUrl = bbsRow.images != null
                          ? Config.file_root + bbsRow.images.split(',')[0]
                          : '';

                      return Container(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                InkWell(
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(4), // 可选设置圆角
                                    child: AspectRatio(
                                      aspectRatio: 1 / 1, // 设置宽高比例为1:1
                                      child: imageUrl != ''
                                          ? CachedNetworkImage(
                                              fit: BoxFit.cover, // 设置图片适应方式
                                              imageUrl: imageUrl,
                                              placeholder: (context, url) =>
                                                  _imagePlaceholder(), // 加载中显示的widget
                                              errorWidget: (context, url,
                                                      error) =>
                                                  const Icon(Icons
                                                      .error), // 加载失败显示的widget
                                            )
                                          : const Icon(
                                              Icons
                                                  .image_not_supported_outlined,
                                              size: 50,
                                              color: AppColors.colorCBCBCB,
                                            ),
                                    ),
                                  ),
                                  onTap: () {
                                    _handleGoto(
                                      type: 'details',
                                      id: bbsRow.id!,
                                    );
                                  },
                                ),
                                Positioned(
                                  top: 8.0,
                                  right: 8.0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.blackColor.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(
                                          100.0), // 设置圆角为容器宽度的一半
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.room_outlined,
                                          size: 14,
                                          color: AppColors.whiteColor,
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          '${bbsRow.location ?? '-'}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.whiteColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              '${bbsRow.content}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _handleGoto(
                                      type: 'author',
                                      id: bbsRow.memberid!,
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      bbsRow.yibeiMember?.avatar == null
                                          ? Image.asset(
                                              'lib/assets/images/head_avatar_default.png',
                                              width: 20,
                                              height: 20,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'lib/assets/images/head_avatar_default.png',
                                              width: 20,
                                              height: 20,
                                              fit: BoxFit.cover,
                                            ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 50,
                                        ),
                                        child: Text(
                                          '${bbsRow.yibeiMember?.username}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.color76777A,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        '${bbsRow.createdAt?.month}/${bbsRow.createdAt?.day}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.color76777A,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.visibility_outlined,
                                      size: 14,
                                      color: AppColors.color76777A,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      '${bbsRow.browsecount}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.color76777A,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    if (bbsRow.islike == 1)
                                      InkWell(
                                        child: const Icon(
                                          Icons.favorite_rounded,
                                          size: 14,
                                          color: AppColors.colorFF5449,
                                        ),
                                        onTap: () {
                                          handleLike(bbsRow.id);
                                        },
                                      ),
                                    if (bbsRow.islike == 0)
                                      InkWell(
                                        child: const Icon(
                                          Icons.favorite_border,
                                          size: 14,
                                          color: AppColors.color76777A,
                                        ),
                                        onTap: () {
                                          handleLike(bbsRow.id);
                                        },
                                      ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      '${bbsRow.likecount}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.color76777A,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
