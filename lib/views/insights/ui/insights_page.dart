import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiara_app_test/core/functions/app_background.dart';
import 'package:kiara_app_test/core/functions/insights_app_bar.dart';
import 'package:kiara_app_test/core/functions/animated_list_view.dart';
import 'package:kiara_app_test/views/insights/logic/cubit/insights_cubit.dart';
import 'package:kiara_app_test/views/insights/ui/widgets/ai_insight_card.dart';
import 'package:kiara_app_test/views/insights/ui/widgets/energy_stress_chart.dart';
import 'package:kiara_app_test/views/insights/ui/widgets/mood_calendar.dart';
import 'package:kiara_app_test/views/insights/ui/widgets/mood_trends_chart.dart';
import 'package:kiara_app_test/views/insights/ui/widgets/stats_cards.dart';

class _LayoutConfig {
  static const double horizontalPadding = 20;
  static const double spacing = 24;
  static const double bottomSpacing = 20;

  static const Duration scrollDuration = Duration(milliseconds: 600);
  static const Curve scrollCurve = Curves.easeInOutCubic;

  static const double skeletonCard1Height = 120;
  static const double skeletonCard2Height = 250;
  static const double skeletonCard3Height = 200;
}

/// Trang hiển thị insights và lịch sử mood
/// Bao gồm: AI insight, mood trends, energy/stress chart, stats, calendar
class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  late final ScrollController _scrollController;
  final _calendarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCalendar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        _scrollController.animateTo(
          maxScroll,
          duration: _LayoutConfig.scrollDuration,
          curve: _LayoutConfig.scrollCurve,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InsightsCubit(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AppBackground(
          child: SafeArea(
            child: BlocBuilder<InsightsCubit, InsightsState>(
              builder: (context, state) {
                if (state is InsightsLoading) {
                  return _buildLoadingSkeleton();
                }

                if (state is InsightsLoaded) {
                  return _buildContent(state);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(InsightsLoaded state) {
    return AnimatedListView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: _LayoutConfig.horizontalPadding,
      ),
      children: [
        _buildAppBar(),
        AIInsightCard(insight: state.aiInsight),
        const SizedBox(height: _LayoutConfig.spacing),
        MoodTrendsChart(moodData: state.moodData),
        const SizedBox(height: _LayoutConfig.spacing),
        EnergyStressChart(data: state.energyStressData),
        const SizedBox(height: _LayoutConfig.spacing),
        _buildStatsCards(state),
        const SizedBox(height: _LayoutConfig.spacing),
        _buildCalendar(state),
        const SizedBox(height: _LayoutConfig.bottomSpacing),
      ],
    );
  }

  Widget _buildAppBar() {
    return InsightsAppBar(
      title: "Mood History",
      actionIconPath: 'assets/image/calendar.png',
      onActionTap: _scrollToCalendar,
    );
  }

  Widget _buildStatsCards(InsightsLoaded state) {
    return StatsCards(
      avgMood: state.avgMood,
      avgEnergy: state.avgEnergy,
      avgStress: state.avgStress,
    );
  }

  Widget _buildCalendar(InsightsLoaded state) {
    return Container(
      key: _calendarKey,
      child: MoodCalendar(moodDates: state.moodDates),
    );
  }

  Widget _buildLoadingSkeleton() {
    return AnimatedListView(
      padding: const EdgeInsets.symmetric(
        horizontal: _LayoutConfig.horizontalPadding,
      ),
      children: [
        const SizedBox(height: 60),
        _buildSkeletonCard(height: _LayoutConfig.skeletonCard1Height),
        const SizedBox(height: _LayoutConfig.spacing),
        _buildSkeletonCard(height: _LayoutConfig.skeletonCard2Height),
        const SizedBox(height: _LayoutConfig.spacing),
        _buildSkeletonCard(height: _LayoutConfig.skeletonCard3Height),
        const SizedBox(height: _LayoutConfig.spacing),
        Row(
          children: [
            Expanded(child: _buildSkeletonCard(height: 100)),
            const SizedBox(width: 12),
            Expanded(child: _buildSkeletonCard(height: 100)),
            const SizedBox(width: 12),
            Expanded(child: _buildSkeletonCard(height: 100)),
          ],
        ),
      ],
    );
  }

  Widget _buildSkeletonCard({required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _ShimmerEffect(),
      ),
    );
  }
}

class _ShimmerEffect extends StatefulWidget {
  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.white.withOpacity(0.05),
                Colors.white.withOpacity(0.0),
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ],
            ),
          ),
        );
      },
    );
  }
}
