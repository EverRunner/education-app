import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/config/config.dart';
import 'package:yibei_app/components/common/yb_Search_box.dart';
import 'package:yibei_app/routes/index.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';
import 'package:yibei_app/models/course/course_chapter_list_data/course_chapter_list_data.dart';
import 'package:yibei_app/models/resource/resource_category_item/resource_category_item.dart';
import 'package:yibei_app/models/content/content_list/content_list_row.dart';
import 'package:yibei_app/models/content/content_list/content_list.dart';

import 'package:yibei_app/components/common/yb_button.dart';
import 'package:yibei_app/dialog/dialog_show.dart';
import 'package:yibei_app/utils/cache_util.dart';
import 'package:yibei_app/models/user/login_user_info/user_info.dart';

import 'package:yibei_app/api/common.dart';
import 'package:yibei_app/provider/notifier_provider.dart';

class IndexResourcePage extends StatefulWidget {
  const IndexResourcePage({super.key});

  @override
  State<IndexResourcePage> createState() => _IndexResourcePageState();
}

class _IndexResourcePageState extends State<IndexResourcePage> {
  /// 资源分类列表
  final List<ResourceCategoryItem> _categoryList = [
    ResourceCategoryItem(title: '趣味学单词', id: 13, type: 'interest'),
    ResourceCategoryItem(title: '学员常见问题解答', id: 10, type: 'FAQ'),
    ResourceCategoryItem(title: '教程系列', id: 11, type: 'course'),
    ResourceCategoryItem(title: '知识点总结', id: 12, type: 'knowledge'),
    ResourceCategoryItem(title: '必考专业词汇汇总（磨耳朵版）', id: 11, type: 'vocabulary'),
  ];

  /// 缓存数据源
  Map<String, List<ContentListRow>> _dataSource = {};

  /// 当前选中id
  String _activeType = 'interest';

  /// 搜索文本
  String _searchText = '';

  /// 处理激活
  _handleActive({
    required ResourceCategoryItem row,
  }) {
    if (row.type == null || row.id == null) return;
    setState(() {
      _activeType = row.type!;
      _searchText = '';
    });

    // 如果没有缓存数据时，请求接口
    if (_dataSource[row.type] == null) {
      if (row.type == 'interest') {
        _queryChapterList(
          courseId: row.id!,
          type: row.type!,
        );
      } else {
        _queryContentList(
          category: row.id!,
          type: row.type!,
        );
      }
    }
  }

  /// 获取章节列表（趣味学单词）
  _queryChapterList({
    required int courseId,
    required String type,
  }) async {
    BaseEntity<CourseChapterListData> entity =
        await getCourseChapterListNoLogin(
      courseId: courseId,
      showLoading: true,
    );
    if (entity.data?.status != true || entity.data?.dataList == null) {
      return;
    }
    List<ContentListRow> newData = [];
    for (var item in entity.data?.dataList ?? []) {
      newData.add(ContentListRow(
        title: item.title,
        thumb: item.thumb,
        id: item.id,
      ));
    }

    setState(() {
      _dataSource[type] = newData;
    });
  }

  /// 获取文章列表（学员常见问题解答、教程系列、知识点总结、必考专业词汇汇总）
  _queryContentList({
    required int category,
    required String type,
  }) async {
    BaseEntity<ContentList> entity = await getContentListNoLogin(
      category: category,
      showLoading: true,
    );
    if (entity.data?.status != true || entity.data?.data?.rows == null) {
      return;
    }
    List<ContentListRow> newData = [];
    for (var item in entity.data?.data?.rows ?? []) {
      newData.add(ContentListRow(
        title: item.title,
        thumb: item.thumb,
        id: item.id,
      ));
    }

    setState(() {
      _dataSource[type] = newData;
    });
  }

