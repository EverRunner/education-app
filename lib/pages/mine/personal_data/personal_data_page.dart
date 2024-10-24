import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/models/mine/mine_personal_data_item/mine_personal_data_item.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/components/common/yb_scaffold.dart';

import 'package:yibei_app/utils/cache_util.dart';
import 'package:yibei_app/models/user/login_user_info/user_info.dart';

class PersonalDataPage extends StatelessWidget {
  PersonalDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取用户信息的缓存
    UserInfo? userInfo = CacheUtils.instance.get<UserInfo>('userInfo');

    // 菜单列表
    final List<MinePersonalDataItem> personalData = [
      MinePersonalDataItem(
        title: '姓名',
        value: userInfo?.username ?? "无",
      ),
      MinePersonalDataItem(
        title: '性别',
        value: userInfo?.sex == "1" ? "男性" : "女性",
      ),
      MinePersonalDataItem(
        title: '生日',
        value: userInfo?.birthdayyear != null
            ? DateFormat('yyyy/MM/dd').format(userInfo!.birthdayyear!)
            : "无",
      ),
      MinePersonalDataItem(
        title: '邮编',
        value: userInfo?.youbian ?? '无',
      ),
      MinePersonalDataItem(
        title: '地址',
        value: userInfo?.address ?? '无',
      ),
    ];

    return YbScaffold(
      appBarTitle: ('个人资料'),
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
                        Navigator.pushNamed(
                            context, AppRoutes.minePersonalDataEdit);
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
                                  '${personalItem.title}',
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
