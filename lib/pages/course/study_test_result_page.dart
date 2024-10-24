import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/components/common/yb_radio.dart';
import 'package:yibei_app/utils/toast_util.dart';
import 'package:yibei_app/utils/tools_util.dart';
import 'package:yibei_app/config/config.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/utils/routes_util.dart';
import 'package:yibei_app/dialog/dialog_show.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/course/user_progress/progress.dart';
import 'package:yibei_app/models/course/chapter_test_result/chapter_test_result.dart';
import 'package:yibei_app/models/course/chapter_test_result/chapter_test_result_data.dart';
import 'package:yibei_app/models/course/chapter_test_request_list/chapter_test_request_list.dart';
import 'package:yibei_app/models/course/chapter_test_request_list/chapter_test_request_list_row.dart';
import 'package:yibei_app/models/course/chapter_test_request_list/yibei_requestion_const_option.dart';

import 'package:yibei_app/provider/user_progress_model.dart';

import 'package:yibei_app/api/course.dart';

/// 章节单元测试-结果页
class StudyTestResultPage extends StatefulWidget {
  /// 课程id
  final int? courseId;

  /// 章节id
  final int? chapterId;

  /// 试卷id
  final int? requestPaperId;

  /// 剩余机会
  final int? leftTestCount;

  /// 排名
  final int? rank;

  /// 是否答错3次及以上了 true：已错3次，false：还没有，可以继续测试
  final bool? isThreeErrorCount;

  /// 判断此章节是否已经学习过
  final int? progressStatus;

  /// 是否为final
  final int? isFinal;

  // 测试记录的id
  final int? testRequestId;

  /// 得分
  final double? passScore;

  /// 是否为复习
  final int? isReview;

  // 是否为单词测试
  final int? isReviewWordTest;

  // 下一节的课程id
  final int? nextCourseId;

  // 下一节的章节id
  final int? nextChapterId;

  // 查看测试结果，是否从首页跳过来
  final int? isIndex;

  const StudyTestResultPage({
    super.key,
    this.courseId,
    this.chapterId,
    this.requestPaperId,
    this.leftTestCount,
    this.rank,
    this.isThreeErrorCount,
    this.progressStatus,
    this.isFinal,
    this.testRequestId,
    this.passScore,
    this.isReview,
    this.isReviewWordTest,
    this.nextCourseId,
    this.nextChapterId,
    this.isIndex,
  });

  @override
  State<StudyTestResultPage> createState() => _StudyVideoPageState();
}

class _StudyVideoPageState extends State<StudyTestResultPage> {
  /// 用户的学习进度
  Progress _userProgress = Progress();

  /// 测试结果信息
  ChapterTestResultData _testResult = ChapterTestResultData();

  /// 测试题列表
  List<ChapterTestRequestListRow> _testList = [];

  /// 滚动监听控制
  ScrollController _scrollController = ScrollController();

  /// 测试用时
  String _testTime = '';

  /// 是否正在加载更多数据
  bool _isLoading = false;

  // 总数
  int _total = 0;

  /// 当前页
  int _pageIndex = 1;

  /// 每页条数
  // final int _pageSize = Config.page_size;
  final int _pageSize = 300;

  // 提示文字
  String _hintText = '得分须大于90分，才能进入下一章节学习，请继续努力！';

