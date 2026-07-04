import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DynamicBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> dataList;
  final String xAxisKey;          
  final List<String> dataKeys;     
  final List<Color> barColors;    
  final double chartHeight;
  final double angle;

  const DynamicBarChart({
    super.key,
    required this.dataList,
    required this.xAxisKey,
    required this.barColors,
    required this.dataKeys,
    this.chartHeight = 260.0,
    this.angle = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (dataList.isEmpty || dataKeys.isEmpty) {
      return SizedBox(
        height: chartHeight,
        child: const Center(child: Text('No data available')),
      );
    }

    // 1. Calculate Max Y bound cleanly
    double maxVal = 0.0;
    for (var data in dataList) {
      for (var key in dataKeys) {
        if (data.containsKey(key) && data[key] is num) {
          final double currentVal = (data[key] as num).toDouble();
          if (currentVal > maxVal) maxVal = currentVal;
        }
      }
    }
    final double maxY = maxVal > 0 ? maxVal * 1.1 : 100.0;
    final double sideTitleInterval = maxY / 4 > 0 ? maxY / 4 : 1;

    // Shared Y-Axis Configuration for both skeleton and scrollable chart
    AxisTitles leftTitlesConfiguration = AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 46,
        interval: sideTitleInterval,
        getTitlesWidget: (value, meta) {
          return SideTitleWidget(
            meta: meta,
            space: 8,
            child: Text(
              value >= 1000 ? '${(value / 1000).toStringAsFixed(1)}K' : value.round().toString(),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.w500),
            ),
          );
        },
      ),
    );

    // Each group gets a fixed block width (e.g., 65 pixels per item) to allow natural scrolling
    final double computedChartWidth = dataList.length * 65.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableChartWidth = constraints.maxWidth - 50; // Accounting for 50px left sidebar
        final double finalWidth = computedChartWidth < availableChartWidth ? availableChartWidth : computedChartWidth;

        return SizedBox(
          height: chartHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. FIXED LEFT SIDEBAR (Unscrollable Y-axis helper)
              SizedBox(
                width: 50,
                child: BarChart(
                  BarChartData(
                    maxY: maxY,
                    minY: 0,
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: leftTitlesConfiguration, 
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32, // Matches right chart's reserved size perfectly
                          getTitlesWidget: (value, meta) => const SizedBox.shrink(), 
                        ),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    // FIXED: Draws the precise vertical divider line on the right side of the fixed view
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        right: BorderSide(color: Colors.grey.shade300, width: 1.5),
                        left: BorderSide.none,
                        top: BorderSide.none,
                        bottom: BorderSide.none,
                      ),
                    ),
                    barGroups: const [], 
                  ),
                ),
              ),

              // 2. HORIZONTALLY SCROLLABLE CHART AREA
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: finalWidth,
                    child: BarChart(
                      BarChartData(
                        maxY: maxY,
                        minY: 0,
                        barTouchData: BarTouchData(
                          handleBuiltInTouches: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (group) => Colors.white,
                            tooltipBorder: BorderSide(color: Colors.grey.shade200, width: 1),
                            tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final String keyName = dataKeys[rodIndex];
                              final Color activeColor = barColors[rodIndex % barColors.length];
                              return BarTooltipItem(
                                '$keyName: ${rod.toY.round()}',
                                TextStyle(
                                  color: activeColor.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: sideTitleInterval,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey.shade100,
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300, width: 1.5),
                            left: BorderSide.none, // FIXED: Removed left border so it doesn't scroll
                            top: BorderSide.none,
                            right: BorderSide.none,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), 
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();
                                if (index >= 0 && index < dataList.length) {
                                  return SideTitleWidget(
                                    meta: meta,
                                    angle: angle,
                                    space: 10,
                                    child: Text(
                                      dataList[index][xAxisKey].toString(),
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),
                        barGroups: List.generate(dataList.length, (groupIndex) {
                          final Map<String, dynamic> currentData = dataList[groupIndex];
                          return BarChartGroupData(
                            x: groupIndex,
                            barsSpace: 4,
                            barRods: List.generate(dataKeys.length, (rodIndex) {
                              final String currentKey = dataKeys[rodIndex];
                              final Color currentBarColor = barColors[rodIndex % barColors.length];
                              final double yValue = (currentData[currentKey] ?? 0 as num).toDouble();

                              return BarChartRodData(
                                toY: yValue,
                                color: currentBarColor,
                                width: 8,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              );
                            }),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}