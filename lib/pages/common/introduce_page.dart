import 'package:flutter/material.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/utils/cache_util.dart';
import 'package:yibei_app/provider/notifier_provider.dart';

// app介绍页面

class IntroducePage extends StatefulWidget {
  final bool showBack;

  const IntroducePage({
    super.key,
    this.showBack = false,
  });

  @override
  State<IntroducePage> createState() => _IntroducePageState();
}

class _IntroducePageState extends State<IntroducePage> {
  // 轮播图的按钮控制器
  final CarouselController _carouselSlider = CarouselController();

  // 图片列表
  final List<String> imageList = [
    'lib/assets/images/introduce_banner2.png',
    'lib/assets/images/introduce_banner1.png',
    'lib/assets/images/introduce_banner3.png',
  ];

  // 当前页
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 70),
            child: Text(
              '关于易北教育',
              style: TextStyle(
                fontSize: 28,
                color: AppColors.blackColor,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          CarouselSlider(
            items: imageList.map((url) {
              return Container(
                margin: const EdgeInsets.only(left: 40, right: 40),
                child: Image.asset(url),
              );
            }).toList(),
            carouselController: _carouselSlider,
            options: CarouselOptions(
              height: 300.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, right: 40, left: 40),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => _carouselSlider.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.colorC3C6CF,
                      size: 36,
                    ),
                  ),
                  Row(
                    children: imageList.map((url) {
                      int index = imageList.indexOf(url);
                      return Container(
                        width: 6.0,
                        height: 6.0,
                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? AppColors.color43474E
                              : AppColors.colorC3C6CF,
                        ),
                      );
                    }).toList(),
                  ),
                  InkWell(
                    onTap: () => _carouselSlider.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: AppColors.colorC3C6CF,
                      size: 36,
                    ),
                  ),
                ]),
          ),
          // ElevatedButton(
          //   onPressed: () => _carouselSlider.nextPage(
          //       duration: Duration(milliseconds: 300), curve: Curves.linear),
          //   child: Text('→'),
          // )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
        child: YbButton(
          text: widget.showBack ? '返回学习' : '开始学习',
          circle: 25,
          height: 45,
          textSize: 14,
          onPressed: () {
            if (widget.showBack) {
              Navigator.of(context).pop();
            } else {
              // 是否已经打开过了
              CacheUtils.instance.set<bool>('isAlreadyOpen', true);

              // 跳转主页
              jumpPageProvider.value = 3;
            }
          },
        ),
      ),
    );
  }
}
