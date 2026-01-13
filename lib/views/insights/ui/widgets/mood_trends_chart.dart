import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kiara_app_test/views/insights/logic/cubit/insights_cubit.dart';

class MoodTrendsChart extends StatefulWidget {
  final List<MoodPoint> moodData;

  const MoodTrendsChart({super.key, required this.moodData});

  @override
  State<MoodTrendsChart> createState() => _MoodTrendsChartState();
}

class _MoodTrendsChartState extends State<MoodTrendsChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? _touchedIndex;
  double? _touchedX;
  double? _touchedY;
  bool _isTouching = false;
  final GlobalKey _chartKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuart,
      ),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<FlSpot> _getAnimatedSpots() {
    final List<FlSpot> spots = [];

    for (int i = 0; i < widget.moodData.length; i++) {
      final targetY = widget.moodData[i].value;

      // Calculate when this point should appear (left to right)
      final pointProgress = (widget.moodData.length - 1) == 0
          ? 1.0
          : i / (widget.moodData.length - 1);

      // Point appears when animation reaches its position with smoother timing
      final progressThreshold = pointProgress * 0.8;

      if (_animation.value >= progressThreshold) {
        // Calculate how long this point has been visible
        final visibleDuration = _animation.value - progressThreshold;
        final animationDuration = 0.2 + (0.8 / widget.moodData.length);

        // Clamp progress between 0 and 1
        final localProgress = (visibleDuration / animationDuration).clamp(
          0.0,
          1.0,
        );

        // Apply smoother easing
        final easedProgress = Curves.easeInOutQuart.transform(localProgress);

        // Interpolate Y value
        double animatedY;
        if (i == 0) {
          // First point animates from 0 to target
          animatedY = targetY * easedProgress;
        } else {
          // Subsequent points animate from previous value to target
          final previousY = widget.moodData[i - 1].value;
          animatedY = previousY + (targetY - previousY) * easedProgress;
        }

        spots.add(FlSpot(i.toDouble(), animatedY));
      } else {
        // Point hasn't appeared yet - don't add it
        break;
      }
    }

    return spots;
  }

  Offset? _calculateTooltipPosition() {
    if (_touchedIndex == null || _touchedX == null || _touchedY == null) {
      return null;
    }

    final RenderBox? renderBox =
        _chartKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    final chartWidth = renderBox.size.width;
    final chartHeight = renderBox.size.height;

    // Calculate relative position
    final maxX = (widget.moodData.length - 1).toDouble();
    final relativeX = (_touchedX! / maxX) * chartWidth;
    final relativeY = (1 - (_touchedY! / 5.0)) * chartHeight;

    // Position below the dot with left offset
    return Offset(
      relativeX - 60, // Shift left by 60px
      relativeY + 30, // Position below the dot
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
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
                'Mood Trends',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'This Week',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final animatedSpots = _getAnimatedSpots();
              final tooltipPosition = _calculateTooltipPosition();

              return SizedBox(
                height: 200,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    LineChart(
                      key: _chartKey,
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 1,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.white.withOpacity(0.05),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                if (value.toInt() >= 0 &&
                                    value.toInt() < widget.moodData.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      widget.moodData[value.toInt()].day,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.4),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
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
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                if (value >= 1 &&
                                    value <= 5 &&
                                    value % 1 == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      value.toInt().toString(),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.4),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: (widget.moodData.length - 1).toDouble(),
                        minY: 1,
                        maxY: 5.2,
                        extraLinesData: ExtraLinesData(
                          verticalLines: _touchedX != null
                              ? [
                                  VerticalLine(
                                    x: _touchedX!,
                                    color: const Color(
                                      0xFF8BC34A,
                                    ).withOpacity(0.5),
                                    strokeWidth: 2,
                                    dashArray: [5, 5],
                                  ),
                                ]
                              : [],
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: animatedSpots,
                            isCurved: true,
                            curveSmoothness: 0.4,
                            preventCurveOverShooting: true,
                            color: const Color(0xFF8BC34A),
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show:
                                  _animationController.status ==
                                  AnimationStatus.completed,
                              getDotPainter: (spot, percent, barData, index) {
                                final isTouched = _touchedIndex == index;
                                return FlDotCirclePainter(
                                  radius: isTouched ? 8 : 5,
                                  color: isTouched
                                      ? const Color(0xFF8BC34A)
                                      : Colors.transparent,
                                  strokeWidth: 3,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF8BC34A).withOpacity(0.2),
                                  const Color(0xFF8BC34A).withOpacity(0.0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          enabled: _animation.value >= 0.95,
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (_) => [],
                          ),
                          touchCallback:
                              (
                                FlTouchEvent event,
                                LineTouchResponse? response,
                              ) {
                                setState(() {
                                  // Check if user is actively touching
                                  _isTouching =
                                      event is FlTapDownEvent ||
                                      event is FlPanStartEvent ||
                                      event is FlPanUpdateEvent ||
                                      event is FlLongPressStart;

                                  if (_isTouching &&
                                      response != null &&
                                      response.lineBarSpots != null &&
                                      response.lineBarSpots!.isNotEmpty) {
                                    final spot = response.lineBarSpots!.first;
                                    _touchedIndex = spot.spotIndex;
                                    _touchedX = spot.x;
                                    _touchedY = spot.y;
                                  } else {
                                    _touchedIndex = null;
                                    _touchedX = null;
                                    _touchedY = null;
                                  }
                                });
                              },
                          handleBuiltInTouches: true,
                          getTouchedSpotIndicator:
                              (
                                LineChartBarData barData,
                                List<int> spotIndexes,
                              ) {
                                return spotIndexes.map((index) {
                                  return TouchedSpotIndicatorData(
                                    FlLine(
                                      color: Colors.transparent,
                                      strokeWidth: 0,
                                    ),
                                    FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                            return FlDotCirclePainter(
                                              radius: 8,
                                              color: const Color(0xFF8BC34A),
                                              strokeWidth: 3,
                                              strokeColor: Colors.white,
                                            );
                                          },
                                    ),
                                  );
                                }).toList();
                              },
                        ),
                      ),
                      duration: Duration.zero,
                    ),

                    // Custom tooltip
                    if (_isTouching &&
                        _touchedIndex != null &&
                        tooltipPosition != null &&
                        _touchedIndex! < widget.moodData.length)
                      Positioned(
                        left: tooltipPosition.dx,
                        top: tooltipPosition.dy,
                        child: IgnorePointer(
                          child: TweenAnimationBuilder<double>(
                            key: ValueKey(_touchedIndex),
                            duration: const Duration(milliseconds: 200),
                            tween: Tween(begin: 0.0, end: 1.0),
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Opacity(opacity: value, child: child),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(
                                    0xFF8BC34A,
                                  ).withOpacity(0.2),
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
                                    widget.moodData[_touchedIndex!].day,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'mood: ${_touchedY?.toStringAsFixed(1) ?? "0"}',
                                    style: const TextStyle(
                                      color: Color(0xFF8BC34A),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
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
}
