import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:yibei_app/utils/colors_util.dart';

import 'package:yibei_app/models/common/base_entity/base_entity.dart';

import 'package:yibei_app/models/course/course_chapter_step/course_chapter_step.dart';
import 'package:yibei_app/models/user/user_radar_statics/user_radar_statics.dart';
import 'package:yibei_app/models/user/user_radar_statics/user_radar_statics_datum.dart';
import 'package:yibei_app/models/user/user_radar_statics/user_radar_statics.dart';
import 'package:yibei_app/models/user/user_radar_statics/user_radar_statics_datum.dart';

import 'package:yibei_app/api/user.dart';

/// 雷达图表
class YbRadarChart extends StatefulWidget {
  /// 是否显示图例
  final bool isShowLegend;

  /// 数据源
  final UserRadarStaticsDatum chartData;

  const YbRadarChart({
    super.key,
    this.isShowLegend = false,
    required this.chartData,
  });

  @override
  State<YbRadarChart> createState() => _YbRadarChartState();
}

class _YbRadarChartState extends State<YbRadarChart> {
  // 图例
  Widget legend({
    required text,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          height: 3,
          width: 15,
          color: color,
          margin: const EdgeInsets.only(right: 5),
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.color271900,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // height: 250,
          padding: const EdgeInsets.only(bottom: 30),
          child: RadarChart(
            RadarChartData(
              // 雷达图标题
              dataSets: [
                RadarDataSet(
                  // 第一个数据集
                  dataEntries: [
                    RadarEntry(
                        value: widget.chartData.vedioAllavgDuration ?? 0),
                    RadarEntry(
                        value: widget.chartData.chentestAllavgDuration ?? 0),
                    RadarEntry(
                        value: widget.chartData.chenstudyAllavgDuration ?? 0),
                    RadarEntry(
                        value: widget.chartData.chaptertestAllavgDuration ?? 0),
                    RadarEntry(
                        value: widget.chartData.entestAllavgDuration ?? 0),
                    RadarEntry(
                        value: widget.chartData.enstudyAllavgDuration ?? 0),
                  ],
                  entryRadius: 0,
                  borderColor: AppColors.colorF56C6C,
                  borderWidth: 1,
                  fillColor: AppColors.colorF56C6C.withOpacity(0),
                ),
                RadarDataSet(
                  // 第二个数据集
                  dataEntries: [
                    RadarEntry(value: widget.chartData.vedioMineDuration ?? 0),
                    RadarEntry(
                        value: widget.chartData.chentestMineDuration ?? 0),
                    RadarEntry(
                        value: widget.chartData.chenstudyMineDuration ?? 0),
                    RadarEntry(
                        value: widget.chartData.chaptertestMineDuration ?? 0),
                    RadarEntry(value: widget.chartData.entestMineDuration ?? 0),
                    RadarEntry(
                        value: widget.chartData.enstudyMineDuration ?? 0),
                  ],
                  entryRadius: 0,
                  borderColor: AppColors.color67C23A,
                  borderWidth: 1,
                  fillColor: AppColors.color67C23A.withOpacity(0.1),
                ),
              ],
              // 雷达图的样式设置
              radarBackgroundColor: AppColors.colorFBFCFF,
              radarShape: RadarShape.polygon,
              radarBorderData: const BorderSide(
                color: AppColors.colorC0C4CC,
                width: 1,
                style: BorderStyle.solid,
              ),
              titlePositionPercentageOffset: 0.32,
              tickBorderData: const BorderSide(
                color: AppColors.colorEEEFF3,
                width: 1.0,
                style: BorderStyle.solid,
              ),
              tickCount: 2,
              ticksTextStyle: const TextStyle(
                fontSize: 0,
              ),
              gridBorderData: const BorderSide(
                color: Colors.red,
                width: 1.0,
                style: BorderStyle.solid,
              ),
              titleTextStyle: const TextStyle(
                color: AppColors.color74777F,
                fontSize: 10,
                height: 1.2,
              ),
              getTitle: (index, angle) {
                switch (index) {
                  case 0:
                    return RadarChartTitle(text: '视频');

                  case 1:
                    return RadarChartTitle(text: '中英词\n测试');

                  case 2:
                    return RadarChartTitle(text: '中英词');

                  case 3:
                    return RadarChartTitle(text: '章节测试');

                  case 4:
                    return RadarChartTitle(text: '英词\n测试');

                  case 5:
                    return RadarChartTitle(text: '英词');

                  default:
                    return RadarChartTitle(text: '-');
                }
              },
              // radarBackgroundColor: Colors.red,
            ),
            swapAnimationDuration: const Duration(milliseconds: 150),
            swapAnimationCurve: Curves.linear,
          ),
        ),
        Visibility(
          visible: widget.isShowLegend,
          child: Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(3)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.colorC7C6CA,
                    offset: Offset(1.0, 1.0),
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  legend(
                    text: '您的学习',
                    color: AppColors.successColor,
                  ),
                  const SizedBox(height: 3),
                  legend(
                    text: '考过生平均',
                    color: AppColors.colorF56C6C,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
