import 'package:flutter/material.dart';
import 'package:yibei_app/utils/toast_util.dart';
import 'package:yibei_app/utils/verify_util.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/utils/colors_util.dart';

import 'package:yibei_app/components/common/yb_scaffold.dart';
import 'package:yibei_app/components/common/yb_text_field.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/common/common_return_states/common_return_states.dart';

import 'package:yibei_app/api/user.dart';

/// 修改密码页面
class AccountSettingPasswordPage extends StatefulWidget {
  const AccountSettingPasswordPage({super.key});

  @override
  State<AccountSettingPasswordPage> createState() =>
      _AccountSettingPasswordPageState();
}

class _AccountSettingPasswordPageState
    extends State<AccountSettingPasswordPage> {
  /// 密码文本框控制器
  final TextEditingController _passwordController = TextEditingController();

  /// 密码文本框控制器2
  final TextEditingController _passwordController2 = TextEditingController();

  /// 密码错误提示
  String _passwordErrorHint = '';

  /// 密码错误提示2
  String _passwordErrorHint2 = '';

  /// 提交的loading
  bool _loading = false;

  /// 提交修改
  _handleSubmit() {
    final String newPassword = _passwordController.text;
    final String newPassword2 = _passwordController2.text;

    if (!VerifyUtil.passwordValidation(value: newPassword)) {
      setState(() {
        _passwordErrorHint = '密码长度为6至16位';
      });
      return;
    }

    if (newPassword != newPassword2) {
      setState(() {
        _passwordErrorHint2 = '两次密码输入不一致';
      });
      return;
    }

    onShowAlertDialog(
      context: context,
      title: '提示',
      actionsPadding: const EdgeInsets.only(
        bottom: 15,
        right: 20,
      ),
      detail: const Text('您确认要更变密码？'),
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
            _handleEditPassword(newPassword: newPassword);
          },
        ),
      ],
    );
  }

  /// 修改密码
  _handleEditPassword({
    String? oldPassword,
    required String newPassword,
  }) async {
    setState(() {
      _loading = true;
    });
    BaseEntity<CommonReturnStates> entity = await changeUserPassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    Navigator.of(context).pop(); // 关闭弹窗
    setState(() {
      _loading = false;
    });
    if (entity.data?.status == true) {
      ToastUtil.shortToast("修改成功");
      Navigator.of(context).pop(); // 返回
    }
  }

  /// 输入事件
  handleChanged({required String type}) {
    if (type == 'psw') {
      if (_passwordErrorHint != '') {
        setState(() {
          _passwordErrorHint = '';
        });
      }
    } else {
      if (_passwordErrorHint2 != '') {
        setState(() {
          _passwordErrorHint2 = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double minHeight = MediaQuery.of(context).size.height - 95;

    return YbScaffold(
      appBarTitle: ('变更密码'),
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
                  YbTextField(
                    labelText: '新密码',
                    hintText: '输入新密码',
                    controller: _passwordController,
                    errorText:
                        _passwordErrorHint == '' ? null : _passwordErrorHint,
                    onChanged: (e) {
                      handleChanged(type: 'psw');
                    },
                    isPassword: true,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  YbTextField(
                    labelText: '确认密码',
                    hintText: '重复输入新密码',
                    controller: _passwordController2,
                    onChanged: (e) {
                      handleChanged(type: 'psw2');
                    },
                    errorText:
                        _passwordErrorHint2 == '' ? null : _passwordErrorHint2,
                    isPassword: true,
                    obscureText: true,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 5,
              left: 0,
              right: 0,
              child: Container(
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
                  text: '提 交',
                  circle: 25,
                  height: 45,
                  textSize: 16,
                  onPressed: _handleSubmit,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordController2.dispose();
    super.dispose();
  }
}
