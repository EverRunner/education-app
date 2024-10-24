import 'package:flutter/material.dart';
import '../../../utils/colors_util.dart';
import 'package:flutter_html/flutter_html.dart';

class YbRadio<T> extends StatefulWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?>? onChanged;
  final String title;
  final bool disable;
  final Color iconColor;
  final Color activeColor;
  final Color titleColor;
  final bool? isHtml;

  const YbRadio({
    Key? key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    required this.title,
    this.iconColor = AppColors.color43474E,
    this.activeColor = AppColors.primaryColor,
    this.titleColor = AppColors.color1A1C1E,
    this.disable = false,
    this.isHtml = false,
  }) : super(key: key);

  @override
  _YbRadioState<T> createState() => _YbRadioState<T>();
}

class _YbRadioState<T> extends State<YbRadio<T>> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.disable
          ? null
          : () {
              if (widget.value != widget.groupValue) {
                widget.onChanged!(widget.value);
              }
            },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 10,
        ),
        child: Row(
          children: [
            Icon(
              widget.value == widget.groupValue
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: widget.value == widget.groupValue
                  ? widget.activeColor
                  : widget.iconColor,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: widget.isHtml == true
                  ? Html(
                      data: widget.title,
                      style: {
                        "body": Style(
                          fontSize: FontSize(16),
                          lineHeight: const LineHeight(1.5),
                          color: widget.titleColor,
                        ),
                      },
                    )
                  : Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.titleColor,
                        height: 1.5,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
