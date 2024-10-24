// import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/components/common/yb_text_field.dart';
import 'package:yibei_app/config/config.dart';
import 'package:yibei_app/utils/toast_util.dart';

import 'package:yibei_app/utils/cache_util.dart';
import 'package:yibei_app/models/bbs/bbs_type_item/bbs_type_item.dart';
import 'package:yibei_app/models/common/coordinates/coordinates.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/models/user/login_user_info/user_info.dart';

import 'package:yibei_app/provider/notifier_provider.dart';
import 'package:yibei_app/components/common/yb_image_upload.dart';

import 'package:yibei_app/api/bbs.dart';

import './cities.dart';

class BbsEditPage extends StatefulWidget {
  const BbsEditPage({super.key});

  @override
  State<BbsEditPage> createState() => _BbsEditPageState();
}

class _BbsEditPageState extends State<BbsEditPage> {
  /// 标题文本框控制器
  final TextEditingController _titleController = TextEditingController();

  /// 内容控制器
  final TextEditingController _contentController = TextEditingController();

  /// 位置（州名字）文本框控制器
  final TextEditingController _locationController = TextEditingController();

  /// 联系人
  final TextEditingController _contactController = TextEditingController();

  /// 联系电话
  final TextEditingController _contactNumberController =
      TextEditingController();

  /// 标题错误提示
  String? _titleErrorHint;

  /// 内容错误提示
  String _contentErrorHint = '';

  /// 位置错误提示
  String _locationCodeErrorHint = '';

  /// 联系人错误提示
  String _contactCodeErrorHint = '';

  /// 联系电话错误提示
  String _contactNumberErrorHint = '';

  /// 工作职位模板
  final List<String> _templateTextList = [
    '本店位於 __ 州 __ 城市，__年正规按摩老店\n招全职/兼职男/女按摩师。\n环境：\n福利：\n特质：\n年龄：\n语言：\n执照：\n其他：',
    '本店位于 __ 州 __ 城市，__年正规按摩老店\n出售/出租。\n环境：\n设备：\n房租：\n售价：\n其他：',
  ];

  /// 城市选择焦点
  FocusNode _cityFocusNode = FocusNode();

  // 轮播图的按钮控制器
  final CarouselController _carouselSlider = CarouselController();

  // 图片列表
  final List<String> _imageList = [];

  /// 帖子类型 租售信息: 6  招工信息: 4
  int _category = 4;

  /// 经度
  String _latitude = '';

  /// 纬度
  String _longitude = '';

  /// 单选按钮
  int _radioButtonValue = 0;

  /// 提交loading
  bool _loading = false;

  /// 处理跳转
  _handleGoto() {
    Navigator.of(context).pop();
  }

  /// 处理点击事件
  void _handleTap() {
    Navigator.pushNamed(context, AppRoutes.bbsAuthorDetailsPage);
  }

  /// 处理打开城市选择
  Future<Result?> _handleOpenCity() async {
    // 取消所有焦点
    FocusScope.of(context).unfocus();

    // 呼出一层, 显示支持字母定位城市选择器
    Result? result = await CityPickers.showCitiesSelector(
      context: context,
      title: '选择洲',
      sideBarStyle: BaseStyle(
        color: AppColors.color8D9199,
        fontSize: 14,
        activeColor: AppColors.color8D9199,
        backgroundActiveColor: AppColors.whiteColor,
      ),
      cityItemStyle: BaseStyle(
        color: AppColors.color1A1C1E,
        fontSize: 16,
      ),
      citiesData: citiesData,
    );

    final Coordinates? coordinates = findCoordinates(result?.cityId ?? '');
    setState(() {
      if (coordinates != null && result != null && result.cityName != null) {
        _latitude = coordinates.latitude ?? '';
        _longitude = coordinates.longitude ?? '';
        _locationController.text = result.cityName ?? '';
      }
    });

    // 选中的返回值
    return result;
  }

  /// 能过key值，获取经纬度
  Coordinates? findCoordinates(String key) {
    final cityData = citiesData.values
        .firstWhere((data) => data.containsKey(key), orElse: () => null);

    if (cityData != null) {
      final coordinates = cityData[key];
      return Coordinates(
        latitude: coordinates['latitude'],
        longitude: coordinates['longitude'],
      );
    } else {
      return null;
    }
  }

  /// 信息项 Widget
  Widget itemInfoWidget({
    required IconData icon,
    required String title,
    String content = '',
    Widget? extraWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: AppColors.colorF1F0F4,
          thickness: 1.0,
          height: 1.0,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.color8D9199,
              size: 12,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.color74777F,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.color1A1C1E,
            height: 1.6,
            fontWeight: FontWeight.bold,
          ),
        ),

