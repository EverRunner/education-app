import 'package:flutter/material.dart';
import 'package:yibei_app/utils/toast_util.dart';
import 'package:yibei_app/utils/verify_util.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_svg/flutter_html_svg.dart';
import 'package:yibei_app/utils/cache_util.dart';
import 'package:yibei_app/utils/tools_util.dart';
import 'package:yibei_app/routes/index.dart';

import 'package:yibei_app/components/common/yb_scaffold.dart';
import 'package:yibei_app/components/common/yb_text_field.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/components/common/sms_send_timer.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/common/common_return_states/common_return_states.dart';
import 'package:yibei_app/models/common/validate_image_code/validate_image_code.dart';
import 'package:yibei_app/models/user/login_user_info/login_user_info.dart';
import 'package:yibei_app/models/user/login_user_info/user_info.dart';

import 'package:yibei_app/api/user.dart';
import 'package:yibei_app/api/common.dart';

/// 修改邮箱页面
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  /// 当前步骤
  String _nowStep = 'account'; //account

  /// 邮箱文本框控制器
  final TextEditingController _accountController = TextEditingController();

  /// 图片验证码文本框控制器
  final TextEditingController _imgCodeController = TextEditingController();

  /// 验证码文本框控制器
  final TextEditingController _validateCodeController = TextEditingController();

  /// 姓名文本框控制器
  final TextEditingController _userNameController = TextEditingController();

  /// 密码框文本框控制器
  final TextEditingController _passwordController = TextEditingController();

  /// 邮箱错误提示
  String _accountErrorHint = '';

  /// 图片验证码错误提示
  String _imgCodeErrorHint = '';

  /// 姓名错误提示
  String _userNameErrorHint = '';

  /// 密码错误提示
  String _passwordErrorHint = '';

  /// 验证码密码错误提示
  String _validateCodeErrorHint = '';

  /// 图片验证码HTML
  String _imgCodeHtml = '';

  /// 图片验证码
  String _imgCode = '';

  /// 图片验证码loading
  bool _imgCodeLoading = false;

  /// 提交loading
  bool _loading = false;

  /// 帐号类型
  String _accountType = 'email';

  /// 获取图形验证码
  Future<void> _queryImageCode() async {
    setState(() {
      _imgCodeLoading = true;
    });
    BaseEntity<ValidateImageCode> entity = await getImageCode();
    setState(() {
      _imgCodeHtml = entity.data?.img ?? '';
      _imgCodeLoading = false;
      _imgCode = entity.data?.v ?? '';
    });
  }

  /// 处理验证帐号
  Future<bool> _handleValidateAccount(
    String account,
  ) async {
    setState(() {
      _loading = true;
    });
    BaseEntity<CommonReturnStates> entity = await validateIsAccount(account);
    setState(() {
      _loading = false;
    });
    return entity.data?.status == false;
  }

  /// 处理验证帐号
  /// [account] 帐号
  /// [validateCode] 验证码
  Future<bool> _handleValidateCode({
    required String account,
    required String validateCode,
  }) async {
    setState(() {
      _loading = true;
    });
    BaseEntity<CommonReturnStates> entity = await validateEmailOrPhoneCode(
      account: account,
      validateCode: validateCode,
    );
    setState(() {
      _loading = false;
    });
    return entity.data?.status ?? false;
  }

  /// 处理下一步
  _handleNext() async {
    final String account = _accountController.text;
    final String imgCode = _imgCodeController.text;
    final String validateCode = _validateCodeController.text;
    final String userName = _userNameController.text;
    final String password = _passwordController.text;
    FocusScope.of(context).unfocus(); // 收起键盘

    switch (_nowStep) {
      case 'account':
        if (!VerifyUtil.isEmailValid(account) &&
            !VerifyUtil.isPhoneValid(account)) {
          setState(() {
            _accountErrorHint = '邮箱格式错误';
          });
        } else {
          // 验证帐号号
          final bool isAccounts = await _handleValidateAccount(account);
          if (isAccounts) {
            await _queryImageCode(); // 获取图片验证码
            setState(() {
              _nowStep = 'imgCode';
            });
          } else {
            ToastUtil.shortToast("该帐号已被注册了");
          }
        }
        break;
      case 'imgCode':
        if (imgCode != '' && imgCode == _imgCode) {
          final bool isNext = await _handleSendCode();
          if (isNext) {
            setState(() {
              _nowStep = 'validateCode';
            });
            await Future.delayed(const Duration(milliseconds: 500)); // 延时500毫秒
            smsSendTimerKey.currentState?.startTimer();
          }
        } else {
          setState(() {
            _imgCodeErrorHint = '图片验证码不正确';
          });
        }
        break;
      case 'validateCode':
        // 验证码是否通过
        final bool isPass = await _handleValidateCode(
          account: account,
          validateCode: validateCode,
        );
        if (isPass) {
          setState(() {
            _nowStep = 'password';
          });
        } else {
          setState(() {
            _validateCodeErrorHint = '验证码不正确';
          });
        }
        break;
      case 'password':
        if (userName == '') {
          setState(() {
            _userNameErrorHint = '必须填写姓名';
          });
          return;
        }
        if (!ToolsUtil.isValidPassword(password)) {
          setState(() {
            _passwordErrorHint = '密码长度为6至16位！';
          });
          return;
        }
        _handleRegistered(
          context: context,
          account: account,
          validateCode: validateCode,
          userName: userName,
          password: password,
        );
        break;
    }
  }

  /// 使用手机号注册
  Future<bool> _useRegisterPhone({
    required String phone,
    required String phoneCode,
    required String password,
    required String userName,
  }) async {
    setState(() {
      _loading = true;
    });

    BaseEntity<CommonReturnStates> entity = await registerPhone(
      phone: phone,
      password: password,
      channel: 'APP',
      phoneCode: phoneCode,
      userName: userName,
    );
    setState(() {
      _loading = false;
    });
    return entity.data?.status ?? false;
  }

  /// 使用邮箱注册
  Future<bool> _useRegisterEmail({
    required String email,
    required String emailCode,
    required String password,
    required String userName,
  }) async {
    setState(() {
      _loading = true;
    });

    BaseEntity<CommonReturnStates> entity = await registerEmail(
      email: email,
      password: password,
      channel: 'APP',
      emailCode: emailCode,
      userName: userName,
    );
    setState(() {
      _loading = false;
    });
    return entity.data?.status ?? false;
  }

  /// 提交注册
  Future<void> _handleRegistered({
    required String account,
    required String validateCode,
    required String password,
    required String userName,
    required BuildContext context,
  }) async {
    bool isSucceed = false;

    if (_accountType == 'phone') {
      isSucceed = await _useRegisterPhone(
        phone: account,
        phoneCode: validateCode,
        password: password,
        userName: userName,
      );
    } else {
      isSucceed = await _useRegisterEmail(
        email: account,
        emailCode: validateCode,
        password: password,
        userName: userName,
      );
    }
    if (!isSucceed) return;

    onShowAlertDialog(
      title: '提示',
      context: context,
      detail: Column(
        children: [
          const Text('恭喜您，注册成功！'),
          const SizedBox(
            height: 15,
          ),
          const Text('请返回登录页登录系统.'),
        ],
      ),
    );
  }

  /// 发送邮箱验证码
  Future<bool> _sendEmailCode({
    required String email,
    required String imgCode,
  }) async {
    setState(() {
      _loading = true;
    });

    BaseEntity<CommonReturnStates> entity = await sendValidateToEmail(
      email: email,
      imgCode: imgCode,
    );
    setState(() {
      _loading = false;
    });
    return entity.data?.status ?? false;
  }

  /// 发送手机验证码
  Future<bool> _sendPhoneCode({
    required String phone,
    required String imgCode,
  }) async {
    setState(() {
      _loading = true;
    });

    BaseEntity<CommonReturnStates> entity = await sendValidateToPhone(
      phone: phone,
      imgCode: imgCode,
    );
    setState(() {
      _loading = false;
    });
    return entity.data?.status ?? false;
  }

  /// 发送验证码
  /// [isReload] 如果重新获取，就自动获取一次图片验证码
  _handleSendCode({
    bool isReload = false,
  }) async {
    if (isReload) {
      await _queryImageCode();
    }

    final String account = _accountController.text;
    final String imgCode = isReload ? _imgCode : _imgCodeController.text;

    // 判断是不是手机号，还是邮箱
    if (account.contains("@")) {
      setState(() {
        _accountType = 'email';
      });
      return await _sendEmailCode(
        email: account,
        imgCode: imgCode,
      );
    } else {
      setState(() {
        _accountType = 'phone';
      });
      return await _sendPhoneCode(
        phone: account,
        imgCode: imgCode,
      );
    }
  }

  /// 输入事件
  handleChanged({required String type}) {
    switch (type) {
      case 'account':
        if (_accountErrorHint != '') {
          setState(() {
            _accountErrorHint = '';
          });
        }
        break;
      case 'imgCode':
        if (_imgCodeErrorHint != '') {
          setState(() {
            _imgCodeErrorHint = '';
          });
        }
        break;
      case 'validateCode':
        if (_validateCodeErrorHint != '') {
          setState(() {
            _validateCodeErrorHint = '';
          });
        }
        break;
      case 'userName':
        if (_userNameErrorHint != '') {
          setState(() {
            _userNameErrorHint = '';
          });
        }
        break;
      case 'password':
        if (_passwordErrorHint != '') {
          setState(() {
            _passwordErrorHint = '';
          });
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    String accountTypeText = (_accountType == 'phone' ? '手机' : '邮箱');

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
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.only(top: 60, bottom: 80),
                child: Text(
                  '易北帐号注册',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    // 第一步
                    YbTextField(
                      labelText: '注册帐号',
                      hintText: '输入手机号 / 邮箱号',
                      controller: _accountController,
                      keyboardType: TextInputType.emailAddress,
                      errorText:
                          _accountErrorHint == '' ? null : _accountErrorHint,
                      onChanged: (e) {
                        handleChanged(type: 'account');
                      },
                      enabled: _nowStep == 'account' ? true : false,
                      style: _nowStep == 'account'
                          ? null
                          : const TextStyle(
                              color: AppColors.color74777F,
                            ),
                    ),
                    const SizedBox(height: 24),

                    // 第二、三步
                    if (_nowStep != 'account')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 第二步
                          const SizedBox(height: 14),
                          Text(
                            "${_nowStep == 'imgCode' ? '请通过图片验证码，来获取认证码。' : ''}${_nowStep == 'validateCode' ? '请通过图片验证码，来获取认证码。' : ''}${_nowStep == 'password' ? '最后一步！' : ''}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.color1A1C1E,
                            ),
                          ),
                          if (_nowStep == 'imgCode')
                            SizedBox(
                              height: 50,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    height: 48,
                                    child: Html(
                                      data: _imgCodeHtml,
                                      extensions: const [
                                        SvgHtmlExtension(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: _imgCodeLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                AppColors.primaryColor,
                                              ),
                                            ),
                                          )
                                        : TextButton(
                                            child: const Text('重新整理'),
                                            onPressed: () {
                                              _queryImageCode();
                                            },
                                          ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 24),
                          if (_nowStep == 'imgCode')
                            YbTextField(
                              labelText: '图片验证码',
                              hintText: '输入图片验证码',
                              controller: _imgCodeController,
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              errorText: _imgCodeErrorHint == ''
                                  ? null
                                  : _imgCodeErrorHint,
                              onChanged: (e) {
                                handleChanged(type: 'imgCode');
                              },
                            ),

                          // 第三步-输入验证码

                          if (_nowStep == 'validateCode')
                            YbTextField(
                              labelText: '$accountTypeText验证码',
                              hintText: '输入$accountTypeText验证码',
                              controller: _validateCodeController,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              errorText: _validateCodeErrorHint == ''
                                  ? null
                                  : _validateCodeErrorHint,
                              onChanged: (e) {
                                handleChanged(type: 'validateCode');
                              },
                            ),

                          // 第四步-密码和验证码
                          if (_nowStep == 'password')
                            Column(
                              children: [
                                YbTextField(
                                  labelText: '姓名',
                                  hintText: '输入您的姓名',
                                  controller: _userNameController,
                                  errorText: _userNameErrorHint == ''
                                      ? null
                                      : _userNameErrorHint,
                                  onChanged: (e) {
                                    handleChanged(type: 'userName');
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Material(
                                  child: YbTextField(
                                    labelText: '密码',
                                    hintText: '输入密码',
                                    controller: _passwordController,
                                    errorText: _passwordErrorHint == ''
                                        ? null
                                        : _passwordErrorHint,
                                    isPassword: true,
                                    obscureText: true,
                                    onChanged: (e) {
                                      handleChanged(type: 'password');
                                    },
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              Column(
                children: [
                  // 第三步-重发验证码
                  if (_nowStep == 'validateCode')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('没有收到验证码？'),
                        SmsSendTimer(
                          key: smsSendTimerKey,
                          sendCallback: () {
                            _handleSendCode(isReload: true);
                          },
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 35,
                    ),
                    child: YbButton(
                      text: _nowStep == 'password' ? '提交注册' : '下一步',
                      width: double.infinity,
                      circle: 20.0,
                      onPressed: _handleNext,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context); // 后退
                  },
                  child: const Text(
                    '已有帐号，返回登录',
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
                  onTap: () {
                    Navigator.pop(context); // 后退
                  },
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.touristLogin);
                    },
                    child: const Text(
                      '游客登录',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 2 - 30,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    YbButton(
                      text: '帮助',
                      circle: 20,
                      borderColor: AppColors.primaryColor,
                      backgroundColor: AppColors.whiteColor,
                      textColor: AppColors.primaryColor,
                      onPressed: () {
                        onShowAlertDialog(
                          context: context,
                          title: '无法注册？',
                          detail: Column(
                            mainAxisSize: MainAxisSize.min, // 垂直方向上自适应文本内容高度
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                '如果在注册过程中遇到任何问题，您可以直接通过添加张老师的微信号：ybmblex 进行咨询。',
                                style: TextStyle(height: 1.6),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    // const SizedBox(
                    //   width: 20,
                    // ),
                    // YbButton(
                    //   text: '游客登录',
                    //   circle: 20,
                    //   width: 100,
                    //   borderColor: AppColors.primaryColor,
                    //   backgroundColor: AppColors.whiteColor,
                    //   textColor: AppColors.primaryColor,
                    //   onPressed: () {
                    //     Navigator.pushNamed(context, AppRoutes.touristLogin);
                    //   },
                    // ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _accountController.dispose();
    _imgCodeController.dispose();
    _validateCodeController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