  /// 打开弹框解锁全部课程
  handleOpen() {
    onShowAlertDialog(
        context: context,
        title: '付费会员专享',
        detail: Container(
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 10,
          ),
          child: const Text('如果您想观看付费会员专享资源，请先完成购买！'),
        ),
        actions: [
          YbButton(
            text: '去注册购买',
            circle: 20,
            onPressed: () {
              Navigator.pop(context); // 关闭弹窗
              // 去注册
              jumpPageProvider.value = 0;
              Navigator.pushNamed(context, AppRoutes.register);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 5),
            child: TextButton(
              child: const Text('游客购买'),
              onPressed: () {
                Navigator.pop(context); // 关闭弹窗
                Navigator.pushNamed(context, AppRoutes.touristLogin);
              },
            ),
          ),
        ]);
  }

  /// 处理搜索
  _handleSearch(String text) {
    setState(() {
      _searchText = text;
    });
  }

  @override
  void initState() {
    _queryChapterList(
      courseId: 13, // 13可以不传，后台接口只会做了限的，只会返回课程id：13的数据
      type: _activeType,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // 设置为0表示不显示AppBar
        child: AppBar(
          backgroundColor: AppColors.colorF1F4FA,
          elevation: 0.0, // 设置阴影为0.0
        ),
      ),
      backgroundColor: AppColors.colorF1F4FA,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 5,
          bottom: 20,
          left: 12,
          right: 12,
        ),
        child: Column(
          children: [
            // 搜索框
            YbSearchBox(onSubmitted: _handleSearch),

            // 分类
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: _categoryList
                        .map((categoryItem) => InkWell(
                              onTap: () {
                                _handleActive(row: categoryItem);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: categoryItem.type == _activeType
                                      ? AppColors.colorCCE5FF
                                      : null,
                                  border: Border.all(
                                    color: categoryItem.type == _activeType
                                        ? AppColors.colorCCE5FF
                                        : AppColors.color74777F,
                                    width: 1,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  categoryItem.title ?? '-',
                                  style: TextStyle(
                                    color: categoryItem.type == _activeType
                                        ? AppColors.color001E31
                                        : AppColors.color43474E,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ))
                        .toList()),
              ),
            ),

            // 内容列表
            _dataSource[_activeType] != null &&
                    _dataSource[_activeType]!.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      // 列表长度
                      itemCount: _dataSource[_activeType]!.length,
                      // 每个列表项的构建方法，index为列表项的下标
                      itemBuilder: (BuildContext context, int index) {
                        // 搜索为空或包含搜索内容时，显示内容
                        if (_searchText == '' ||
                            _dataSource[_activeType]![index]
                                .title!
                                .contains(_searchText)) {
                          return InkWell(
                            onTap: () {
                              handleOpen();
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                bottom: 12,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Column(
                                children: [
                                  // 图片
                                  if (_dataSource[_activeType]![index].thumb !=
                                          null &&
                                      _dataSource[_activeType]![index].thumb !=
                                          '')
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8)),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            '${Config.file_root}${_dataSource[_activeType]![index].thumb}',
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              AppColors.color74777F,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.panorama,
                                          size: 100,
                                          color: AppColors.colorE0E2EC,
                                        ),
                                        fit: BoxFit.fill,
                                        height: 206,
                                        alignment: Alignment.center,
                                      ),
                                    ),

                                  // 内容
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 15,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_dataSource[_activeType]![index].title}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: AppColors.color1A1C1E,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 1,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Text(
                                            //   '趣味学单词',
                                            //   style: TextStyle(
                                            //     fontSize: 12,
                                            //     color: AppColors.color74777F,
                                            //   ),
                                            // ),
                                            // Text(
                                            //   '15:30',
                                            //   style: TextStyle(
                                            //     fontSize: 12,
                                            //     color: AppColors.color74777F,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.only(
                      top: 50,
                    ),
                    child: const Text(
                      '没有更多数据了',
                      style: TextStyle(
                        color: AppColors.color74777F,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
