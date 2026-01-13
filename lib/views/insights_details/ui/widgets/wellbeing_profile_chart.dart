import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kiara_app_test/views/insights_details/logic/cubit/insight_details_cubit.dart';

class WellbeingProfileChart extends StatelessWidget {
  final WellbeingProfile profile;

  const WellbeingProfileChart({super.key, required this.profile});

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
                'Wellbeing Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.radar, color: const Color(0xFF7CB342), size: 24),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                tickCount: 5,
                ticksTextStyle: TextStyle(
                  color: Colors.transparent,
                  fontSize: 10,
                ),
                radarBorderData: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
                gridBorderData: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
                tickBorderData: BorderSide(color: Colors.transparent),
                getTitle: (index, angle) {
                  final titles = [
                    'Mood',
                    'Energy',
                    'Sleep',
                    'Focus',
                    'Calm',
                    'Social',
                  ];
                  return RadarChartTitle(text: titles[index], angle: angle);
                },
                titleTextStyle: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13,
                ),
                dataSets: [
                  RadarDataSet(
                    fillColor: const Color(0xFF7CB342).withOpacity(0.3),
                    borderColor: const Color(0xFF7CB342),
                    borderWidth: 2,
                    dataEntries: [
                      RadarEntry(value: profile.mood.toDouble()),
                      RadarEntry(value: profile.energy.toDouble()),
                      RadarEntry(value: profile.sleep.toDouble()),
                      RadarEntry(value: profile.focus.toDouble()),
                      RadarEntry(value: profile.calm.toDouble()),
                      RadarEntry(value: profile.social.toDouble()),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('${profile.mood}%', 'Mood'),
              _buildStat('${profile.energy}%', 'Energy'),
              _buildStat('${profile.sleep}%', 'Sleep'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF7CB342),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
        ),
      ],
    );
  }
}
