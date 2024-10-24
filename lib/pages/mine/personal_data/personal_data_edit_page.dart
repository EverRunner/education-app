import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/components/common/yb_scaffold.dart';
import 'package:yibei_app/components/common/yb_text_field.dart';
import 'package:yibei_app/components/common/yb_radio.dart';
import 'package:yibei_app/components/common/yb_date_picker.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/utils/toast_util.dart';
import 'package:yibei_app/utils/cache_util.dart';
import 'package:yibei_app/components/common/yb_button.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/common/common_return_states/common_return_states.dart';
import 'package:yibei_app/models/user/login_user_info/login_user_info.dart';
import 'package:yibei_app/models/user/login_user_info/user_info.dart';

import 'package:yibei_app/api/user.dart';

class PersonalDataEditPage extends StatefulWidget {
  const PersonalDataEditPage({super.key});

  @override
  State<PersonalDataEditPage> createState() => _PersonalDataEditPageState();
}

class _PersonalDataEditPageState extends State<PersonalDataEditPage> {
  /// 姓名文本框
  TextEditingController _nameEditingController = TextEditingController();

  /// 邮编文本框
  TextEditingController _postcodeEditingController = TextEditingController();

  /// 地址文本框
  TextEditingController _addrEditingController = TextEditingController();

  /// 姓名错误提示
  String _nameErrorHint = '';

  /// 邮编错误提示
  String _postcodeErrorHint = '';

  /// 地址错误提示
  String _addrErrorHint = '';

  /// 生日错误提示
  String? _birthdayErrorHint = '';

  /// 姓别
  int _sex = 0;

  /// 生日
  String? _birthday;

  /// 提交的loading
  bool _loading = false;

  /// 处理单选框
  void _handleRadioChanged(int? value) {
    setState(() {
      _sex = value ?? 1;
    });
  }

  /// 处理提交
  _handleSubmit() {
    // 姓名
    if (_nameEditingController.text == '') {
      setState(() {
        _nameErrorHint = '姓名不能为空';
      });
      return;
    }
    // 生日
    if (ybDatePickerKey.currentState?.textFieldController.text == '') {
      setState(() {
        _birthdayErrorHint = '生日不能为空';
      });
      return;
    }
    // 邮编
    if (_postcodeEditingController.text == '') {
      setState(() {
        _postcodeErrorHint = '邮编不能为空';
      });
      return;
    }
    // 地址
    if (_addrEditingController.text == '') {
      setState(() {
        _addrErrorHint = '地址不能为空';
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
      detail: const Text('您确认要修改个人资料吗？'),
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
            _handleEditUserInfo(
              userName: _nameEditingController.text,
              postcode: _postcodeEditingController.text,
              address: _addrEditingController.text,
              birthday: ybDatePickerKey.currentState!.textFieldController.text,
              sex: _sex,
            );
          },
        ),
      ],
    );
  }

  /// 修改用户信息
  _handleEditUserInfo({
    required String userName,
    required String birthday,
    required String postcode,
    required String address,
    required int sex,
  }) async {
    setState(() {
      _loading = true;
    });
    BaseEntity<CommonReturnStates> entity = await updateUserInfo(
      userName: userName,
      postcode: postcode,
      address: address,
      birthday: birthday,
      sex: sex,
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

  /// 输入事件
  _handleChanged({required String type}) {
    switch (type) {
      case 'name':
        if (_nameErrorHint != '') {
          setState(() {
            _nameErrorHint = '';
          });
        }
        break;
      case 'postcode':
        if (_postcodeErrorHint != '') {
          setState(() {
            _postcodeErrorHint = '';
          });
        }
        break;
      case 'addr':
        if (_addrErrorHint != '') {
          setState(() {
            _addrErrorHint = '';
          });
        }
        break;
    }
  }

  /// 清除日期选择的错误提示
  _clearDatePickerErrorHint() {
    setState(() {
      _addrErrorHint = '';
    });
  }

  @override
  void initState() {
    super.initState();

    // 获取用户信息的缓存
    UserInfo? userInfo = CacheUtils.instance.get<UserInfo>('userInfo');

    setState(() {
      _nameEditingController.text = userInfo?.username ?? '';
      _postcodeEditingController.text = userInfo?.youbian ?? '';
      _addrEditingController.text = userInfo?.address ?? '';
      _sex = userInfo?.sex == '1' ? 1 : 0;
      _birthday = userInfo?.birthdayyear != null
          ? DateFormat('yyyy/MM/dd').format(userInfo!.birthdayyear!)
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double minHeight = MediaQuery.of(context).size.height - 95;

    return YbScaffold(
      appBarTitle: ('变更个人资料'),
      bodyPadding: const EdgeInsets.all(0),
      body: Container(
        constraints: BoxConstraints(
          minHeight: minHeight,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 25,
                left: 12,
                right: 12,
              ),
              child: Column(
                children: [
                  YbTextField(
                    controller: _nameEditingController,
                    labelText: '姓名',
                    hintText: '请输入真实姓名',
                    errorText: _nameErrorHint == '' ? null : _nameErrorHint,
                    onChanged: (e) {
                      _handleChanged(type: 'name');
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      YbRadio<int>(
                        value: 0,
                        groupValue: _sex,
                        title: '女性',
                        onChanged: _handleRadioChanged,
                      ),
                      const SizedBox(width: 30),
                      YbRadio<int>(
                        value: 1,
                        groupValue: _sex,
                        title: '男性',
                        onChanged: _handleRadioChanged,
                      ),
                      // YbRadio<int>(
                      //   value: 3,
                      //   groupValue: _sex,
                      //   title: '其他',
                      //   disable: true,
                      // ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  YbDatePicker(
                    key: ybDatePickerKey,
                    labelText: '生日',
                    initValue: _birthday,
                    errorHint: _birthdayErrorHint,
                    clearErrorHint: _clearDatePickerErrorHint,
                  ),
                  const SizedBox(height: 24),
                  YbTextField(
                    controller: _postcodeEditingController,
                    labelText: '邮编',
                    hintText: '输入邮编',
                    keyboardType: TextInputType.number,
                    errorText:
                        _postcodeErrorHint == '' ? null : _postcodeErrorHint,
                    onChanged: (e) {
                      _handleChanged(type: 'postcode');
                    },
                  ),
                  const SizedBox(height: 24),
                  YbTextField(
                    controller: _addrEditingController,
                    labelText: '地址',
                    hintText: '输入具体地址，包含城市、州',
                    maxLines: 2,
                    errorText: _addrErrorHint == '' ? null : _addrErrorHint,
                    onChanged: (e) {
                      _handleChanged(type: 'addr');
                    },
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
            ),
          ],
        ),
      ),
    );
  }
}
