import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kiara_app_test/core/functions/color_extension.dart';
import 'package:kiara_app_test/core/models/wellbeing_models.dart';
import 'package:kiara_app_test/views/insights_details/ui/widgets/mood_high_light_painter.dart';

// Constants cho styling và animation
class _ChartConfig {
  static const Duration animationDuration = Duration(milliseconds: 1500);
  static const Curve animationCurve = Curves.easeOutCubic;

  // Layout
  static const double padding = 24;
  static const double borderRadius = 20;
  static const double borderWidth = 0.6;
  static const double iconSize = 20;
  static const double chartHeight = 280;
  static const double spacing = 20;

  // Radar chart config
  static const int tickCount = 3;
  static const double titleOffset = 0.18;
  static const double radarBorderWidth = 1.2;
  static const double gridBorderWidth = 0.8;
  static const double fillOpacity = 0.25;
  static const double borderColor = 2.5;

  // Colors opacity
  static const double borderOpacity = 0.08;
  static const double shadowOpacity = 0.05;
  static const double gridOpacity = 0.12;
  static const double radarOpacity = 0.25;
  static const double titleOpacity = 0.7;
  static const double textOpacity = 0.7;
}

// Labels cho các tiêu chí wellbeing
class _WellbeingLabels {
  static const List<String> titles = [
    'Mood',
    'Energy',
    'Sleep',
    'Focus',
    'Calm',
    'Social',
  ];
}

/// Widget hiển thị biểu đồ radar cho wellbeing profile
/// Bao gồm 6 chỉ số: Mood, Energy, Sleep, Focus, Calm, Social
/// Có animation khi render lần đầu tiên
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

    // Khởi tạo animation controller
    _controller = AnimationController(
      vsync: this,
      duration: _ChartConfig.animationDuration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: _ChartConfig.animationCurve,
    );

    // Bắt đầu animation sau khi widget được render
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

  // Tính toán giá trị animated từ 0 đến value
  double _animated(double value) => lerpDouble(0, value, _animation.value)!;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Container(
          padding: const EdgeInsets.all(_ChartConfig.padding),
          decoration: _buildContainerDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: _ChartConfig.spacing),
              _buildRadarChart(),
              const SizedBox(height: _ChartConfig.spacing),
              _buildStats(),
            ],
          ),
        );
      },
    );
  }

  // Decoration cho container chính
  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1C1C2E), Color(0xFF252541), Color(0xFF2A2A4A)],
      ),
      borderRadius: BorderRadius.circular(_ChartConfig.borderRadius),
      border: Border.all(
        color: AppColors.textColor.withOpacity(_ChartConfig.borderOpacity),
        width: _ChartConfig.borderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryGreen.withOpacity(_ChartConfig.shadowOpacity),
          blurRadius: 20,
          offset: const Offset(0, 0),
        ),
      ],
    );
  }

  // Build header với tiêu đề và icon
  Widget _buildHeader() {
    return Row(
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
            size: _ChartConfig.iconSize,
          ),
        ),
      ],
    );
  }

  // Build radar chart với custom painter
  Widget _buildRadarChart() {
    return SizedBox(
      height: _ChartConfig.chartHeight,
      child: Stack(
        children: [_buildRadarChartWidget(), _buildMoodScalePainter()],
      ),
    );
  }

  // Build radar chart widget
  Widget _buildRadarChartWidget() {
    return RadarChart(
      RadarChartData(
        radarShape: RadarShape.polygon,
        tickCount: _ChartConfig.tickCount,
        ticksTextStyle: const TextStyle(
          color: AppColors.text2Color,
          fontSize: 0, // Ẩn text của tick
        ),
        radarBorderData: BorderSide(
          color: AppColors.text2Color.withOpacity(_ChartConfig.radarOpacity),
          width: _ChartConfig.radarBorderWidth,
        ),
        gridBorderData: BorderSide(
          color: AppColors.text2Color.withOpacity(_ChartConfig.gridOpacity),
          width: _ChartConfig.gridBorderWidth,
        ),
        tickBorderData: BorderSide(
          color: AppColors.text2Color.withOpacity(_ChartConfig.gridOpacity),
        ),
        radarTouchData: RadarTouchData(enabled: false),
        radarBackgroundColor: Colors.transparent,
        getTitle: _getRadarTitle,
        titleTextStyle: TextStyle(
          color: AppColors.textColor.withOpacity(_ChartConfig.titleOpacity),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        titlePositionPercentageOffset: _ChartConfig.titleOffset,
        dataSets: [_buildRadarDataSet()],
      ),
    );
  }

  // Lấy tiêu đề cho mỗi đỉnh của radar
  RadarChartTitle _getRadarTitle(int index, double angle) {
    return RadarChartTitle(text: _WellbeingLabels.titles[index], angle: 0);
  }

  // Tạo dataset cho radar chart
  RadarDataSet _buildRadarDataSet() {
    return RadarDataSet(
      fillColor: AppColors.primaryGreen.withOpacity(_ChartConfig.fillOpacity),
      borderColor: AppColors.primaryGreen,
      borderWidth: _ChartConfig.borderColor,
      entryRadius: 0,
      dataEntries: [
        RadarEntry(value: _animated(widget.profile.mood.toDouble())),
        RadarEntry(value: _animated(widget.profile.energy.toDouble())),
        RadarEntry(value: _animated(widget.profile.sleep.toDouble())),
        RadarEntry(value: _animated(widget.profile.focus.toDouble())),
        RadarEntry(value: _animated(widget.profile.calm.toDouble())),
        RadarEntry(value: _animated(widget.profile.social.toDouble())),
      ],
    );
  }

  // Build custom painter cho mood scale
  Widget _buildMoodScalePainter() {
    return CustomPaint(
      size: const Size(_ChartConfig.chartHeight, _ChartConfig.chartHeight),
      painter: MoodScalePainter(
        tickCount: 4,
        color: AppColors.text2Color.withOpacity(_ChartConfig.textOpacity),
      ),
    );
  }

  // Build thống kê các chỉ số chính
  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStat('${widget.profile.mood}%', 'Mood'),
        _buildStat('${widget.profile.energy}%', 'Energy'),
        _buildStat('${widget.profile.sleep}%', 'Sleep'),
      ],
    );
  }

  // Widget hiển thị một stat item (giá trị + label)
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
