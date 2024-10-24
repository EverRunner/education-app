import 'package:flutter/material.dart';
import 'package:yibei_app/utils/colors_util.dart';

class DialogPicSelect extends StatelessWidget {
  Function(String) onTap;
  List<String> dataSource;
  double? height;

  DialogPicSelect(this.dataSource, {Key? key, this.height, required this.onTap})
      : super(key: key);

  /// Text w600
  Widget LText(String text,
      {int? maxLines,
      double? fontSize = 16,
      TextOverflow? overflow = TextOverflow.ellipsis,
      Color? color = Colors.red,
      FontWeight? fontWeight = FontWeight.normal,
      TextAlign? textAlign}) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 10, bottom: MediaQuery.of(context).padding.bottom),
      width: double.infinity,
      height: height ?? 0,
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: ListView.separated(
          itemBuilder: (context, index) {
            if (index == dataSource.length) {
              return _alertItemWidgt(
                  context, '取消', () => Navigator.pop(context));
            }
            return _alertItemWidgt(
                context, dataSource[index], () => onTap(dataSource[index]));
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 1,
            );
          },
          itemCount: dataSource.length + 1),
    );
  }

  Widget _alertItemWidgt(BuildContext context, String title, onPress) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        alignment: Alignment.center,
        child: LText(
          title,
          fontSize: 16,
          color: title == '取消' ? AppColors.primaryColor : AppColors.color1A1C1E,
        ),
      ),
    );
  }
}
