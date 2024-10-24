import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:yibei_app/routes/index.dart';
import 'package:yibei_app/utils/routes_util.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/config/config.dart';
import 'package:yibei_app/utils/toast_util.dart';
import 'package:yibei_app/utils/tools_util.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/course/member_study_logs/member_study_logs.dart';
import 'package:yibei_app/models/course/member_study_logs/study_logs_data_list.dart';
import 'package:yibei_app/models/course/member_study_logs/course_chapter_list.dart';
import 'package:yibei_app/models/course/user_progress/progress.dart';

import 'package:yibei_app/api/course.dart';
import 'package:yibei_app/provider/user_progress_model.dart';

/// 学习报告
class StudyReportPage extends StatefulWidget {
  StudyReportPage({Key? key}) : super(key: key);

  @override
  State<StudyReportPage> createState() => _ResourceVideoPageState();
}

class _ResourceVideoPageState extends State<StudyReportPage> {
  // 滚动控件器
  final ScrollController _masonryScrollController = ScrollController();

  /// 用户的学习进度
  late Progress _userProgress = Progress();

  /// 节流加载更多
  var _throttledLoadMore;

  /// loading
  bool _loading = false;

  /// 是第一次加载
  bool _isFirst = true;

  // 总数
  int _total = 0;

  /// 当前页
  int _pageIndex = 1;

  /// 每页条数
  // final int _pageSize = Config.page_size;
  final int _pageSize = 40;

  /// 学习记录
  List<StudyLogsDataList> _studyLogList = [];

  /// 获取测试列表
  Future<void> _queryTestList() async {
    setState(() {
      _loading = true;
    });

    BaseEntity<MemberStudyLogs> entity = await getMemberStudyLogs(
      pageIndex: _pageIndex,
      pageSize: _pageSize,
    );
    setState(() {
      _loading = false;
      _isFirst = false;
    });
    if (entity.data?.status != true ||
        entity.data?.count == null ||
        entity.data?.dataList == null) {
      return;
    }
    setState(() {
      _total = entity.data!.count!;
      _studyLogList.addAll(entity.data!.dataList!);
    });
  }

