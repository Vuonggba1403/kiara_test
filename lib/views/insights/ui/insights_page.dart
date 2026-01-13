import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _calendarKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCalendar() {
    final context = _calendarKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InsightsCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: BlocBuilder<InsightsCubit, InsightsState>(
                  builder: (context, state) {
                    if (state is InsightsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF7CB342),
                        ),
                      );
                    }

                    if (state is InsightsLoaded) {
                      return SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            MoodCalendar(
                              key: _calendarKey,
                              moodDates: state.moodDates,
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Mood History',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: _scrollToCalendar,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
