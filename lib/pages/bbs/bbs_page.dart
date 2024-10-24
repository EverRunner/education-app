import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:shimmer/shimmer.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yibei_app/config/config.dart';
import 'package:yibei_app/utils/permission_util.dart';
import 'package:yibei_app/utils/toast_util.dart';
import 'package:yibei_app/utils/tools_util.dart';

import 'package:yibei_app/models/bbs/bbs_type_item/bbs_type_item.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/models/user/login_user_info/user_info.dart';
import 'package:yibei_app/models/bbs/bbs_list/bbs_list.dart';
import 'package:yibei_app/models/bbs/bbs_list/bbs_list_row.dart';
import 'package:yibei_app/models/common/common_return_states/common_return_states.dart';

import 'package:yibei_app/provider/notifier_provider.dart';

import 'package:yibei_app/api/bbs.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';

class BbsPage extends StatefulWidget {
  const BbsPage({super.key});

  @override
  State<BbsPage> createState() => _BbsPageState();
}

class _BbsPageState extends State<BbsPage> {
  // 滚动控件器
  final ScrollController _masonryScrollController = ScrollController();

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

  /// 选中的类型
  String _selectType = '2';

  /// 页码
  int _pageIndex = 1;

  /// 每页数据条数
  final int _pageSize = Config.page_size;

  /// loading
  bool _loading = false;

  /// 是第一次加载
  bool _isFirst = true;

  double? _latitude;

  double? _longitude;

  // 我关注的列表
  int? _attention;

  /// 节流加载更多
  var _throttledLoadMore;

  /// 处理分类点击
  handleTypeClick(BbsTypeItem item) async {
    if (_loading) return;

    setState(() {
      _selectType = item.id ?? '2';
      _pageIndex = 1;
      _isFirst = true;
    });
    switch (item.id) {
      case '1':
        _attention = 1;
        _latitude = null;
        _latitude = null;
        _queryBbsList(
          showLoading: false,
        );
        break;
      case '2':
        _attention = 0;
        _latitude = null;
        _latitude = null;
        _queryBbsList(
          showLoading: false,
        );
        break;
      case '3':
        _attention = 0;
        // 定位权限判断
        bool permition = await requestLocationPermission();
        if (!permition) {
          ToastUtil.shortToast('请打开定位权限');
          return;
        }
        // 获取经纬度
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        _latitude = position.latitude;
        _longitude = position.longitude;
        _queryBbsList(
          showLoading: true,
        );
        break;
    }
  }