  /// 文字 Widget
  Widget textWidget({
    String? text,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return Text(
      '$text',
      style: TextStyle(
        fontSize: 16,
        color: color ?? AppColors.primaryColor,
        fontWeight: fontWeight ?? FontWeight.w500,
      ),
    );
  }

  /// 列表item
  Widget listItemWidget({
    required StudyLogsDataList item,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            '${item.chapterid! > 0 ? item.chapterName : item.chapterid == -1 ? '应变测试' : '综合测试'}',
            style: const TextStyle(
              color: AppColors.color271900,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            color: AppColors.whiteColor,
          ),
          child: Column(
            children: item?.courseChapterList
                    ?.map(
                      (son) => itemSonWidget(son: son),
                    )
                    .toList() ??
                [],
          ),
        ),
        const SizedBox(height: 15)
      ],
    );
  }

  /// 二级子集
  Widget itemSonWidget({
    required CourseChapterList son,
  }) {
    // 格式化remark
    Map<String, dynamic> remarkObj = {};
    bool isRemarkObj = false;

    if (son.remark != null && son.remark!.length > 40) {
      isRemarkObj = true;
      remarkObj = json.decode(son.remark!);

      // 章节测试-答题记录显示
      if (remarkObj['type'] == 0) {
        remarkObj['isShow'] = 1;
      }

      // 其他测试及关键词-答题记录显示
      // 3:章节测前（关键词）  4:我错题测试  5:综合测试  6:高频测试
      // 7:我错题测前（关键词） 8:综合测前（关键词） 9:高频测前（关键词）
      if (remarkObj['type'] == 3 ||
          remarkObj['type'] == 4 ||
          remarkObj['type'] == 5 ||
          remarkObj['type'] == 6 ||
          remarkObj['type'] == 7 ||
          remarkObj['type'] == 8 ||
          remarkObj['type'] == 9 ||
          remarkObj['type'] == 10 ||
          remarkObj['type'] == 11) {
        // 获取当前时间
        DateTime now = DateTime.now();

        // 将给定的时间戳转换为DateTime对象，时间：1630944000000  2021-9-7后的才有答题id
        DateTime targetDate =
            DateTime.fromMillisecondsSinceEpoch(1630944000000);

        if (now.isAfter(targetDate)) {
          remarkObj['isShow'] = 1;
        }
      }
    }

    // 记录标题
    String title = "${son.remark}";
    if (isRemarkObj) {
      double value = remarkObj['correctcount'] / remarkObj['allcount'];
      int score = value.isFinite ? (value * 100).floor() : 0;
      title =
          "${Config.study_type[remarkObj['type'] ?? '章节测试完成']}，正确${remarkObj['correctcount']}道题，错误${remarkObj['errorcount']}道题，得分$score%";
    }

    // 状态
    final String status = isRemarkObj
        ? remarkObj['status'] == 1
            ? '通过'
            : '未通过'
        : "${son.status}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Stack(
          children: [
            const Positioned(
              top: 8,
              left: 1,
              child: Icon(
                Icons.circle,
                size: 6,
                color: AppColors.color271900,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 15,
                bottom: 5,
              ),
              child: textWidget(
                text: title,
                color: AppColors.color271900,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  textWidget(
                    text: '状态：',
                    color: AppColors.color271900,
                  ),
                  textWidget(
                    text: status,
                    color:
                        status == '未通过' ? Colors.red : AppColors.successColor,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              textWidget(
                text:
                    '时间：${DateFormat('yyyy-MM-dd HH:mm').format(son.createdAt!)}',
                color: AppColors.color271900,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 5),
              if (remarkObj['isShow'] == 1)
                InkWell(
                  child: Row(
                    children: [
                      textWidget(
                        text: '答题记录',
                        fontWeight: FontWeight.bold,
                      ),
                      const Icon(
                        Icons.keyboard_arrow_right_outlined,
                        size: 22,
                        color: AppColors.primaryColor,
                      )
                    ],
                  ),
                  onTap: () {
                    handleTestResults(remarkObj: remarkObj);
                  },
                )
            ],
          ),
        ),
      ],
    );
  }

  /// 跳转到测试结果
  handleTestResults({
    required Map<String, dynamic> remarkObj,
  }) {
    final int type = remarkObj['type'] ?? 0;

    if (type == 0) {
      // 普通测试
      Map<String, dynamic> args = {
        'testRequestId': remarkObj['requestid'],
        'progressStatus': 100,
        'isIndex': 1,
      };
      Navigator.pushNamed(
        context,
        AppRoutes.studyTestResult,
        arguments: args,
      );
    } else if (type == 4 || type == 5 || type == 6 || type == 11) {
      // 错误、综合练习、应变等测试
      int errorType = 1;
      if (type == 4) errorType = 1;
      if (type == 5) errorType = 3;
      if (type == 6) errorType = 2;
      if (type == 11) errorType = 5;
      Map<String, dynamic> args = {
        'testRequestId': remarkObj['requestid'],
        'type': errorType,
        'isIndex': 1,
      };
      Navigator.pushNamed(
        context,
        AppRoutes.studyCompoundTestResultPage,
        arguments: args,
      );
    } else {
      // 得分
      final int score =
          ((remarkObj['correctcount'] / remarkObj['allcount']) * 100).floor();
      // 单词测试
      Map<String, dynamic> args = {
        'type': type,
        'status': remarkObj['status'],
        'startDate': DateTime.parse(remarkObj['startdate']),
        'endDate': DateTime.parse(remarkObj['enddate']),
        'orderCode': remarkObj['ordercode'],
        'allRequestCount': remarkObj['allcount'],
        'correctCount': remarkObj['correctcount'],
        'score': score,
      };
      Navigator.pushNamed(
        context,
        AppRoutes.studyWordTestResult,
        arguments: args,
      );
    }
  }

  /// 骨架屏
  Widget buildShimmer() {
    final List<int> arr = [1, 2, 3, 4];
    return Shimmer.fromColors(
      baseColor: AppColors.colorF7F9FF,
      highlightColor: AppColors.whiteColor,
      child: Column(
        children: arr
            .map(
              (e) => Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(3),
                      ),
                    ),
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(3),
                      ),
                    ),
                    height: 200,
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  /// 滚动监听
  void _masonryScrollListener() {
    // 滚动的方向
    if (_masonryScrollController.position.userScrollDirection ==
        ScrollDirection.forward) return;

    // 上拉触底，加载更多
    if (_masonryScrollController.position.pixels >=
            _masonryScrollController.position.maxScrollExtent - 100 &&
        !_loading) {
      _throttledLoadMore();
    }
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

    /// 帖子列表，节流加载更多
    _throttledLoadMore = ToolsUtil.throttle(
      () {
        if (_studyLogList.length < _total) {
          _pageIndex++;
          _queryTestList();
        } else {
          ToastUtil.shortToast('没有更多数据了');
        }
      },
      const Duration(seconds: 2),
    );

    // 添加滚动监听器
    _masonryScrollController.addListener(_masonryScrollListener);

    _queryTestList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.color1A1C1E,
          size: 18,
        ),
        backgroundColor: AppColors.colorEBF1FF,
        elevation: 0, // 取消阴影
        title: const Text(
          '学习报告',
          style: TextStyle(
            color: AppColors.color1A1C1E,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: AppColors.colorEBF1FF,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _masonryScrollController,
          child: Column(
            children: [
              _isFirst
                  ? buildShimmer()
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Column(
                        children: _studyLogList
                            .map(
                              (item) => listItemWidget(
                                item: item,
                              ),
                            )
                            .toList(),
                      ),
                    ),
              if (_loading)
                Container(
                  padding: const EdgeInsets.only(top: 30, bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        '加载中...',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
