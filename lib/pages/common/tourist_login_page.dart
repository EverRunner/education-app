import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:yibei_app/routes/index.dart';

import 'package:flutter/material.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/utils/tools_util.dart';
import 'package:yibei_app/utils/verify_util.dart';
import 'package:yibei_app/utils/cache_util.dart';
import 'package:yibei_app/utils/toast_util.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/components/common/yb_text_field.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/models/common/validate_image_code/validate_image_code.dart';
import 'package:yibei_app/models/common/user_login/user_login.dart';
import 'package:yibei_app/models/user/login_user_info/user_info.dart';
import 'package:yibei_app/models/common/common_return_states/common_return_states.dart';

import 'package:yibei_app/provider/notifier_provider.dart';

import 'package:yibei_app/api/common.dart';

/// 游客登录页

class TouristLoginPage extends StatefulWidget {
  const TouristLoginPage({Key? key}) : super(key: key);

  @override
  State<TouristLoginPage> createState() => _TouristLoginPageState();
}

class _TouristLoginPageState extends State<TouristLoginPage> {
  /// 当前步骤
  String _nowStep = 'accounts';

  /// 帐号错误提示
  String _accountsErrorHint = '';

  /// 帐号文本框控制器
  final TextEditingController _accountsController = TextEditingController();

  /// 密码文本框控制器
  final TextEditingController _passwordController = TextEditingController();

  /// 自动获取获取焦点
  final FocusNode _focusNode = FocusNode();

  /// 自动获取获取焦点
  bool _loginLoading = false;

  // 应该程序id
  late String _deviceId;

  /// 处理登录
  Future<void> _handleLogin() async {
    setState(() {
      _loginLoading = true;
    });

    BaseEntity<UserLogin> entity = await touristLoginRegister(
      touristId: _deviceId,
      channel: Platform.isAndroid ? 'Android' : 'IOS',
    );
    setState(() {
      _loginLoading = false;
    });
    if (entity.data?.status != true ||
        entity.data?.userInfo == null ||
        entity.data?.token == null) {
      return;
    }

    // 设置缓存token、 userInfo
    CacheUtils.instance.set<String>('token', entity.data!.token!);
    CacheUtils.instance.set<UserInfo>(
      'userInfo',
      entity.data!.userInfo!,
    );

    // 返回到指定上级页面（）
    Navigator.popUntil(context, ModalRoute.withName('/'));

    // 跳转主页
    jumpPageProvider.value = 1;
  }

  /// 打开弹框解锁全部课程
  handleOpen() {
    onShowAlertDialog(
        context: context,
        title: '提示',
        barrierDismissible: true,
        detail: Container(
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 10,
          ),
          child: const Text('确认使用游客登录吗？'),
        ),
        actions: [
          YbButton(
            text: '确认',
            circle: 20,
            onPressed: () {
              Navigator.pop(context); // 关闭弹窗
              _handleLogin();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 5),
            child: TextButton(
              child: const Text('关闭'),
              onPressed: () {
                Navigator.pop(context); // 关闭弹窗
              },
            ),
          ),
        ]);
  }

  /// 获取应用程序id
  Future<void> _getDeviceDetails() async {
    Map<String, dynamic> entity = await getDeviceDetails();

    setState(() {
      _deviceId = entity['deviceId'];
    });
  }

  @override
  void initState() {
    _getDeviceDetails();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // 设置为0表示不显示AppBar
        child: AppBar(
          backgroundColor: AppColors.whiteColor,
          elevation: 0.0, // 设置阴影为0.0
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: screenHeight * 0.8,
            padding: const EdgeInsets.all(24),
            child: Center(
              child: SizedBox(
                height: 230,
                child: Column(
                  children: [
                    const Text(
                      '易北游客登录',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 110,
                    ),
                    YbButton(
                      text: '游客登录',
                      width: double.infinity,
                      circle: 20,
                      onPressed: () {
                        handleOpen();
                      },
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}


// 游客登录仅限于本设备使用，不支持多设备同步登录，确保账号安全和隐私保护。
// 游客登录数据不会被保存，注意不要删除应用或清除数据以免数据丢失。
// 游客登录数据无法恢复，建议及时升级为正式注册账号以保护数据和账号安全。
// 可以设置时间限制来控制游客登录功能的使用，鼓励用户尽快注册正式账号。
// 游客登录可能限制某些高级功能或服务的使用，注册正式账号可以获得更多功能和个性化服务。