  /// 处理跳转
  _handleGoto({
    required String type,
    int id = 0,
  }) {
    switch (type) {
      case 'author':
        Navigator.pushNamed(
          context,
          AppRoutes.bbsAuthorDetailsPage,
          arguments: {
            'authorId': id,
          },
        );
        break;
      case 'details':
        Navigator.pushNamed(
          context,
          AppRoutes.bbsDetailsPage,
          arguments: {
            'artId': id,
          },
        );
        break;
      case 'edit':
        Navigator.pushNamed(context, AppRoutes.bbsEditPage);
        break;
      default:
        Navigator.pushNamed(
          context,
          AppRoutes.bbsDetailsPage,
          arguments: {
            'artId': id,
          },
        );
    }
    // 在需要阻止冒泡的情况下返回true
    // return true;
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

  /// 获取帖子列表
  _queryBbsList({
    bool showLoading = false,
  }) async {
    _loading = true;
    BaseEntity<BbsList> entity = await getBbsList(
      attention: _attention,
      latitude: _latitude,
      longitude: _longitude,
      pageSize: _pageSize,
      pageIndex: _pageIndex,
      showLoading: showLoading,
    );
    setState(() {
      _loading = false;
      _isFirst = false;
    });
    if (entity.data?.status != true) {
      return;
    }

    setState(() {
      _dataBbsList.addAll(entity.data?.data?.rows ?? []);
      _dataBbsCount = entity.data?.data?.count ?? 0;
    });
  }

  /// 分类widget
  Widget typeWidget({
    required BbsTypeItem item,
    bool active = false,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => handleTypeClick(item),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primaryColor : null,
            border: Border.symmetric(
              vertical: BorderSide(
                color: active ? AppColors.primaryColor : AppColors.colorC2C6CF,
                width: item.radiusType == null ? 0 : 1,
              ),
              horizontal: BorderSide(
                color: active ? AppColors.primaryColor : AppColors.colorC2C6CF,
                width: 1,
              ),
            ),
            borderRadius: item.radiusType == null
                ? null
                : BorderRadius.only(
                    topLeft:
                        Radius.circular(item.radiusType == 'left' ? 30 : 0),
                    bottomLeft:
                        Radius.circular(item.radiusType == 'left' ? 30 : 0),
                    topRight:
                        Radius.circular(item.radiusType == 'right' ? 30 : 0),
                    bottomRight:
                        Radius.circular(item.radiusType == 'right' ? 30 : 0),
                  ),
          ),
          child: Center(
            child: Text(
              '${item.title}',
              style: TextStyle(
                color: active ? AppColors.whiteColor : AppColors.color1A1C1E,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 处理点赞
  void handleLike(int? id) {
    if (id == null) return;
    setState(() {
      for (var item in _dataBbsList) {
        if (item.id == id) item.islike = item.islike == 1 ? 0 : 1;
      }
    });
    setPostLike(id: id);
  }

  /// 瀑布流滚动监听
  void _masonryScrollListener() {
    // 滚动的方向
    if (_masonryScrollController.position.userScrollDirection ==
        ScrollDirection.forward) return;

    // 上拉触底，加载更多
    if (_masonryScrollController.position.pixels >=
            _masonryScrollController.position.maxScrollExtent - 100 &&
        !_loading) {
      _throttledLoadMore();
    }
  }

  /// 骨架屏
  Widget buildShimmer() {
    return Expanded(
      child: Shimmer.fromColors(
        baseColor: AppColors.colorECEFF5,
        highlightColor: AppColors.colorE3E2E6,
        child: MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 12,
          itemCount: 8,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  height: 150,
                ),
                const SizedBox(height: 10.0),
                Container(
                  height: 20.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 8.0),
                Container(
                  height: 20.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 20.0),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    /// 帖子列表，节流加载更多
    _throttledLoadMore = ToolsUtil.throttle(
      () {
        if (_dataBbsList.length < _dataBbsCount) {
          _pageIndex++;
          _queryBbsList();
        } else {
          ToastUtil.shortToast('没有更多数据了');
        }
      },
      const Duration(seconds: 2),
    );

    // 添加滚动监听器
    _masonryScrollController.addListener(_masonryScrollListener);

    _queryBbsList(showLoading: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // 设置为0表示不显示AppBar
        child: AppBar(
          backgroundColor: AppColors.colorFDFCFF,
          elevation: 0.0, // 设置阴影为0.0
        ),
      ),
      backgroundColor: AppColors.colorFDFCFF,
      body: Stack(
        children: [
          // SizedBox(
          //   width: 200.0,
          //   height: 100.0,
          //   child: Shimmer.fromColors(
          //     baseColor: Colors.red,
          //     highlightColor: Colors.yellow,
          //     child: Text(
          //       'Shimmer',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         fontSize: 40.0,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),

          Container(
            padding: const EdgeInsets.only(
              top: 20,
              right: 12,
              left: 12,
              bottom: 2,
            ),
            child: SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _typeData
                          .map(
                            (item) => typeWidget(
                              item: item,
                              active: _selectType == item.id,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  // MasonryGridView

                  _isFirst
                      ? buildShimmer()
                      : Expanded(
                          child: MasonryGridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 12,
                            itemCount: _dataBbsList.length, // 数据总数
                            itemBuilder: (context, index) {
                              final bbsRow = _dataBbsList[index];
                              final String imageUrl = bbsRow.images != null
                                  ? Config.file_root +
                                      bbsRow.images.split(',')[0]
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
                                            borderRadius: BorderRadius.circular(
                                                4), // 可选设置圆角
                                            child: AspectRatio(
                                              aspectRatio: 1 / 1, // 设置宽高比例为1:1
                                              child: imageUrl != ''
                                                  ? CachedNetworkImage(
                                                      fit: BoxFit
                                                          .cover, // 设置图片适应方式
                                                      imageUrl: imageUrl,
                                                      placeholder: (context,
                                                              url) =>
                                                          _imagePlaceholder(), // 加载中显示的widget
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(Icons
                                                              .error), // 加载失败显示的widget
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .image_not_supported_outlined,
                                                      size: 50,
                                                      color:
                                                          AppColors.colorCBCBCB,
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
                                              color: AppColors.blackColor
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                      '${bbsRow.title}',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: bbsRow.yibeiMember
                                                            ?.avatar ==
                                                        null
                                                    ? Image.asset(
                                                        'lib/assets/images/head_avatar_default.png',
                                                        width: 20,
                                                        height: 20,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.network(
                                                        bbsRow.yibeiMember
                                                                ?.avatar
                                                                .contains(
                                                                    'https')
                                                            ? '${bbsRow.yibeiMember?.avatar}'
                                                            : '${Config.file_root}${bbsRow.yibeiMember?.avatar}',
                                                        width: 20,
                                                        height: 20,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Container(
                                                constraints:
                                                    const BoxConstraints(
                                                  maxWidth: 50,
                                                ),
                                                child: Text(
                                                  '${bbsRow.yibeiMember?.username}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        AppColors.color76777A,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                        )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10, // 调整文字距离底部的距离
            right: 10, // 调整文字距离右边的距离
            child: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    offset: Offset(0, 1),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: YbButton(
                text: '发布',
                backgroundColor: AppColors.colorCCE5FF,
                borderColor: AppColors.colorCCE5FF,
                textColor: AppColors.color001E31,
                height: 55,
                circle: 16,
                icon: Icons.mode_edit,
                onPressed: () {
                  _handleGoto(type: 'edit');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
