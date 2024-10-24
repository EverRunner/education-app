import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/components/common/yb_button.dart';

import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/utils/cache_util.dart';
import 'package:yibei_app/components/common/yb_scaffold.dart';
import 'package:yibei_app/models/mine/account_setting_data_item/account_setting_data_item.dart';
import 'package:yibei_app/models/user/login_user_info/user_info.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/common/common_return_states/common_return_states.dart';

import 'package:yibei_app/api/user.dart';

import 'package:yibei_app/provider/notifier_provider.dart';

class AccountSettingPage extends StatelessWidget {
  AccountSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取用户信息的缓存
    UserInfo? userInfo = CacheUtils.instance.get<UserInfo>('userInfo');

    // 菜单列表
    final List<AccountSettingDataItem> personalData = [
      AccountSettingDataItem(
        title: '第三方登录',
        value: userInfo?.unionidWx != null || userInfo?.openidGg != null
            ? '${userInfo?.unionidWx != null ? '微信帐号' : '谷歌邮箱'}已绑定'
            : '未绑定',
        showIcon: false,
      ),
      AccountSettingDataItem(
        title: '邮箱',
        value: userInfo?.email ?? '未绑定',
        path: AppRoutes.mineAccountSettingEmailPage,
        showIcon: true,
      ),
      AccountSettingDataItem(
        title: '手机',
        value: userInfo?.phone ?? '未绑定',
        path: AppRoutes.mineAccountSettingPhonePage,
        showIcon: true,
      ),
      AccountSettingDataItem(
        title: '密码',
        value: '＊＊＊＊＊＊＊＊',
        path: AppRoutes.mineAccountSettingPasswordPage,
        showIcon: true,
      ),
      AccountSettingDataItem(
        title: '用户注销',
        value: '删除用户所有数据',
        showIcon: true,
      ),
    ];

    /// 处理点击
    void handleClidk(AccountSettingDataItem personalItem) {
      if (personalItem.path != null) {
        Navigator.pushNamed(
          context,
          personalItem.path!,
        );
      } else if (personalItem.title == '用户注销') {
        onShowAlertDialog(
          context: context,
          title: '用户注销',
          detail: const Text(
            '用户注销将彻底清除您的所有数据（包括个人信息、学习记录等），请慎重考虑和谨慎操作！',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.dangerColor,
              height: 1.6,
            ),
          ),
          actions: [
            YbButton(
              text: '确认',
              circle: 20,
              onPressed: () async {
                BaseEntity<CommonReturnStates> entity = await deleteUser();
                if (entity.data?.status != true) return;

                // 清除所有的缓存
                CacheUtils.instance.clear();

                // 返回到指定上级页面（）
                Navigator.popUntil(context, ModalRoute.withName('/'));

                // 跳转登录页
                jumpPageProvider.value = 3;
              },
            ),
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.pop(context); // 关闭弹窗
              },
            ),
          ],
        );
      }
    }

    return YbScaffold(
      appBarTitle: ('帐号设置'),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: personalData
              .map((personalItem) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    color: AppColors.colorFBFCFF,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        handleClidk(personalItem);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  personalItem.title!,
                                  style: const TextStyle(
                                    color: AppColors.color1A1C1E,
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                                Text(
                                  personalItem.value!,
                                  style: const TextStyle(
                                    color: AppColors.color43474E,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (personalItem.showIcon == true)
                            const Icon(
                              Icons.arrow_right,
                              color: AppColors.color1A1C1E,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
