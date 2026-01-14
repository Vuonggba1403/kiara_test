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

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  final _scrollController = ScrollController();
  final _calendarKey = GlobalKey();

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
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
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
                  return AnimatedListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      InsightsAppBar(
                        title: "Mood History",
                        actionIconPath: 'assets/image/calendar.png',
                        onActionTap: _scrollToCalendar,
                      ),

                      AIInsightCard(insight: state.aiInsight),
                      const SizedBox(height: 24),

                      MoodTrendsChart(moodData: state.moodData),
                      const SizedBox(height: 24),

                      EnergyStressChart(data: state.energyStressData),
                      const SizedBox(height: 24),

                      StatsCards(
                        avgMood: state.avgMood,
                        avgEnergy: state.avgEnergy,
                        avgStress: state.avgStress,
                      ),
                      const SizedBox(height: 24),

                      Container(
                        key: _calendarKey,
                        child: MoodCalendar(moodDates: state.moodDates),
                      ),

                      const SizedBox(height: 20),
                    ],
                  );
                }

                // Fallback for error or other states
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return AnimatedListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 60),
        _buildSkeletonCard(height: 120),
        const SizedBox(height: 24),
        _buildSkeletonCard(height: 250),
        const SizedBox(height: 24),
        _buildSkeletonCard(height: 250),
        const SizedBox(height: 24),
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