        // 额外的内容
        if (extraWidget != null) extraWidget,
        const SizedBox(height: 16),
      ],
    );
  }

  // 当前页
  int _current = 0;

  // final controller = MultiImagePickerController(
  //   maxImages: 10,
  //   withReadStream: true,
  //   allowedImageTypes: ['png', 'jpg', 'jpeg'],
  // );

  /// 间隔线 Widget
  Widget dividerWidget() {
    return Column(
      children: const [
        SizedBox(
          height: 24,
        ),
        Divider(
          color: AppColors.colorF1F0F4,
          thickness: 1.0,
          height: 1.0,
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }

  /// 标签 Widget
  Widget labelWidget({
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.color43474E,
        ),
      ),
    );
  }

  /// 单选按钮 Widget
  Widget radioButtonWidget({
    required String name,
    required int value,
  }) {
    return YbButton(
      text: name,
      icon: _radioButtonValue == value ? Icons.check : null,
      backgroundColor: _radioButtonValue == value
          ? AppColors.colorCCE5FF
          : AppColors.whiteColor,
      borderColor: _radioButtonValue == value
          ? AppColors.colorCCE5FF
          : AppColors.colorC3C6CF,
      textColor: AppColors.color43474E,
      onPressed: () {
        setState(() {
          _radioButtonValue = value;
          _contentController.text = _templateTextList[value];
          if (value == 0) {
            _category = 4; // 招工
          } else {
            _category = 6; // 租售
          }
        });
      },
    );
  }

  /// 处理验证
  _handleVerify() async {
    final String title = _titleController.text;
    final String content = _contentController.text;
    final String location = _locationController.text;
    final String contact = _contactController.text;
    final String contactNumber = _contactNumberController.text;
    final String images =
        ybImageUploadKey.currentState!.getImageList().join(',');

    if (images == '') {
      ToastUtil.shortToast("请至少上传1张图片");
      return;
    }
    if (title == '') {
      setState(() {
        _titleErrorHint = '请输入标题';
      });
      return;
    }
    if (content == '') {
      setState(() {
        _contentErrorHint = '请输入内容';
      });
      return;
    }
    if (location == '') {
      setState(() {
        _locationCodeErrorHint = '请选择位置';
      });
      return;
    }
    if (contact == '') {
      setState(() {
        _contactCodeErrorHint = '请输入联系人';
      });
      return;
    }
    if (contactNumber == '') {
      setState(() {
        _contactNumberErrorHint = '请输入联系电话';
      });
      return;
    }

    _handleSubmit(
      category: _category,
      images: images,
      title: title,
      content: content,
      contact: contact,
      contactNumber: contactNumber,
      location: location,
      latitude: _latitude,
      longitude: _longitude,
    );
  }

  /// 处理提交
  _handleSubmit({
    required String images,
    required String title,
    required int category,
    required String content,
    required String contact,
    required String contactNumber,
    required String location,
    required String latitude,
    required String longitude,
  }) {
    onShowAlertDialog(
      context: context,
      title: '免责声明',
      actionsPadding: const EdgeInsets.only(
        bottom: 15,
        right: 20,
      ),
      detail: Column(
        mainAxisSize: MainAxisSize.min, // 垂直方向上自适应文本内容高度
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
              '您在本平台发布的言论若涉及人身攻击和威胁、性暗示及暴力、明显违反善良风俗、法律禁止或限制的事项，所产生的一切后果与本平台无关，由用户自行承担。'),
          Padding(
            padding: EdgeInsets.only(top: 25),
            child: Text('本平台管理员有权保留或删除本平台的任何内容。'),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text(
            '不同意',
            style: TextStyle(color: AppColors.color8D9199),
          ),
          onPressed: () {
            Navigator.pop(context); // 关闭弹窗
          },
        ),
        YbButton(
          text: '同意并发布',
          circle: 25,
          disabled: _loading,
          onPressed: () {
            addPost(
              category: category,
              images: images,
              title: title,
              content: content,
              contact: contact,
              contactNumber: contactNumber,
              location: location,
              latitude: latitude,
              longitude: longitude,
            );
            Navigator.pop(context); // 关闭弹窗
            Navigator.pop(context); // 退出当前页面
            ToastUtil.shortToast("发布成功！");
          },
        ),
      ],
    );
  }

  /// 输入事件
  handleChanged({required String type}) {
    setState(() {
      switch (type) {
        case 'title':
          if (_titleErrorHint != '') {
            _titleErrorHint = '';
          }
          break;
        case 'content':
          if (_contentErrorHint != '') {
            _contentErrorHint = '';
          }
          break;
        case 'location':
          if (_locationCodeErrorHint != '') {
            _locationCodeErrorHint = '';
          }
          break;
        case 'contact':
          if (_contactCodeErrorHint != '') {
            _contactCodeErrorHint = '';
          }
          break;
        case 'contactNumber':
          if (_contactNumberErrorHint != '') {
            _contactNumberErrorHint = '';
          }
          break;
      }
    });
  }

  /// 处理退出页面
  void _handleOutPage() {
    onShowAlertDialog(
      context: context,
      title: '确定要退出此次编辑？',
      detail: const Text('若退出此次编辑，您已输入的内容将不会被保存。'),
      actions: <Widget>[
        TextButton(
          child: const Text(
            '取消',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryColor,
            ),
          ),
          onPressed: () {
            Navigator.pop(context); // 关闭弹窗
          },
        ),
        TextButton(
          child: const Text(
            '退出',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.colorBA1A1A,
            ),
          ),
          onPressed: () {
            Navigator.pop(context); // 关闭弹窗
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    _contentController.text = _templateTextList[_radioButtonValue];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleOutPage();
        // 返回 false，阻止直接退出应用程序
        return false;
      },
      child: GestureDetector(
        onTap: () {
          // 关闭键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.close,
                size: 24,
                color: AppColors.color43474E,
              ),
              onPressed: _handleOutPage,
            ),
            iconTheme: const IconThemeData(
              color: AppColors.color1A1C1E,
              size: 18,
            ),
            backgroundColor: AppColors.whiteColor,
            elevation: 0, // 取消阴影
            title: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '发布帖子',
                style: TextStyle(
                  color: AppColors.color1A1C1E,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          backgroundColor: AppColors.whiteColor,
          bottomNavigationBar: Container(
            color: AppColors.whiteColor,
            height: 60,
          ),
          floatingActionButton: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: AppColors.colorC3C6CF,
                  width: 1.0,
                ),
              ),
            ),
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            child: YbButton(
              text: '发布',
              circle: 30,
              onPressed: _handleVerify,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelWidget(text: '上传图片 (最少1张，最多6张)'),
                  YbImageUpload(
                    imageList: _imageList,
                    maxLength: 6,
                    key: ybImageUploadKey,
                  ),
                  dividerWidget(),
                  YbTextField(
                    labelText: '标题',
                    hintText: '输入标题',
                    controller: _titleController,
                    errorText: _titleErrorHint == '' ? null : _titleErrorHint,
                    onChanged: (e) {
                      handleChanged(type: 'title');
                    },
                  ),
                  dividerWidget(),
                  labelWidget(text: '发帖模版'),
                  Row(
                    children: [
                      radioButtonWidget(
                        name: '工作职缺模板',
                        value: 0,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      radioButtonWidget(
                        name: '出售出租模板',
                        value: 1,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  YbTextField(
                    labelText: '内容',
                    hintText: '输入内容',
                    maxLines: 11,
                    controller: _contentController,
                    keyboardType: TextInputType.multiline,
                    maxLength: 200,
                    errorText:
                        _contentErrorHint == '' ? null : _contentErrorHint,
                    onChanged: (e) {
                      handleChanged(type: 'content');
                    },
                  ),
                  dividerWidget(),
                  YbTextField(
                    labelText: '位置',
                    hintText: '选择州',
                    readOnly: true,
                    controller: _locationController,
                    onTap: () {
                      _handleOpenCity();
                    },
                    onChanged: (e) {
                      handleChanged(type: 'location');
                    },
                    suffixIcon: const Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.color43474E,
                      size: 24,
                    ),
                    errorText: _locationCodeErrorHint == ''
                        ? null
                        : _locationCodeErrorHint,
                  ),
                  dividerWidget(),
                  YbTextField(
                    labelText: '联系人',
                    hintText: '输入联系人姓名',
                    controller: _contactController,
                    errorText: _contactCodeErrorHint == ''
                        ? null
                        : _contactCodeErrorHint,
                    onChanged: (e) {
                      handleChanged(type: 'contact');
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  YbTextField(
                    labelText: '联系电话',
                    hintText: '输入联系电话',
                    keyboardType: TextInputType.phone,
                    controller: _contactNumberController,
                    errorText: _contactNumberErrorHint == ''
                        ? null
                        : _contactNumberErrorHint,
                    onChanged: (e) {
                      handleChanged(type: 'contactNumber');
                    },
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }
}
