import 'package:flutter/material.dart';
import 'package:yibei_app/utils/colors_util.dart';

///  搜索框
class YbSearchBox extends StatefulWidget {
  final Function(String text) onSubmitted;

  YbSearchBox({
    super.key,
    required this.onSubmitted,
  });

  @override
  State<YbSearchBox> createState() => _YbSearchBoxState();
}

class _YbSearchBoxState extends State<YbSearchBox> {
  TextEditingController _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      decoration: const BoxDecoration(
        color: AppColors.colorE4EAF5,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: TextField(
        controller: _searchTextController,
        decoration: const InputDecoration(
          hintText: '搜索资源',
          icon: Icon(
            Icons.search,
            color: AppColors.color43474E,
          ),
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        textInputAction: TextInputAction.search,
        onEditingComplete: () {
          widget.onSubmitted(_searchTextController.text);
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }
}
