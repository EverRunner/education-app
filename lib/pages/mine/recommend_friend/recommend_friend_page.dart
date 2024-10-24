import 'package:flutter/material.dart';
import 'package:yibei_app/components/common/yb_scaffold.dart';
import 'package:yibei_app/utils/toast_util.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:clipboard/clipboard.dart';
import 'package:yibei_app/utils/cache_util.dart';
import 'package:yibei_app/models/user/login_user_info/user_info.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/user/my_floow_member/my_floow_member.dart';
import 'package:yibei_app/models/user/my_floow_member/my_floow_member_datum.dart';

import 'package:yibei_app/api/user.dart';

class RecommendFriendPage extends StatefulWidget {
  const RecommendFriendPage({super.key});

  @override
  State<RecommendFriendPage> createState() => _RecommendFriendPageState();
}

class _RecommendFriendPageState extends State<RecommendFriendPage> {
  /// 朋友列表
  List<MyFloowMemberDatum> _friendList = [];

  /// 获取推荐朋友列表
  _queryRecommendFriendList() async {
    BaseEntity<MyFloowMember> entity = await getRecommendFriendList();
    if (entity.data?.status != true || entity.data?.data == null) {
      return;
    }
    setState(() {
      _friendList = entity.data!.data!;
    });
  }

  @override
  void initState() {
    super.initState();
    _queryRecommendFriendList();
  }

  @override
  Widget build(BuildContext context) {
    /// 获取用户信息的缓存
    UserInfo? userInfo = CacheUtils.instance.get<UserInfo>('userInfo');

    /// 分享码
    String? shareCode;

    /// 分享链接
    String? shareLink;

    if (userInfo?.sharecode == null || userInfo?.sharecode == '') {
      shareCode = '无';
      shareLink = '无';
    } else {
      shareCode = userInfo!.sharecode!;
      shareLink =
          'https://ybmblex.net/#/?channel=studentCode&recommendCode=${userInfo.sharecode}';
    }

    return YbScaffold(
      appBarTitle: ('推荐朋友'),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 12,
              ),
              child: Text(
                '您还可以推荐其他人来购买我们的课程，购课者可获得 100 美金的优惠券，直接抵扣学费；您也会获得 88 美金的现金奖励！',
                style: TextStyle(
                  height: 1.5,
                  fontSize: 16,
                  color: AppColors.color1A1C1E,
                ),
              ),
            ),
            RecommendItem(
              title: '推荐码',
              value: shareCode,
              onTap: () {
                if (shareCode == null || shareCode == '无') return;
                onShowAlertDialog(
                  context: context,
                  title: '推荐码',
                  detail: Text(
                    shareCode,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.color43474E,
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('一键复制'),
                      onPressed: () {
                        // 设置剪贴板内容
                        FlutterClipboard.copy('$shareCode').then((value) {
                          ToastUtil.shortToast("复制成功");
                          Navigator.pop(context); // 关闭弹窗
                        });
                      },
                    ),
                    TextButton(
                      child: const Text('关闭'),
                      onPressed: () {
                        Navigator.pop(context); // 关闭弹窗
                      },
                    ),
                  ],
                );
              },
            ),
            RecommendItem(
              title: '推荐购买链接',
              value: shareLink,
              onTap: () {
                if (userInfo?.sharecode == null) return;
                onShowAlertDialog(
                  context: context,
                  title: '推荐购买链接',
                  detail: Text(
                    '$shareLink',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.color43474E,
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('一键复制'),
                      onPressed: () {
                        // 设置剪贴板内容
                        FlutterClipboard.copy('$shareLink').then((value) {
                          ToastUtil.shortToast("复制成功");
                          Navigator.pop(context); // 关闭弹窗
                        });
                      },
                    ),
                    TextButton(
                      child: const Text('关闭'),
                      onPressed: () {
                        Navigator.pop(context); // 关闭弹窗
                      },
                    ),
                  ],
                );
              },
            ),
            RecommendItem(
              title: '您已成功推荐的朋友',
              value: '0 位',
              onTap: () {
                onShowRecommendFriendDialog(
                  context: context,
                  title: '您已成功推荐的朋友',
                  friendNum: _friendList.length,
                  friendList: _friendList,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 推荐的子项
class RecommendItem extends StatelessWidget {
  // 标题
  final String title;

  // 内容
  final String value;

  // 点击事件
  final VoidCallback? onTap;

  const RecommendItem(
      {super.key, required this.title, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.colorFBFCFF,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.color1A1C1E,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.color43474E,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_right,
              color: AppColors.color1A1C1E,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
