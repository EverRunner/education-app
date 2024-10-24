import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/components/common/yb_radio.dart';
import 'package:yibei_app/utils/tools_util.dart';
import 'package:yibei_app/config/config.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/utils/routes_util.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/course/user_progress/progress.dart';
import 'package:yibei_app/models/course/chapter_test_result/chapter_test_result.dart';
import 'package:yibei_app/models/course/chapter_test_result/chapter_test_result_data.dart';
import 'package:yibei_app/models/course/chapter_test_request_list/chapter_test_request_list.dart';
import 'package:yibei_app/models/course/chapter_test_request_list/chapter_test_request_list_row.dart';
import 'package:yibei_app/models/course/chapter_test_request_list/yibei_requestion_const_option.dart';
import 'package:yibei_app/models/course/compound_test_request_list/compound_test_request_list.dart';
import 'package:yibei_app/models/course/compound_test_request_list/compound_test_request_list_row.dart';
import 'package:yibei_app/models/course/compound_test_result_data/compound_test_result_data.dart';
import 'package:yibei_app/models/course/compound_test_result_data/compound_test_result_data_item.dart';

import 'package:yibei_app/provider/user_progress_model.dart';

import 'package:yibei_app/api/course.dart';

/// 综合测试-结果页
class StudyCompoundTestResultPage extends StatefulWidget {
  /// 课程id
  final int type;

  // 测试记录的id
  final int testRequestId;

  // 查看测试结果，是否从首页跳过来
  final int? isIndex;

  const StudyCompoundTestResultPage({
    super.key,
    required this.type,
    required this.testRequestId,
    this.isIndex,
  });

  @override
  State<StudyCompoundTestResultPage> createState() => _StudyVideoPageState();
}

class _StudyVideoPageState extends State<StudyCompoundTestResultPage> {
  /// 用户的学习进度
  Progress _userProgress = Progress();

  /// 测试结果信息
  CompoundTestResultDataItem _testResult = CompoundTestResultDataItem();

  /// 测试题列表
  List<CompoundTestRequestListRow> _testList = [];

  /// 滚动监听控制
  // ScrollController _scrollController = ScrollController();

  /// 测试用时
  String _testTime = '';

  /// 是否正在加载更多数据
  bool _isLoading = false;

  // 总数（暂时没有使用，所以设置1）
  int _total = 1;

  /// 当前页
  int _pageIndex = 1;

  /// 每页条数
  // final int _pageSize = Config.page_size;
  final int _pageSize = 300;

  // 提示文字
  String _hintText = '得分须大于90分，才能进入其他测试，请继续努力！';

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
    BaseEntity<CompoundTestResultData> entity;

    switch (widget.type) {
      case 1:
        entity = await getMyErrorTestResult(
          requestPaperId: widget.testRequestId,
        );
        break;
      case 2:
        entity = await getHighErrorTestResult(
          requestPaperId: widget.testRequestId,
        );
        break;
      default:
        // 3：综合测试  5：应变测试 ，获取的接口相同
        entity = await getCompositeTestResult(
          requestPaperId: widget.testRequestId,
        );
    }
    if (entity == null ||
        entity.data?.data == null ||
        entity.data?.status != true) return;

    setState(() {
      _testResult = entity.data!.data!;
      _testTime = ToolsUtil.formatDuration(
        startTime: entity.data!.data!.startdate!,
        endTime: entity.data!.data!.enddate!,
      );
    });
  }

  /// 获取测试列表
  Future<void> _queryTestList() async {
    BaseEntity<CompoundTestRequestList> entity;

    switch (widget.type) {
      case 1:
        entity = await getMyErrorTestRequestList(
          requestId: widget.testRequestId,
          pageIndex: _pageIndex,
          pageSize: _pageSize,
        );
        break;
      case 2:
        entity = await getHighErrorTestRequestList(
          requestId: widget.testRequestId,
          pageIndex: _pageIndex,
          pageSize: _pageSize,
        );
        break;
      default:
        // 3：综合测试  5：应变测试 ，获取的接口相同
        entity = await getCompositeTestRequestList(
          requestId: widget.testRequestId,
          pageIndex: _pageIndex,
          pageSize: _pageSize,
        );
    }
    // if (entity.data?.status != true ||
    //     entity.data?.data?.rows == null ||
    //     entity.data?.data?.count == null) return;
    if (entity.data?.status != true || entity.data?.data == null) return;

    setState(() {
      _testList.addAll(entity.data!.data!);
      // _total = entity.data!.data!.count!;
    });
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
    // if (!_isLoading &&
    //     _scrollController.offset >=
    //         _scrollController.position.maxScrollExtent &&
    //     !_scrollController.position.outOfRange) {
    //   if (_testList.length > _total) _loadMoreData();
    // }
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
    // 通过的情况
    if (_testResult.status == 1) {
      return [
        _buttonWidget(
          text: '重新测试',
          onPressed: () {
            _handleGoto(routeName: AppRoutes.studyCompoundTestPage);
          },
        ),
        _buttonWidget(
          text: '返回上一页',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ];
    } else {
      // 未通过的情况
      return [
        _buttonWidget(
          text: '重测关键词',
          onPressed: () {
            _handleGoto(routeName: AppRoutes.studyCompoundWordTestPage);
          },
        ),
        _buttonWidget(
          text: '返回上一页',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ];
    }
  }

  /// 跳转页面
  /// [routeName] 路由
  _handleGoto({
    required String routeName,
    bool isNext = false,
  }) {
    // 跳转函数及参数
    Map<String, dynamic> args = {
      'type': widget.type,
    };
    RoutesUtil.pushReplacement(
      context: context,
      routeName: routeName,
      arguments: args,
    );
  }

  @override
  void initState() {
    // 设置值
    setState(() {
      // 学习进度
      _userProgress = Provider.of<UserProgressModel>(context, listen: false)
          .getUserProgressData;
    });

    () async {
      await _queryTestResult();
      await _queryTestList();
    }();

    // _scrollController.addListener(_onScroll); // 监听滚动事件
    super.initState();
  }

  @override
  void dispose() {
    // _scrollController.removeListener(_onScroll);
    // _scrollController.dispose();
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
        // controller: _scrollController,
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
  final CompoundTestRequestListRow contentData;
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
            data: contentData.title ?? '-',
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