  // 文字widget
  Widget textWidget({
    required String text,
    Color? color = AppColors.color74777F,
    double? fontSize = 14,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
      ),
    );
  }

  /// 获取测试结果
  Future<void> _queryTestResult() async {
    BaseEntity<ChapterTestResult> entity =
        BaseEntity<ChapterTestResult>(data: ChapterTestResult());

    if (widget.isIndex == 1) {
      entity = await getTestResultInfo(
        testRequestId: widget.testRequestId ?? 0,
      );
    } else {
      entity = await getChapterTestResult(
        progressId: _userProgress.id ?? 0,
        requestPaperId: widget.requestPaperId ?? 0,
      );
    }

    if (entity.data?.status != true || entity.data?.data == null) {
      return;
    }
    setState(() {
      _testResult = entity.data!.data!;
      _testTime = ToolsUtil.formatDuration(
        startTime: entity.data!.data!.startdate!,
        endTime: entity.data!.data!.enddate!,
      );

      if (widget.leftTestCount == 2) {
        _hintText = '得分须大于${widget.passScore!.toInt()}分，才能进入下一章节学习，请继续努力！';
      } else if (widget.isFinal == 1) {
        // 是final
        if (widget.leftTestCount == 0) {
          _hintText = '很抱歉，您三次没有通过单元测试（Final），建议您重新学习整个章节！';
          handleThreeFinalNotPass();
        }
        if (widget.leftTestCount == 1) {
          _hintText = '很抱歉，您两次没有通过单元测试（Final），请继续努力！';
        }
      } else {
        // 不是final
        if (widget.leftTestCount == 0) {
          _hintText = '很抱歉，您三次没有通过单元测试，请重新学习视频！';
        }
        if (widget.leftTestCount == 1) {
          _hintText = '很抱歉，您两次没有通过单元测试，请重新学习关键词！';
        }
      }
    });
  }

  /// 包裹文本Widget
  Widget textSpan(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        height: 1.8,
        color: AppColors.color271900,
      ),
    );
  }

  /// 三次Final未通过提示
  handleThreeFinalNotPass() {
    onShowAlertDialog(
      context: context,
      title: '三次未通过Final测试',
      detail: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 1,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 垂直方向上自适应文本内容高度
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textSpan('啊哦，第三次测试又挂喽！'),
              textSpan('我们一起找找原因吧！'),
              textSpan('首先答题的时候，'),
              textSpan('是否能判断考点，'),
              textSpan('也就是问题问什么？'),
              textSpan('如果看不懂题，'),
              textSpan('那么就是关键词找不到，'),
              textSpan('请多看单词卡，'),
              textSpan('并且在关键词练习时，'),
              textSpan('一定要思考它们围绕什么样的知识点，'),
              textSpan('找到关键词就能判断考点！'),
              textSpan(''),
              textSpan('如果能够读懂题意，'),
              textSpan('但是不知道怎么判断，'),
              textSpan('那么就是知识点没有掌握住，'),
              textSpan('请再多看一下视频课程，'),
              textSpan('或是直接询问张老师，'),
              textSpan('明白了原理，才能够记住，'),
              textSpan('并且灵活运用！'),
              textSpan('千万不要死记硬背反反复复刷题闯关，'),
              textSpan('答对和学会，'),
              textSpan('是两个完全不同的概念，'),
              textSpan('大家一定要学会思考提问，'),
              textSpan('学会考题，'),
              textSpan('才能顺利通过考试！'),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            right: 10,
            bottom: 10,
          ),
          child: YbButton(
            text: ' 了解 ',
            circle: 25,
            onPressed: () {
              Navigator.pop(context); // 关闭弹窗
            },
          ),
        ),
      ],
    );
  }

  /// 获取测试列表
  Future<void> _queryTestList() async {
    BaseEntity<ChapterTestRequestList> entity = await getChapterTestRequestList(
      requestId: widget.testRequestId ?? 0,
      pageIndex: _pageIndex,
      pageSize: _pageSize,
    );
    if (entity.data?.status != true ||
        entity.data?.data?.rows == null ||
        entity.data?.data?.count == null) return;
    setState(() {
      _testList.addAll(entity.data!.data!.rows!);
      _total = entity.data!.data!.count!;
    });
  }

  /// 更新用户的付费学习进度（通知所有的provider）
  updateUserProgressModel() {
    Provider.of<UserProgressModel>(context, listen: false).setUserProgress(1);
  }

  /// 加载更多数据的操作
  Future<void> _loadMoreData() async {
    setState(() {
      _pageIndex++; // 更新当前页数
      _isLoading = true; // 设置正在加载状态为true
    });

    await _queryTestList();

    setState(() {
      _isLoading = false; // 加载完成后将加载状态设为false
    });
  }

  /// 滚动事件回调函数
  void _onScroll() {
    // 判断是否滚动到底部，并且不在加载状态
    if (!_isLoading &&
        _scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (_testList.length > _total) _loadMoreData();
    }
  }

  /// 跳转页面下一意章节
  _handleGotoNext() {
    if (widget.nextCourseId == 0 && widget.nextChapterId == 0) {
      ToastUtil.longToast('恭喜您，你已经学习所有课程啦！');
      return;
    }

    // 跳转函数及参数
    Map<String, dynamic> args = {
      'courseId': widget.nextCourseId,
      'chapterId': widget.nextChapterId,
      'isReviewWordTest': widget.isReviewWordTest,
      'isReview': widget.isReview,
    };

    RoutesUtil.pushReplacement(
      context: context,
      routeName: AppRoutes.studyVideo,
      arguments: args,
    );
  }

  /// 按钮组
  /// [horizontal] 水平间距
  /// [isPlain] 是不是朴素按钮
  Widget _buttonWidget({
    double horizontal = 7,
    bool isPlain = false,
    required String text,
    required void Function() onPressed,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      child: isPlain
          ? YbButton(
              text: text,
              circle: 20,
              textColor: AppColors.primaryColor,
              backgroundColor: AppColors.warningColor,
              borderColor: AppColors.primaryColor,
              onPressed: onPressed,
            )
          : YbButton(
              text: text,
              circle: 20,
              onPressed: onPressed,
            ),
    );
  }

  /// 按钮组
  List<Widget> _buttonListWidget() {
    // 通过的情况 或是 三次final未通过
    if (_testResult.status == 1 ||
        (widget.isFinal == 1 && widget.leftTestCount == 0)) {
      return [
        _buttonWidget(
          text: '重新测试',
          onPressed: () {
            _handleGoto(routeName: AppRoutes.studyTest);
          },
        ),
        _buttonWidget(
          text: '进入下一节',
          onPressed: () {
            _handleGotoNext();
          },
        ),
      ];
    } else {
      // 未通过的情况
      if (widget.isFinal == 1) {
        // 是final
        if (widget.leftTestCount == 0) {
          return [
            _buttonWidget(
              text: '返回章节学习',
              onPressed: () {
                _handleGoto(routeName: AppRoutes.courseChapterList);
              },
            ),
          ];
        } else {
          return [
            _buttonWidget(
              text: '重新测试',
              onPressed: () {
                _handleGoto(routeName: AppRoutes.studyTest);
              },
            ),
          ];
        }
      } else {
        // 不是final
        if (widget.leftTestCount == 0) {
          return [
            _buttonWidget(
              text: '重新学习视频',
              onPressed: () {
                _handleGoto(routeName: AppRoutes.studyVideo);
              },
            ),
          ];
        } else if (widget.leftTestCount == 1) {
          return [
            _buttonWidget(
              text: '重新学习关键词',
              onPressed: () {
                _handleGoto(routeName: AppRoutes.studyWordChEn);
              },
            ),
          ];
        } else if (widget.leftTestCount == 2) {
          return [
            _buttonWidget(
              text: '重新测试',
              onPressed: () {
                _handleGoto(routeName: AppRoutes.studyTest);
              },
            ),
          ];
        }
      }
    }
    return [];
  }

  /// 跳转页面
  /// [routeName] 路由
  _handleGoto({
    required String routeName,
    bool isNext = false,
  }) {
    // 跳转函数及参数
    Map<String, dynamic> args = {
      'courseId': isNext ? widget.nextCourseId : widget.courseId,
      'chapterId': isNext ? widget.nextChapterId : widget.chapterId,
      'isReviewWordTest': isNext ? null : widget.isReviewWordTest,
      'isReview': isNext ? null : widget.isReview,
    };
    RoutesUtil.pushReplacement(
      context: context,
      routeName: routeName,
      arguments: args,
    );
  }

  @override
  void initState() {
    super.initState();

    // 设置值
    setState(() {
      // 学习进度
      _userProgress = Provider.of<UserProgressModel>(context, listen: false)
          .getUserProgressData;
    });

    () async {
      await updateUserProgressModel();
      await _queryTestResult();
      await _queryTestList();
    }();

    // _scrollController.addListener(_onScroll); // 监听滚动事件
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          '测试结果',
          style: TextStyle(color: AppColors.whiteColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          child: Column(
            children: [
              // 测试信息
              _testResult.id != null
                  ? Container(
                      color: AppColors.colorF1F0F4,
                      padding: const EdgeInsets.only(
                        top: 12,
                        bottom: 15,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '测试结果：',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: AppColors.color001E31,
                                ),
                              ),
                              Text(
                                _testResult.status == 1 ? "通过" : "未通过",
                                style: TextStyle(
                                  fontSize: 28,
                                  color: _testResult.status == 1
                                      ? AppColors.color2E6C00
                                      : AppColors.colorBA1A1A,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Text(
                            '（$_hintText）',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.color74777F,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 10,
                              bottom: 20,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            color: AppColors.colorE7EBF2,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    children: [
                                      textWidget(text: '用时'),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      textWidget(
                                        text: _testTime,
                                        color: AppColors.color43474E,
                                        fontSize: 16,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    children: [
                                      textWidget(text: '总共'),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        child: textWidget(
                                          text:
                                              '${_testResult.allrequestcount}',
                                          color: AppColors.color43474E,
                                          fontSize: 16,
                                        ),
                                      ),
                                      textWidget(text: '题'),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    children: [
                                      textWidget(text: '正确'),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        child: textWidget(
                                          text: '${_testResult.correctcount}',
                                          color: AppColors.color2E6C00,
                                          fontSize: 16,
                                        ),
                                      ),
                                      textWidget(text: '题'),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    children: [
                                      textWidget(text: '得分'),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        child: textWidget(
                                          text: '${_testResult.score}',
                                          color: _testResult.status == 1
                                              ? AppColors.color2E6C00
                                              : AppColors.colorBA1A1A,
                                          fontSize: 16,
                                        ),
                                      ),
                                      textWidget(text: '分'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.isIndex != 1)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _buttonListWidget(),
                            ),
                          const SizedBox(
                            height: 13,
                          ),
                          if (_testResult.status != 1)
                            Text(
                              '（剩余 ${widget.leftTestCount} 次机会）',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.color74777F,
                              ),
                            ),
                        ],
                      ),
                    )
                  : const Text(''),

              // 测试题
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: _testList.isNotEmpty
                    ? Column(
                        children: _testList.map(
                          (topicItem) {
                            int index = _testList
                                .indexWhere((element) => element == topicItem);
                            return Topic(
                              contentData: topicItem,
                              index: index + 1,
                            );
                          },
                        ).toList(),
                      )
                    : const Center(
                        child: Text('测试结果加载中...'),
                      ),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 20,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

///测试题
class Topic extends StatelessWidget {
  final ChapterTestRequestListRow contentData;
  final int index;

  const Topic({
    super.key,
    required this.contentData,
    required this.index,
  });

  /// 图标的颜色
  Color _getIconColor(YibeiRequestionConstOption option) {
    if (option.iscorrectoption == 1) {
      return AppColors.color2E6C00;
    }
    return AppColors.colorC3C6CF;
  }

  /// 标题颜色
  Color _getTitleColor(YibeiRequestionConstOption option) {
    if (option.iscorrectoption != 1 &&
        option.id.toString() == contentData.memberanswser) {
      return AppColors.colorBA1A1A;
    }
    if (option.iscorrectoption == 1) {
      return AppColors.color2E6C00;
    }
    return AppColors.colorC3C6CF;
  }

  /// 选中图标颜色
  Color _getActiveColor(YibeiRequestionConstOption option) {
    if (option.iscorrectoption == 1 &&
        option.id.toString() == contentData.memberanswser) {
      return AppColors.color2E6C00;
    }
    if (option.iscorrectoption != 1 &&
        option.id.toString() == contentData.memberanswser) {
      return AppColors.colorBA1A1A;
    }
    return AppColors.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 15,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.colorF1F0F4,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${index}. ',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.blackColor,
                  ),
                ),
                Icon(
                  contentData.status == 1
                      ? Icons.check_circle
                      : Icons.dangerous,
                  size: 20,
                  color: contentData.status == 1
                      ? AppColors.color2E6C00
                      : AppColors.colorBA1A1A,
                ),
              ],
            ),
          ),
          Html(
            data: contentData.title ?? '',
            style: {
              "body": Style(
                fontSize: FontSize(16),
                lineHeight: const LineHeight(1.5),
                color: AppColors.color1A1C1E,
              ),
            },
            //  imgMaxWidth: MediaQuery.of(context).size.width,
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: <Widget>[
              ...contentData.yibeiRequestionConstOption!.map((optionItem) {
                return YbRadio<int>(
                  value: optionItem.id!,
                  groupValue: int.parse(contentData.memberanswser ?? '0'),
                  title: '${optionItem.title}',
                  disable: true,
                  iconColor: _getIconColor(optionItem),
                  titleColor: _getTitleColor(optionItem),
                  activeColor: _getActiveColor(optionItem),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }
}
