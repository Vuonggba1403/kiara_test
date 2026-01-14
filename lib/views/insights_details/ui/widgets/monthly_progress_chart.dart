import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kiara_app_test/core/functions/color_extension.dart';
import 'package:kiara_app_test/core/models/wellbeing_models.dart';

class MonthlyProgressChart extends StatefulWidget {
  final List<WeekProgress> data;

  const MonthlyProgressChart({super.key, required this.data});

  @override
  State<MonthlyProgressChart> createState() => _MonthlyProgressChartState();
}

class _MonthlyProgressChartState extends State<MonthlyProgressChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Progress',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.trending_up, color: AppColors.primaryGreen, size: 24),
            ],
          ),

          const SizedBox(height: 24),

          // Bar Chart
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          barTouchResponse == null ||
                          barTouchResponse.spot == null) {
                        _touchedIndex = null;
                        return;
                      }
                      _touchedIndex =
                          barTouchResponse.spot!.touchedBarGroupIndex;
                    });
                  },
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => const Color(0xFF2D2F3E),
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    tooltipMargin: 8,
                    tooltipBorder: const BorderSide(color: Color(0xFF2D2F3E)),
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()}%',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < widget.data.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              widget.data[value.toInt()].week,
                              style: TextStyle(
                                color: AppColors.textColor.withOpacity(0.4),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),

                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 25,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: AppColors.textColor.withOpacity(0.4),
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),

                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.textColor.withOpacity(0.05),
                      strokeWidth: 1,
                    );
                  },
                ),

                borderData: FlBorderData(show: false),

                barGroups: widget.data.asMap().entries.map((entry) {
                  final isTouched = entry.key == _touchedIndex;
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.value.toDouble(),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: isTouched
                              ? [
                                  AppColors.primaryGreen.withOpacity(0.8),
                                  const Color(0xFF9CCC65).withOpacity(0.8),
                                ]
                              : [
                                  AppColors.primaryGreen,
                                  const Color(0xFF9CCC65),
                                ],
                        ),
                        width: isTouched ? 55 : 50,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
