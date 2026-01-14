import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiara_app_test/core/functions/app_background.dart';
import 'package:kiara_app_test/core/functions/insights_app_bar.dart';
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
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF7CB342)),
                  );
                }

                if (state is! InsightsLoaded) {
                  return const SizedBox.shrink();
                }

                return ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // const SizedBox(height: 20),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     const Text(
                    //       'Mood History',
                    //       style: TextStyle(
                    //         color: AppColors.textColor,
                    //         fontSize: 30,
                    //         fontWeight: FontWeight.bold,
                    //         height: 1.2,
                    //       ),
                    //     ),
                    //     IconButton(
                    //       onPressed: _scrollToCalendar,
                    //       icon: Image.asset(
                    //         'assets/image/calendar.png',
                    //         width: 24,
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    // const SizedBox(height: 24),
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
              },
            ),
          ),
        ),
      ),
    );
  }
}
