import 'package:flutter/material.dart';
import 'package:yibei_app/utils/toast_util.dart';
import 'package:yibei_app/utils/verify_util.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_svg/flutter_html_svg.dart';
import 'package:yibei_app/utils/cache_util.dart';

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
class AccountSettingEmailPage extends StatefulWidget {
  const AccountSettingEmailPage({super.key});

  @override
  State<AccountSettingEmailPage> createState() =>
      _AccountSettingEmailPageState();
}

class _AccountSettingEmailPageState extends State<AccountSettingEmailPage> {
  /// 当前步骤
  String _nowStep = 'email'; //email

  /// 邮箱文本框控制器
  final TextEditingController _emailController = TextEditingController();

  /// 图片验证码文本框控制器
  final TextEditingController _imgCodeController = TextEditingController();

  /// 验证码文本框控制器
  final TextEditingController _validateCodeController = TextEditingController();

  /// 邮箱错误提示
  String _emailErrorHint = '';

  /// 图片验证码误提示
  String _imgCodeErrorHint = '';

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

  /// 处理下一步
  _handleNext() async {
    final String email = _emailController.text;
    final String imgCode = _imgCodeController.text;
    final String validateCode = _validateCodeController.text;

    switch (_nowStep) {
      case 'email':
        if (VerifyUtil.isEmailValid(email)) {
          _queryImageCode();
          setState(() {
            _nowStep = 'imgCode';
          });
        } else {
          setState(() {
            _emailErrorHint = '邮箱格式错误';
          });
        }
        break;
      case 'imgCode':
        if (imgCode != '' && imgCode == _imgCode) {
          final bool isNext = await _handleSendEmailCode();
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
        _handleSubmit(
          email: email,
          validateCode: validateCode,
        );
        break;
    }
  }

  /// 处理提交
  _handleSubmit({
    required String email,
    required String validateCode,
  }) {
    onShowAlertDialog(
      context: context,
      title: '提示',
      actionsPadding: const EdgeInsets.only(
        bottom: 15,
        right: 20,
      ),
      detail: const Text('您确认要绑定/变更邮箱？'),
      actions: [
        TextButton(
          child: const Text('关闭'),
          onPressed: () {
            Navigator.pop(context); // 关闭弹窗
          },
        ),
        YbButton(
          text: '确认',
          circle: 25,
          disabled: _loading,
          onPressed: () {
            _handleEditEmail(
              email: email,
              validateCode: validateCode,
            );
          },
        ),
      ],
    );
  }

  /// 修改邮箱
  _handleEditEmail({
    required String email,
    required String validateCode,
  }) async {
    setState(() {
      _loading = true;
    });
    BaseEntity<CommonReturnStates> entity = await changeBindEmail(
      email: email,
      validateCode: validateCode,
    );
    Navigator.of(context).pop(); // 关闭弹窗
    setState(() {
      _loading = false;
    });
    if (entity.data?.status == true) {
      _queryLoginUserInfo();
      ToastUtil.shortToast("修改成功");
      Navigator.of(context).pop(); // 返回
    }
  }

  /// 获取登录用户的信息
  _queryLoginUserInfo() async {
    BaseEntity<LoginUserInfo> entity = await getLoginUserInfo(
      showLoading: false,
    );
    if (entity.data?.status != true || entity.data?.userInfo == null) {
      return;
    }
    // 获取最新的用户信息，覆盖用户缓存信息
    CacheUtils.instance.set<UserInfo>(
      'userInfo',
      (entity.data!.userInfo!)..studytimeavg = entity.data?.studytimeavg,
    );
  }

  /// 发送邮箱验证码
  /// [isReload] 如果重新获取，就自动获取一次图片验证码
  Future<bool> _handleSendEmailCode({
    bool isReload = false,
  }) async {
    if (isReload) {
      await _queryImageCode();
    }

    final String email = _emailController.text;
    final String imgCode = isReload ? _imgCode : _imgCodeController.text;

    BaseEntity<CommonReturnStates> entity = await sendEmailValidateCode(
      email: email,
      imgCode: imgCode,
    );
    return entity.data?.status ?? false;
  }

  /// 输入事件
  handleChanged({required String type}) {
    switch (type) {
      case 'email':
        if (_emailErrorHint != '') {
          setState(() {
            _emailErrorHint = '';
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final double minHeight = MediaQuery.of(context).size.height - 140;

    return YbScaffold(
      appBarTitle: ('绑定/变更邮箱'),
      bodyPadding: const EdgeInsets.all(0),
      body: Container(
        constraints: BoxConstraints(
          minHeight: minHeight,
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 25,
                left: 12,
                right: 12,
              ),
              child: Column(
                children: [
                  // 第一步
                  YbTextField(
                    labelText: '邮箱',
                    hintText: '输入邮箱号',
                    controller: _emailController,
                    errorText: _emailErrorHint == '' ? null : _emailErrorHint,
                    onChanged: (e) {
                      handleChanged(type: 'email');
                    },
                    enabled: _nowStep == 'email' ? true : false,
                    style: _nowStep == 'email'
                        ? null
                        : const TextStyle(
                            color: AppColors.color74777F,
                          ),
                  ),
                  const SizedBox(height: 24),

                  // 第二、三步
                  if (_nowStep != 'email')
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: AppColors.colorE4EAF5,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 第二步
                          const SizedBox(height: 24),
                          Text(
                            _nowStep == 'imgCode'
                                ? '请通过图片验证码，来获取认证码。'
                                : '认证码已发送，请前往邮箱确认。',
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
                              labelText: '帐号验证码',
                              hintText: '输入帐号验证码',
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
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
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
                            _handleSendEmailCode(isReload: true);
                          },
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 18,
                      left: 20,
                      right: 20,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: AppColors.colorE4EAF5,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: YbButton(
                      text: _nowStep == 'validateCode' ? '提 交' : '下一步',
                      circle: 25,
                      height: 45,
                      textSize: 16,
                      onPressed: _handleNext,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _imgCodeController.dispose();
    _validateCodeController.dispose();
    super.dispose();
  }
}
