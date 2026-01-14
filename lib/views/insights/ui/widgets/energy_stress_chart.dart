import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kiara_app_test/views/insights/logic/cubit/insights_cubit.dart';
import 'package:kiara_app_test/core/functions/color_extension.dart';

class EnergyStressChart extends StatefulWidget {
  final List<EnergyStressPoint> data;

  const EnergyStressChart({super.key, required this.data});

  @override
  State<EnergyStressChart> createState() => _EnergyStressChartState();
}

class _EnergyStressChartState extends State<EnergyStressChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? _touchedIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Energy vs Stress',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 27 / 18,
                ),
              ),
              Row(
                children: [
                  _buildLegend(AppColors.primaryGreen, 'Energy'),
                  const SizedBox(width: 12),
                  _buildLegend(AppColors.stressRed, 'Stress'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return SizedBox(
                height: 200,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 100.7,
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return null;
                            },
                          ),
                          touchCallback:
                              (FlTouchEvent event, barTouchResponse) {
                                if (event is FlTapUpEvent) {
                                  setState(() {
                                    if (barTouchResponse == null ||
                                        barTouchResponse.spot == null) {
                                      _touchedIndex = null;
                                      return;
                                    }
                                    final tappedIndex = barTouchResponse
                                        .spot!
                                        .touchedBarGroupIndex;
                                    if (_touchedIndex == tappedIndex) {
                                      _touchedIndex = null;
                                    } else {
                                      _touchedIndex = tappedIndex;
                                    }
                                  });
                                }
                              },
                          handleBuiltInTouches: false,
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
                                      widget.data[value.toInt()].day,
                                      style: TextStyle(
                                        color: AppColors.textColor.withOpacity(
                                          0.4,
                                        ),
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }
                                return const Text('');
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
                          final isTouched = _touchedIndex == entry.key;
                          return BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value.energy * _animation.value,
                                color: AppColors.primaryGreen,
                                width: isTouched ? 14 : 12,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                              BarChartRodData(
                                toY: entry.value.stress * _animation.value,
                                color: AppColors.stressRed,
                                width: isTouched ? 14 : 12,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    if (_touchedIndex != null &&
                        _touchedIndex! < widget.data.length)
                      Positioned(
                        top: 20,
                        left: _calculateTooltipPosition(),
                        child: IgnorePointer(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.scaffoldDark,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primaryGreen.withOpacity(0.3),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.data[_touchedIndex!].day,
                                  style: const TextStyle(
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'energy: ${widget.data[_touchedIndex!].energy.toInt()}',
                                  style: const TextStyle(
                                    color: AppColors.primaryGreen,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'stress: ${widget.data[_touchedIndex!].stress.toInt()}',
                                  style: const TextStyle(
                                    color: AppColors.stressRed,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  double _calculateTooltipPosition() {
    if (_touchedIndex == null) return 0;
    final chartWidth = 300.0;
    final barCount = widget.data.length;
    final barSpacing = chartWidth / barCount;
    return (_touchedIndex! * barSpacing) - 30;
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textColor.withOpacity(0.7),
            fontSize: 12,
            height: 16 / 12,
          ),
        ),
      ],
    );
  }
}
