import 'dart:async';
import 'dart:convert';
import 'package:yibei_app/routes/index.dart';

import 'package:flutter/material.dart';
import 'package:yibei_app/utils/colors_util.dart';
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

/// 登录页

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  /// 处理验证帐号
  Future<bool> _handleValidateAccount(
    String account,
  ) async {
    setState(() {
      _loginLoading = true;
    });

    BaseEntity<CommonReturnStates> entity = await validateIsAccount(account);
    setState(() {
      _loginLoading = false;
    });
    return entity.data?.status == true;
  }

  // 获取图形验证码
  Future<String> _queryImageCode() async {
    setState(() {
      _loginLoading = true;
    });

    BaseEntity<ValidateImageCode> entity = await getImageCode();
    setState(() {
      _loginLoading = false;
    });
    return entity.data?.v ?? '';
  }

  /// 处理登录
  Future<void> _handleLogin(
    String account,
    String password,
    String code,
  ) async {
    setState(() {
      _loginLoading = true;
    });

    BaseEntity<UserLogin> entity = await login(account, password, code);
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

    // 设置缓存帐号和密码
    CacheUtils.instance.set<String>('account', account);
    CacheUtils.instance.set<String>('password', password);

    // 跳转主页
    jumpPageProvider.value = 1;

    // 必须是会员，分类是 6：在学生、10：管理员、22：考试学员、2：考过生
    // if (entity.data?.userInfo?.level != null &&
    //     entity.data!.userInfo!.level! > 0 &&
    //     (entity.data?.userInfo?.category == 6 ||
    //         entity.data?.userInfo?.category == 10 ||
    //         entity.data?.userInfo?.category == 2 ||
    //         entity.data?.userInfo?.category == 22)) {
    //   // 设置缓存token、 userInfo
    //   if (entity.data?.token != null && entity.data?.userInfo != null) {
    //     CacheUtils.instance.set<String>('token', entity.data!.token!);
    //     CacheUtils.instance.set<UserInfo>(
    //       'userInfo',
    //       entity.data!.userInfo!,
    //     );
    //     // 跳转主页
    //     jumpPageProvider.value = 1;
    //   }
    // } else {
    //   _showLoginHint();
    // }
  }

  /// 登录提示
  // void _showLoginHint() {
  //   onShowAlertDialog(
  //     context: context,
  //     title: '提示',
  //     detail: Column(
  //       mainAxisSize: MainAxisSize.min, // 垂直方向上自适应文本内容高度
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: const [
  //         Text('当前版本仅支持付费学员登录。下个版本将允许免费会员登录，敬请期待！'),
  //       ],
  //     ),
  //   );
  // }

  /// 处理按钮点击
  _handleButtonClick() async {
    final String account = _accountsController.text; // 获取帐号

    if (_nowStep == 'accounts') {
      // 验证帐号格式错误
      if (!VerifyUtil.isEmailValid(account) &&
          !VerifyUtil.isPhoneValid(account)) {
        setState(() {
          _accountsErrorHint = '格式错误';
        });
      } else {
        FocusScope.of(context).unfocus(); // 收起键盘
        setState(() {
          _accountsErrorHint = '';
        });
        final bool isAccounts = await _handleValidateAccount(account);
        if (isAccounts) {
          setState(() {
            _nowStep = 'password';
          });
          _focusNode.requestFocus();
        } else {
          ToastUtil.shortToast("帐号不存在");
        }
      }
    } else {
      FocusScope.of(context).unfocus(); // 收起键盘
      final String code = await _queryImageCode(); // 获取图片验证码

      final String password = _passwordController.text; // 获取密码

      _handleLogin(account, password, code);
    }
  }

  /// 输入事件
  handleChanged(value) {
    if (_accountsErrorHint != '') {
      setState(() {
        _accountsErrorHint = '';
      });
    }
  }

  /// 跳转到页页面
  handleGoto() {
    Navigator.pushNamed(
      context,
      AppRoutes.register,
    );
  }

  /// 设置帐号和密码
  _handleAccountPassword() {
    String? account = CacheUtils.instance.get<String>('account');
    String? password = CacheUtils.instance.get<String>('password');
    if (password == null || account == null) return;

    _accountsController.text = account;
    _passwordController.text = password;
  }

  /// 处理点击
  void handlePassword() {
    Navigator.pushNamed(context, AppRoutes.retrievePassword);
  }

  void initState() {
    // 删除缓存
    CacheUtils.instance.remove('token');
    CacheUtils.instance.remove('userInfo');

    _handleAccountPassword();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // 在build完成后执行
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                // 跳转主页
                jumpPageProvider.value = 3;
              },
              child: const SizedBox(
                width: 60,
                height: 48,
                child: Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 40, bottom: 80),
              child: const Center(
                child: Text(
                  '登录易北教育',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 25,
                left: 30,
                right: 30,
              ),
              child: Material(
                child: YbTextField(
                  labelText: '帐号',
                  enabled: _nowStep == 'accounts',
                  hintText: '输入手机号 / 邮箱号',
                  controller: _accountsController,
                  onChanged: handleChanged,
                  keyboardType: TextInputType.emailAddress,
                  errorText:
                      _accountsErrorHint == '' ? null : _accountsErrorHint,
                ),
              ),
            ),
            if (_nowStep == 'password')
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: Material(
                  child: YbTextField(
                    focusNode: _focusNode,
                    labelText: '密码',
                    hintText: '输入密码',
                    controller: _passwordController,
                    isPassword: true,
                    obscureText: true,
                    onChanged: handleChanged,
                  ),
                  // child: PasswordField(
                  //   key: passwordController,
                  //   onChanged: _onPasswordChanged,
                  // ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(
                top: 35,
                left: 30,
                right: 30,
              ),
              child: YbButton(
                disabled: _loginLoading,
                width: double.infinity,
                circle: 20.0,
                text: _nowStep == 'accounts' ? '下一步' : '登录',
                onPressed: _handleButtonClick,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: InkWell(
                onTap: handleGoto,
                child: const Text(
                  '没有帐号？立即注册',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: InkWell(
                onTap: handlePassword,
                child: const Text(
                  '忘记密码了',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width / 2 - 30,
            ),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  onShowAlertDialog(
                    context: context,
                    title: '无法登录？',
                    detail: Column(
                      mainAxisSize: MainAxisSize.min, // 垂直方向上自适应文本内容高度
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('若您还没有易北账号，或者忘记了密码，请在进行注册/找回密码。'),
                        Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: Text('您还可以直接添加张老师的微信：ybmblex 进行咨询。'),
                        ),
                      ],
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  side: const BorderSide(
                    width: 1,
                    color: AppColors.primaryColor,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                ),
                child: const Text(
                  '帮助',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 销毁帐号和密码的控制器
    _accountsController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
