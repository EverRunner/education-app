import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:yibei_app/utils/colors_util.dart';
import 'package:yibei_app/components/common/yb_crcular_sized_box.dart';

class YbLineChart extends StatefulWidget {
  /// 本周数据
  final List<int> currentWeekData;

  /// 本周数据
  final List<int> lastWeekData;

  /// 本周数据
  final List<double> sysAvgData;

  const YbLineChart({
    super.key,
    required this.currentWeekData,
    required this.lastWeekData,
    required this.sysAvgData,
  });

  @override
  State<YbLineChart> createState() => _YbLineChartState();
}

class _YbLineChartState extends State<YbLineChart> {
  final Map<int, String> _xLabels = {
    0: '一',
    1: '二',
    2: '三',
    3: '四',
    4: '五',
    5: '六',
    6: '七',
  };

  /// 处理数据
  List<FlSpot> _handleArray({required List<num> data}) {
    List<FlSpot> arr = [];
    for (int i = 0; i < 7; i++) {
      arr.add(FlSpot(i.toDouble(), data[i].toDouble()));
    }

    return arr;
  }

  // 图例
  Widget legend(
      {required text, required Color color, double marginRight = 30.0}) {
    return Container(
      margin: EdgeInsets.only(right: marginRight),
      child: Row(
        children: [
          YbCircularSizedBox(
            radius: 6,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.color271900,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 170,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.black, // 设置整体背景色
                  getTooltipItems: (List<LineBarSpot> spots) {
                    return spots.map((spot) {
                      return LineTooltipItem(
                        '${(spot.y / 60 / 60).toStringAsFixed(1)}小时',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ), // 设置文字颜色
                      );
                    }).toList();
                  },
                ),
              ),
              gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppColors.colorE0E2EC,
                    strokeWidth: 2,
                    dashArray: [9, 7],
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    strokeWidth: 0,
                  );
                },
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  bottom: BorderSide(
                    color: AppColors.colorE0E2EC,
                    width: 2,
                  ),
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    reservedSize: 45,
                    showTitles: true,
                    getTitlesWidget: (value, titleMeta) {
                      return Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          '${_xLabels[value.toInt()]}',
                          style: const TextStyle(
                            color: AppColors.colorC7C6CA,
                            fontSize: 18,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: _handleArray(
                    data: widget.currentWeekData,
                  ),
                  barWidth: 2,
                  color: AppColors.warningColor,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                      radius: 5,
                      color: AppColors.warningColor,
                      strokeWidth: 0,
                    ),
                  ),
                ),
                LineChartBarData(
                  spots: _handleArray(
                    data: widget.sysAvgData,
                  ),
                  color: AppColors.primaryColor,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                      radius: 5,
                      color: AppColors.primaryColor,
                      strokeWidth: 0,
                    ),
                  ),
                ),
                LineChartBarData(
                  spots: _handleArray(
                    data: widget.lastWeekData,
                  ),
                  color: AppColors.colorE3E2E6,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                      radius: 5,
                      color: AppColors.colorE3E2E6,
                      strokeWidth: 0,
                    ),
                  ),
                ),
              ],
            ),
            swapAnimationDuration: Duration(milliseconds: 150),
            swapAnimationCurve: Curves.linear,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          color: AppColors.colorF5F7FA,
          margin: const EdgeInsets.only(top: 15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              legend(text: '本周', color: AppColors.warningColor),
              legend(text: '上周', color: AppColors.colorE3E2E6),
              legend(
                text: '考过学员平均',
                color: AppColors.primaryColor,
                marginRight: 0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
