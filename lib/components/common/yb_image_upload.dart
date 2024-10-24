import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/utils/permission_util.dart';
import 'package:yibei_app/utils/toast_util.dart';
import 'package:yibei_app/api/common.dart';
import 'package:yibei_app/models/common/upload_file/upload_file.dart';
import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/config/config.dart';

/// 父组件可获取该值，操作子组件的函数
GlobalKey<_YbImageUploadState> ybImageUploadKey = GlobalKey();

class YbImageUpload<T> extends StatefulWidget {
  /// 图片列表
  final List<String> imageList;

  /// 最大上传数量
  final int maxLength;

  const YbImageUpload({
    Key? key,
    required this.imageList,
    this.maxLength = 99,
  }) : super(key: key);

  @override
  _YbImageUploadState<T> createState() => _YbImageUploadState<T>();
}

class _YbImageUploadState<T> extends State<YbImageUpload<T>> {
  /// 图片列表
  List<String> _imageList = [];

  /// 获取图片列表
  getImageList() {
    return _imageList;
  }

  /// 打开相册
  /// [isMulti] 是否多选
  _handleOpenImagePicker({
    bool isMulti = false,
  }) async {
    // onShowBottomListDialog(
    //   context,
    //   ['预览', '删除'],
    //   (value) {
    //     print('21321${value}');
    //   },
    // );

    // 权限判断
    bool permition = await getPhotoPormiation();
    if (!permition) {
      ToastUtil.shortToast('请打开相册权限');
      return;
    }

    // 图片选择器
    final ImagePicker picker = ImagePicker();

    if (isMulti) {
      // 多选图片
      List<XFile?>? imageList = await picker.pickMultiImage();

      print("多选图片 => ${imageList}");

      if (imageList != null && imageList.isNotEmpty) {
        imageList.map((image) {
          print("多选图片 => ${image?.path}");
        });
        // setState(() {
        //   _imageList.addAll(imageList)
        // });
      }
    } else {
      // 单选图片
      XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null && image.path.isNotEmpty) {
        BaseEntity<UploadFile> entity = await uploadImage(
          filePath: image.path,
        );
        if (entity.data?.path != null) {
          setState(() {
            _imageList.add(entity.data!.path!);
          });
        }
      }
    }
  }

  /// 图片加载中显示的widget
  Widget _imagePlaceholder() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
        ],
      ),
    );
  }

  /// 图片列表 Widget
  List<Widget>? _imgListWidget({
    required List<String> imgList,
  }) {
    List<Widget> widgets = imgList
        .map((url) => Container(
              margin: const EdgeInsets.only(right: 15),
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.colorC3C6CF),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // 可选设置圆角
                    child: CachedNetworkImage(
                      width: 112,
                      height: 112,
                      fit: BoxFit.cover, // 设置图片适应方式
                      imageUrl: '${Config.file_root}$url',
                      placeholder: (context, url) =>
                          _imagePlaceholder(), // 加载中显示的widget
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error), // 加载失败显示的widget
                    ),
                    // Image.network(
                    //   width: 112,
                    //   height: 112,
                    //   '${Config.file_root}$url', // 图片的URL或本地路径
                    //   fit: BoxFit.cover, // 设置图片适应方式
                    // ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: AppColors.blackColor.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () {
                          handleDeleteImage(url);
                        },
                        child: const Icon(
                          Icons.close,
                          color: AppColors.whiteColor,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
    return widgets;
  }

  /// 图片上传 Widget
  Widget _imgUploadWidget() {
    return InkWell(
      onTap: _handleOpenImagePicker,
      child: Container(
        width: 112,
        height: 112,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.colorC3C6CF),
        ),
        child: const Center(
          child: Icon(
            Icons.file_upload_outlined,
            color: AppColors.colorC3C6CF,
          ),
        ),
      ),
    );
  }

  /// 删除图片
  void handleDeleteImage(String imgUrl) {
    setState(() {
      _imageList = _imageList.where((url) => url != imgUrl).toList();
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _imageList = widget.imageList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // 水平滚动
      child: Row(
        children: [
          ..._imgListWidget(imgList: _imageList)!.toList(),
          if (_imageList.length < widget.maxLength) _imgUploadWidget(),
        ],
      ),
    );
  }
}
