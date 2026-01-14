import 'dart:math';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kiara_app_test/core/functions/color_extension.dart';
import 'package:kiara_app_test/core/models/wellbeing_models.dart';
import 'package:kiara_app_test/views/insights_details/ui/widgets/mood_high_light_painter.dart';

class WellbeingProfileChart extends StatefulWidget {
  final WellbeingProfile profile;

  const WellbeingProfileChart({super.key, required this.profile});

  @override
  State<WellbeingProfileChart> createState() => _WellbeingProfileChartState();
}

class _WellbeingProfileChartState extends State<WellbeingProfileChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    // Delay animation slightly for better visibility
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _animated(double value) => lerpDouble(0, value, _animation.value)!;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1C1C2E), Color(0xFF252541), Color(0xFF2A2A4A)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.textColor.withOpacity(0.08),
              width: 0.6,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Wellbeing Profile',
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.psychology,
                      color: AppColors.primaryGreen,
                      size: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ================= RADAR =================
              SizedBox(
                height: 280,
                child: Stack(
                  children: [
                    RadarChart(
                      RadarChartData(
                        radarShape: RadarShape.polygon,
                        tickCount: 3,
                        //Custom the ticks to be invisible
                        ticksTextStyle: const TextStyle(
                          color: AppColors.text2Color,
                          fontSize: 0,
                        ),
                        radarBorderData: BorderSide(
                          color: AppColors.text2Color.withOpacity(0.25),
                          width: 1.2,
                        ),
                        gridBorderData: BorderSide(
                          color: AppColors.text2Color.withOpacity(0.12),
                          width: 0.8,
                        ),
                        tickBorderData: BorderSide(
                          color: AppColors.text2Color.withOpacity(0.12),
                        ),
                        radarTouchData: RadarTouchData(enabled: false),
                        radarBackgroundColor: Colors.transparent,
                        getTitle: (index, _) {
                          const titles = [
                            'Mood',
                            'Energy',
                            'Sleep',
                            'Focus',
                            'Calm',
                            'Social',
                          ];
                          return RadarChartTitle(text: titles[index], angle: 0);
                        },
                        titleTextStyle: TextStyle(
                          color: AppColors.textColor.withOpacity(0.7),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        titlePositionPercentageOffset: 0.18,
                        dataSets: [
                          RadarDataSet(
                            fillColor: AppColors.primaryGreen.withOpacity(0.25),
                            borderColor: AppColors.primaryGreen,
                            borderWidth: 2.5,
                            entryRadius: 0,
                            dataEntries: [
                              RadarEntry(
                                value: _animated(
                                  widget.profile.mood.toDouble(),
                                ),
                              ),
                              RadarEntry(
                                value: _animated(
                                  widget.profile.energy.toDouble(),
                                ),
                              ),
                              RadarEntry(
                                value: _animated(
                                  widget.profile.sleep.toDouble(),
                                ),
                              ),
                              RadarEntry(
                                value: _animated(
                                  widget.profile.focus.toDouble(),
                                ),
                              ),
                              RadarEntry(
                                value: _animated(
                                  widget.profile.calm.toDouble(),
                                ),
                              ),
                              RadarEntry(
                                value: _animated(
                                  widget.profile.social.toDouble(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    CustomPaint(
                      size: const Size(280, 280),
                      painter: MoodScalePainter(
                        tickCount: 4,
                        color: AppColors.text2Color.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= STATS =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('${widget.profile.mood}%', 'Mood'),
                  _buildStat('${widget.profile.energy}%', 'Energy'),
                  _buildStat('${widget.profile.sleep}%', 'Sleep'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textColor.withOpacity(0.5),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
