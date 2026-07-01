import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DynamicLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> dataList;
  final String xAxisKey;  
  final List<String> dataKeys;     
  final List<Color> lineColors;   
  final double chartHeight;

  const DynamicLineChart({
    super.key,
    required this.dataList,
    required this.xAxisKey,
    required this.dataKeys,
    required this.lineColors,
    this.chartHeight = 260.0,
  });

  @override
  Widget build(BuildContext context) {
    if (dataList.isEmpty || dataKeys.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(child: Text('No data available')),
      );
    }

    double maxVal = 0.0;
    for (var data in dataList) {
      for (var key in dataKeys) {
        if (data.containsKey(key) && data[key] is num) {
          final double currentVal = (data[key] as num).toDouble();
          if (currentVal > maxVal) maxVal = currentVal;
        }
      }
    }
    final double maxY = maxVal > 0 ? maxVal * 1.2 : 100.0;
    final double sideTitleInterval = maxY / 4 > 0 ? maxY / 4 : 1;

    AxisTitles leftTitlesConfiguration = AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 46,
        interval: sideTitleInterval,
        getTitlesWidget: (value, meta) {
          if (value >= 1000) {
            return SideTitleWidget(
              meta: meta,
              space: 6,
              child: Text('${(value / 1000).toStringAsFixed(1)}K',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
            );
          }
          return SideTitleWidget(
            meta: meta,
            space: 6,
            child: Text(value.toInt().toString(),
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
          );
        },
      ),
    );

    List<LineChartBarData> generateLines() {
      return List.generate(dataKeys.length, (lineIndex) {
        final String currentKey = dataKeys[lineIndex];
        final Color currentColor = lineColors[lineIndex % lineColors.length];

        return LineChartBarData(
          isCurved: false,
          color: currentColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: currentColor.withValues(alpha:0.04),
          ),
          spots: List.generate(dataList.length, (index) {
            final double yValue = (dataList[index][currentKey] as num).toDouble();
            return FlSpot(index.toDouble(), yValue);
          }),
        );
      });
    }

    final double computedChartWidth = dataList.length * 65.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableChartWidth = constraints.maxWidth - 50;
        final double finalWidth = computedChartWidth < availableChartWidth ? availableChartWidth : computedChartWidth;

        return SizedBox(
          height: chartHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. FIXED LEFT SIDEBAR (Container border removed, native chart border added)
              SizedBox(
                width: 50,
                child: LineChart(
                  LineChartData(
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
                          reservedSize: 32,
                          getTitlesWidget: (value, meta) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    // FIXED: Ab fl_chart khud right hand side par line draw karega, jo precise bottom axis tak hi rukegi
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        right: BorderSide(color: Colors.grey.shade300, width: 1.5),
                        left: BorderSide.none,
                        top: BorderSide.none,
                        bottom: BorderSide.none,
                      ),
                    ),
                    lineBarsData: const [],
                  ),
                ),
              ),

              // 2. HORIZONTALLY SCROLLABLE LINE CHART VIEWPORT
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: finalWidth,
                    child: LineChart(
                      LineChartData(
                        maxY: maxY,
                        minY: 0,
                        lineTouchData: LineTouchData(
                          handleBuiltInTouches: true,
                          distanceCalculator: (touchPoint, spotPixelCoordinates) {
                            final dx = touchPoint.dx - spotPixelCoordinates.dx;
                            final dy = touchPoint.dy - spotPixelCoordinates.dy;
                            return (dx * dx + dy * dy);
                          },
                          touchSpotThreshold: 16,
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (LineBarSpot touchedSpot) => Colors.white,
                            tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            tooltipBorder: BorderSide(color: Colors.grey.shade200, width: 1),
                            getTooltipItems: (List<LineBarSpot> touchedSpots) {
                              return touchedSpots.map((LineBarSpot touchedSpot) {
                                final String keyName = dataKeys[touchedSpot.barIndex];
                                final Color lineColor = lineColors[touchedSpot.barIndex % lineColors.length];

                                return LineTooltipItem(
                                  '$keyName: ${touchedSpot.y.toInt()}',
                                  TextStyle(
                                    color: lineColor.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey.shade200,
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300, width: 1.5),
                            left: BorderSide.none, 
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
                        lineBarsData: generateLines(),
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