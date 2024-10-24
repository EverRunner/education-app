import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:pod_player/pod_player.dart';

import 'package:flutter/material.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:yibei_app/config/config.dart';

import 'package:yibei_app/provider/notifier_provider.dart';

/// 登录页

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  // 视频控制器
  late final PodPlayerController _videoIndexController;

  // 视频加载
  bool _videoLoading = true;

  // 图片列表1
  final List<String> _carouselImageList1 = [
    'lib/assets/images/img_xueyuan1.jpg',
    'lib/assets/images/img_xueyuan2.jpg',
    'lib/assets/images/img_xueyuan3.jpg',
  ];

  // 图片列表2
  final List<String> _carouselImageList2 = [
    'lib/assets/images/img_xueyuan4.jpg',
    'lib/assets/images/img_xueyuan5.jpg',
    'lib/assets/images/img_xueyuan6.jpg',
  ];

  /// 跳转到页页面
  handleGoto() {
    Navigator.pushNamed(
      context,
      AppRoutes.register,
    );
  }

  /// 视频播放初始化
  /// [videoUrl] 视频的地址
  videoPlayInit({
    required String videoUrl,
  }) {
    // 使用正则获取视频的id
    final pattern = RegExp(r'\/video\/(\d+)');
    final match = pattern.firstMatch(videoUrl);
    final videoId = match?.group(1);
    if (videoId == null || videoId == '') return;

    final Map<String, String> headers = <String, String>{};
    headers['Authorization'] = 'Bearer ${Config.vimeo_access_token}';

    setState(() {
      _videoIndexController = PodPlayerController(
        playVideoFrom: PlayVideoFrom.vimeoPrivateVideos(
          videoId,
          httpHeaders: headers,
        ),
      )..initialise();
      _videoLoading = false;
    });
  }

  // 图文Widget
  Widget imageTextWidget({
    required List<TextSpan> textWidgetList,
    required Color indexColor,
    required String index,
    required String imgUrl,
    bool isShowBorder = true,
  }) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 30,
              bottom: 20,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    index,
                    style: TextStyle(
                      fontSize: 90,
                      color: indexColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.blackColor,
                        height: 1.6,
                        letterSpacing: 1,
                      ),
                      children: textWidgetList,
                    ),
                  ),
                )
              ],
            ),
          ),
          Image.asset(imgUrl),
          SizedBox(
            height: isShowBorder ? 30 : 5,
          ),
          if (isShowBorder)
            Container(
              height: 1,
              color: AppColors.blackColor.withOpacity(0.1),
            )
        ],
      ),
    );
  }

  /// 无序列表
  Widget ulWidget({
    required String text,
    Color? textColor = AppColors.blackColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 12,
            child: Text(
              '·',
              style: TextStyle(
                fontSize: 22,
                color: textColor,
                height: 1.2,
              ),
            ),
          ),
          Expanded(
              child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
              height: 1.5,
              letterSpacing: 1,
            ),
          ))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    videoPlayInit(
      videoUrl: 'https://player.vimeo.com/video/845937855?h=f78f1dcc1f',
    );
  }

  @override
  void dispose() {
    // 暂停视频
    _videoIndexController?.pause();

    // 销毁视频
    _videoIndexController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // 设置为0表示不显示AppBar
        child: AppBar(
          backgroundColor: AppColors.whiteColor,
          elevation: 0.0, // 设置阴影为0.0
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                bottom: 170,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 30,
                          ),
                          child: Center(
                            child: Image.asset(
                              'lib/assets/images/logo.png',
                              height: 30,
                            ),
                          ),
                        ),

                        // 易北 MBLEx
                        RichText(
                          text: const TextSpan(
                            text: '易北 MBLEx 美国联邦按摩考试辅导课程，让英文',
                            style: TextStyle(
                              fontSize: 26,
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.bold,
                              height: 1.6,
                              letterSpacing: 1,
                            ),
                            children: [
                              TextSpan(
                                text: '0基础',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              TextSpan(
                                text: '的华人按摩师，也能',
                              ),
                              TextSpan(
                                text: '轻松',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              TextSpan(
                                text: '通过考试！',
                              ),
                            ],
                          ),
                        ),

                        // 只需要一台
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          child: RichText(
                            text: const TextSpan(
                              text: '只需要一台手机或电脑，您就可以随时随地学习，完全',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.color74777F,
                                height: 1.5,
                                letterSpacing: 1,
                              ),
                              children: [
                                TextSpan(
                                  text: '不耽误',
                                  style:
                                      TextStyle(color: AppColors.primaryColor),
                                ),
                                TextSpan(
                                  text: '生活和工作！',
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 视频
                        if (!_videoLoading)
                          PodVideoPlayer(controller: _videoIndexController),

                        Padding(
                          padding: const EdgeInsets.only(
                            top: 40,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              YbButton(
                                text: '查看付费课程',
                                circle: 30,
                                backgroundColor: AppColors.whiteColor,
                                textColor: AppColors.primaryColor,
                                onPressed: () {
                                  // 暂停视频
                                  _videoIndexController?.pause();
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.indexCourseList,
                                  );
                                },
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              YbButton(
                                text: '查看付费资源',
                                circle: 30,
                                backgroundColor: AppColors.whiteColor,
                                textColor: AppColors.primaryColor,
                                onPressed: () {
                                  // 暂停视频
                                  _videoIndexController?.pause();
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.indexResource,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        // 考过展示照片
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: CarouseWidget(
                            imageList: _carouselImageList1,
                          ),
                        ),

                        // 这些是不是你的情况
                        Container(
                          margin: const EdgeInsets.only(top: 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 30,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.colorEBF1FF,
                          ),
                          child: Column(
                            children: [
                              RichText(
                                text: const TextSpan(
                                  text: '这些是不是你的',
                                  style: TextStyle(
                                    fontSize: 26,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.bold,
                                    height: 1.6,
                                    letterSpacing: 1,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '情况',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '?',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RichText(
                                text: const TextSpan(
                                  text: '很多学员在来易北之前，听了很多课，买了很多书，背了很多题；却',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.blackColor,
                                    height: 1.8,
                                    letterSpacing: 1,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '越学越混乱，越学越没信心',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '，一提起联邦考试和按摩执照，就愁云密布。',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RichText(
                                text: const TextSpan(
                                  text:
                                      '还有一些学员，因为英文不好，听不懂课，只好机械刷题，结果去参加了好多次考试，都以失败告终。花费了高额的考试费（每次',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.blackColor,
                                    height: 1.8,
                                    letterSpacing: 1,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '\$265',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '）不说，更浪费了宝贵的时间。做工少了，小费也少了，更不要说打击自信心，有人愁得头发都快掉光了！',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RichText(
                                text: const TextSpan(
                                  text:
                                      '年纪稍微大一点的按摩师，更是苦不堪言，语言基础不好就算了，记忆力和理解能力也赶不上年轻人，加上老师讲得不清不楚，书里的知识点又是全英文的，根本就看不懂，只好埋头当鸵鸟，',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.blackColor,
                                    height: 1.8,
                                    letterSpacing: 1,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '祈祷自己不会因为无证做工而被抓。',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),

                        // 你敢承担无证做工被抓的风险吗
                        Container(
                          margin: const EdgeInsets.only(top: 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 30,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.primaryColor,
                          ),
                          child: Column(
                            children: [
                              const Text(
                                '你敢承担无证做工',
                                style: TextStyle(
                                  fontSize: 26,
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  height: 1.6,
                                  letterSpacing: 1,
                                ),
                              ),
                              RichText(
                                text: const TextSpan(
                                  text: '被抓的',
                                  style: TextStyle(
                                    fontSize: 26,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    height: 1.6,
                                    letterSpacing: 1,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '风险',
                                      style: TextStyle(
                                        color: AppColors.warningColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '吗?',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RichText(
                                text: const TextSpan(
                                  text:
                                      '这两年来，按摩局查得越来越严，无证做工的风险也越来越高，按摩考试也越来越难。以前背背题就能凭运气考过，现在只有考试大纲，）',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.whiteColor,
                                    height: 1.8,
                                    letterSpacing: 1,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '完全没有原题',
                                      style: TextStyle(
                                        color: AppColors.warningColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '，那些想靠刷题和运气通过联邦考试的学员也越来越无望。（如果有人向你兜售按摩考试“原题”，别信他，一定是骗子！',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),

                        // 易北考过的都是学霸吗
                        Container(
                          margin: const EdgeInsets.only(top: 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 30,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.colorEBF1FF,
                          ),
                          child: Column(
                            children: [
                              const Text(
                                '易北考过的学员',
                                style: TextStyle(
                                  fontSize: 26,
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.bold,
                                  height: 1.6,
                                  letterSpacing: 1,
                                ),
                              ),
                              RichText(
                                text: const TextSpan(
                                  text: '都是',
                                  style: TextStyle(
                                    fontSize: 26,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.bold,
                                    height: 1.6,
                                    letterSpacing: 1,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '学霸',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '吗?',
                                    ),
                                  ],
                                ),
                              ),
                              imageTextWidget(
                                index: '01',
                                imgUrl: 'lib/assets/images/img_wx1.jpg',
                                textWidgetList: const [
                                  TextSpan(
                                    text: '在易北，我们有',
                                  ),
                                  TextSpan(
                                    text: '连英文的123都分不清',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '的学员，在学习一个半月之后，一举通过考试。',
                                  ),
                                ],
                                indexColor: AppColors.color77ADF9,
                              ),
                              imageTextWidget(
                                index: '02',
                                imgUrl: 'lib/assets/images/img_wx2.jpg',
                                textWidgetList: const [
                                  TextSpan(
                                    text: '在易北，我们年龄最大的学员。',
                                  ),
                                  TextSpan(
                                    text: '超过了60岁',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '，只学了两个月就通过了考试',
                                  ),
                                ],
                                indexColor: AppColors.color77ADF9,
                              ),
                              imageTextWidget(
                                index: '03',
                                imgUrl: 'lib/assets/images/img_wx3.jpg',
                                textWidgetList: const [
                                  TextSpan(
                                    text: '在易北，我们有边工作边照顾两个孩子的单亲妈妈，',
                                  ),
                                  TextSpan(
                                    text: '利用碎片时间',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '，花了半年时间成功拿到了按摩执照。',
                                  ),
                                ],
                                indexColor: AppColors.color77ADF9,
                              ),
                              imageTextWidget(
                                index: '04',
                                imgUrl: 'lib/assets/images/img_wx4.jpg',
                                textWidgetList: const [
                                  TextSpan(
                                    text:
                                        '在易北，我们还有考了8次都没考过，已经绝望的学员，在张老师的鼓励下，重新开始，',
                                  ),
                                  TextSpan(
                                    text: '一次考过。',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                                indexColor: AppColors.color77ADF9,
                                isShowBorder: false,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 在易北，年龄大
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.all(40),
                    color: AppColors.color00315E,
                    child: const Text(
                      '在易北，年龄大、英文0基础、记性不好、理解能力差，这些都不是问题。唯一的问题是： 你是否已经放弃了联邦考试？',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.whiteColor,
                        height: 1.8,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // 易北的考试通过率为什么会这么高？
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        RichText(
                          text: const TextSpan(
                            text: '易北的考试通过率为什么会',
                            style: TextStyle(
                              fontSize: 26,
                              color: AppColors.blackColor,
                              height: 1.5,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: '这么高',
                                style: TextStyle(
                                  color: AppColors.warningColor,
                                ),
                              ),
                              TextSpan(
                                text: '？',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RichText(
                          text: const TextSpan(
                            text: '我们的自信，源自我们的实力。能达到',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.blackColor,
                              height: 1.5,
                              letterSpacing: 1,
                            ),
                            children: [
                              TextSpan(
                                text: '全美最高的考试通过率',
                                style: TextStyle(
                                  color: AppColors.warningColor,
                                ),
                              ),
                              TextSpan(
                                text: '，我们靠的，可不是运气。',
                              ),
                            ],
                          ),
                        ),

                        // 针对华人按摩师英语能力
                        Container(
                          margin: const EdgeInsets.only(top: 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 30,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.colorFFF8F3,
                          ),
                          child: Column(
                            children: [
                              const Text(
                                '针对华人按摩师英语能力 普遍偏弱的情况',
                                style: TextStyle(
                                  fontSize: 26,
                                  color: AppColors.color7C5800,
                                  fontWeight: FontWeight.bold,
                                  height: 1.6,
                                  letterSpacing: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              imageTextWidget(
                                index: '01',
                                imgUrl: 'lib/assets/images/image1.png',
                                textWidgetList: const [
                                  TextSpan(
                                    text: '我们采用',
                                  ),
                                  TextSpan(
                                    text: '中英双语的视频',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '讲解方法，让学员真正学懂要考的知识点！',
                                  ),
                                ],
                                indexColor: AppColors.warningColor,
                              ),
                              imageTextWidget(
                                index: '02',
                                imgUrl: 'lib/assets/images/image2.png',
                                textWidgetList: const [
                                  TextSpan(
                                    text: '我们采用',
                                  ),
                                  TextSpan(
                                    text: '趣味记单词',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '的方法，用有趣的、通俗易懂的方式，帮大家轻松背下专业词汇！',
                                  ),
                                ],
                                indexColor: AppColors.warningColor,
                              ),
                              imageTextWidget(
                                index: '03',
                                imgUrl: 'lib/assets/images/image3.png',
                                textWidgetList: const [
                                  TextSpan(
                                    text: '我们还有独家研发的',
                                  ),
                                  TextSpan(
                                    text: '关键词记忆法',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '，让同学们只用背下题目中的关键词，而不是整个题目，不仅仅减轻了记忆负担，更可以应对题目的不断变化！',
                                  ),
                                ],
                                indexColor: AppColors.warningColor,
                                isShowBorder: false,
                              ),
                            ],
                          ),
                        ),

                        // 针对记性不好、学了又忘的学员
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 30,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.colorFFEED8,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  bottom: 20,
                                ),
                                child: Text(
                                  '针对记性不好、学了又忘的学员',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.color7C5800,
                                    fontWeight: FontWeight.bold,
                                    height: 1.8,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              ulWidget(text: '我们以理解促记忆，理解，永远是最好的记忆方式！'),
                              ulWidget(
                                  text:
                                      '我们先在视频课程中讲解题目和对应的知识点，然后利用中英单词卡片，反复记忆关键词，再对每个小节的知识点进行测验，从头开始就把知识点学扎实，不怕您学了又忘！'),
                              ulWidget(
                                  text:
                                      '我们还研发了易北独家的错题集，学完章节知识后，您可以集中复习所有做错的题目，还能参考所有学员都容易做错的题目，精准而高效地查缺补漏！'),
                            ],
                          ),
                        ),

                        // 针对年龄偏大的学员
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 30,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.colorFFF8F3,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  bottom: 20,
                                ),
                                child: Text(
                                  '针对年龄偏大的学员',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.color7C5800,
                                    fontWeight: FontWeight.bold,
                                    height: 1.8,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              ulWidget(
                                  text:
                                      '我们采用录播课程的授课方式，听不懂的地方可以倒回去反复听，不用担心跟不上其他学员的节奏。'),
                              ulWidget(
                                  text:
                                      '我们有 24 小时微信学习群，不理解的知识点或者不会的题目，随时都可以在微信上提问，我们会有专业的老师和热心的同学随时解答您的疑问。'),
                            ],
                          ),
                        ),

                        // 针对没时间学习的学员
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 30,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.colorFFEED8,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  bottom: 20,
                                ),
                                child: Text(
                                  '针对没时间学习的学员',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.color7C5800,
                                    fontWeight: FontWeight.bold,
                                    height: 1.8,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              ulWidget(
                                  text:
                                      '我们采用远程授课的方式，只要有手机或者电脑，就能随时登陆系统进行学习，不再需要舟车劳顿，也不会占用您做工或者带孩子的时间。'),
                              ulWidget(
                                  text:
                                      '我们的系统设立了各种小任务，您只需要跟随我们的脚步，利用碎片时间也能轻松学完课程，甚至做工的时候还能用耳机收听我们的视频课程，高效利用时间！'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 此外，我们还有易北独家研发的智能追踪系统。
                  Container(
                    color: AppColors.color7C5800,
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsetsDirectional.only(
                            bottom: 30,
                          ),
                          child: Text(
                            '此外，我们还有易北独家研\n发的智能追踪系统。',
                            style: TextStyle(
                              fontSize: 22,
                              color: AppColors.whiteColor,
                              height: 1.5,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ulWidget(
                          text:
                              '我们采用远程授课的方式，只要有手机或者电脑，就能随时登陆系统进行学习，不再需要舟车劳顿，也不会占用您做工或者带孩子的时间。',
                          textColor: AppColors.whiteColor,
                        ),
                        ulWidget(
                          text:
                              '我们的系统设立了各种小任务，您只需要跟随我们的脚步，利用碎片时间也能轻松学完课程，甚至做工的时候还能用耳机收听我们的视频课程，高效利用时间！',
                          textColor: AppColors.whiteColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child:
                              Image.asset('lib/assets/images/img_zlzzxt.png'),
                        )
                      ],
                    ),
                  ),

                  // 常见问题
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 40,
                    ),
                    child: Column(
                      children: const [
                        Text(
                          '常见问题',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MyExpansionPanelList(),
                      ],
                    ),
                  ),

                  // 早考过早解脱
                  Container(
                    color: AppColors.colorEBF1FF,
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsetsDirectional.only(
                            bottom: 30,
                          ),
                          child: Text(
                            '早考过早解脱！',
                            style: TextStyle(
                              fontSize: 28,
                              color: AppColors.primaryColor,
                              height: 1.5,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Text(
                          '早日通过联邦考试，拿到按摩执照，不再为无证做工被抓而担忧，不再为考试而失眠掉发，考虑到这些，您还觉得我们的课程贵吗？',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.color74777F,
                            height: 1.6,
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: CarouseWidget(
                            imageList: _carouselImageList2,
                            imageHeigth: 400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 联系易北
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 40),
                    child: Column(
                      children: [
                        const Text(
                          '联系易北',
                          style: TextStyle(
                            fontSize: 28,
                            height: 1.5,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            text: '如果您对课程还有其他的疑问，\n可以添加',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.blackColor,
                              height: 1.6,
                              letterSpacing: 1,
                            ),
                            children: [
                              TextSpan(
                                text: '张老师微信',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              TextSpan(
                                text: '，\n或者直接拨打',
                              ),
                              TextSpan(
                                text: '电话咨询',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              TextSpan(
                                text: '，\n我们可以回答您的一切问题！',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'lib/assets/images/img_xulaoshi.png',
                              height: 80,
                            ),
                            const SizedBox(width: 20),
                            Column(
                              children: const [
                                Text(
                                  '易北教育',
                                  style: TextStyle(
                                    fontSize: 22,
                                    height: 1.5,
                                    letterSpacing: 1,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(width: 20),
                                Text(
                                  '张老师',
                                  style: TextStyle(
                                    fontSize: 22,
                                    height: 1.5,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 40),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: AppColors.colorE0E2EC, // 设置边框颜色
                                width: 1.0, // 设置边框宽度
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'lib/assets/images/ico_wechat.png',
                                    height: 40,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, bottom: 5),
                                    child: Text(
                                      'ybmblex',
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.color2EC100,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Image.asset(
                                'lib/assets/images/image_13.png',
                                height: 160,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 40),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: AppColors.colorE0E2EC, // 设置边框颜色
                                width: 1.0, // 设置边框宽度
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'lib/assets/images/ico_phone.png',
                                    height: 40,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, bottom: 5),
                                    child: Text(
                                      '(702) 892-7688',
                                      style: TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0, // 改变此值来调整按钮的位置
            left: 0, // 改变此值来调整按钮的位置
            right: 0,
            child: Container(
              color: AppColors.primaryColor,
              padding: const EdgeInsets.only(
                top: 24,
                bottom: 40,
                left: 24,
                right: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  YbButton(
                    text: '注册购买',
                    textSize: 16,
                    height: 45,
                    width: double.infinity,
                    backgroundColor: AppColors.whiteColor,
                    textColor: AppColors.primaryColor,
                    circle: 30,
                    onPressed: () {
                      // 去注册
                      jumpPageProvider.value = 0;
                      Navigator.pushNamed(context, AppRoutes.register);
                      // RoutesUtil.pushReplacement(
                      //   context: context,
                      //   routeName: AppRoutes.register,
                      // );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  YbButton(
                    text: '登录',
                    width: double.infinity,
                    backgroundColor: AppColors.primaryColor,
                    textColor: AppColors.whiteColor,
                    circle: 30,
                    borderColor: AppColors.whiteColor,
                    onPressed: () {
                      // 去登录
                      jumpPageProvider.value = 0;
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// 轮播图
class CarouseWidget extends StatefulWidget {
  final List<String> imageList;
  double? imageHeigth;

  CarouseWidget({
    Key? key,
    required this.imageList,
    this.imageHeigth,
  }) : super(key: key);

  @override
  State<CarouseWidget> createState() => _CarouseWidgetState();
}

class _CarouseWidgetState extends State<CarouseWidget> {
  // 轮播图的按钮控制器
  final CarouselController _carouselSlider = CarouselController();

  // 当前页
  int _current = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // 在build完成后执行
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = widget.imageHeigth ?? 300.0;

    return Column(
      children: [
        CarouselSlider(
          items: widget.imageList.map((url) {
            return SizedBox(
              child: Image.asset(url),
            );
          }).toList(),
          carouselController: _carouselSlider,
          options: CarouselOptions(
            height: height,
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
          margin: const EdgeInsets.only(
            top: 10,
            left: 5,
            right: 5,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
              children: widget.imageList.map((url) {
                int index = widget.imageList.indexOf(url);
                return Container(
                  width: 7.0,
                  height: 7.0,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
      ],
    );
  }
}

class MyExpansionPanelList extends StatefulWidget {
  const MyExpansionPanelList({super.key});

  @override
  State<MyExpansionPanelList> createState() => _MyExpansionPanelListState();
}

class _MyExpansionPanelListState extends State<MyExpansionPanelList> {
  final List<ExpansionPanelItem> _data = [
    ExpansionPanelItem(
        expandedValue:
            '易北教育已在联邦培训行业深耕了十多年。我们已经帮助过上千名华人按摩师成功通过了联邦考试。我们的学习系统经历了几代的更新，我们的课堂也从线下搬到了线上。\n\n但我们不要求您相信我们。我们只凭实力说话。我们的学员都来自口口相传。您或多或少，都听过易北的名字。\n\n您可以在我们的官网上免费注册账号，领取7天免费试听课程。如果在这 7 天里，您喜欢张老师的授课方式，您听懂了讲解的知识点，您背下了那些专业词，您能轻松做对题目，那您就会知道，我们所说的一切都是事实，我们绝不夸大与欺骗。',
        headerValue: '我为什么要相信你们？'),
    ExpansionPanelItem(
        expandedValue:
            '《易北联邦按摩辅导课程》目前的售价是 1199 美金，学时为3个半月（105天）,包含视频录播课程、关键词卡片背诵、章节测验与考前模拟，错题集集中练习，学习数据智能分析与考试成功率预测，还有微信1对1辅导。\n\n学期中，如果易北的工作人员基于您的学习考核建议您考试而无果，易北教育会将您的学习期限延长至六个月。\n\n学期中，如果您没有遵照易北教育的建议而自行参加考试，即使无果，您依然可以继续学习至学期结束。如因个人原因，学期结束仍未能完成课程学习，您可以选择续费，费用为200美金，学时为60天。\n\n为了避免学员一直续费而缺乏紧迫感，无法顺利通过联邦考试，易北教育特此规定：每位学员只有两次续费机会，续费两次后依旧没有通过考试的，需要先预约联邦考试，经过张老师审核学习情况后再予以续费。\n\n也许您看到 1199 美金的售价会打退堂鼓，但每参加一次联邦考试的报名费就是 265 美金。您自信能靠自学，参加4次考试就通过考试吗？ 我们的课程定价在联邦培训市场中绝不算低，但我们保证，一定物有所值。因为我们帮您节省的，不仅仅是高额的报名费，更节省了您的时间和投入在联邦考试上的精力。',
        headerValue: '课程的具体价格与时限？'),
  ]; // 生成折叠面板的数据

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 0, // 折叠面板的阴影宽度
      expandedHeaderPadding: const EdgeInsets.all(0), // 打开时标题的上下边距
      dividerColor: AppColors.whiteColor,
      expansionCallback: (int panelIndex, bool isExpanded) {
        setState(() {
          _data[panelIndex].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((ExpansionPanelItem item) {
        return ExpansionPanel(
          backgroundColor: AppColors.colorF1F0F4,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return SizedBox(
              child: ListTile(
                title: Text(
                  item.headerValue,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ), // 标题
              ),
            );
          },
          body: ListTile(
            title: Text(
              item.expandedValue,
              style: const TextStyle(
                fontSize: 16,
                height: 1.8,
              ),
            ), // 内容
          ),
          isExpanded: item.isExpanded, // 是否展开
        );
      }).toList(),
    );
  }
}

// 折叠面板项数据类
class ExpansionPanelItem {
  String expandedValue; // 内容
  String headerValue; // 标题
  bool isExpanded; // 是否展开

  ExpansionPanelItem({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });
}
