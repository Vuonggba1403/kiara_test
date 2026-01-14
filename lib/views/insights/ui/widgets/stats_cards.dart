import 'package:flutter/material.dart';
import 'package:kiara_app_test/core/functions/color_extension.dart';

class StatsCards extends StatelessWidget {
  final double avgMood;
  final int avgEnergy;
  final int avgStress;

  const StatsCards({
    super.key,
    required this.avgMood,
    required this.avgEnergy,
    required this.avgStress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.sentiment_satisfied_rounded,
            value: avgMood.toStringAsFixed(1),
            label: 'Avg Mood',
            backgroundColor: AppColors.primaryGreen,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.bolt,
            value: '$avgEnergy%',
            label: 'Avg Energy',
            backgroundColor: AppColors.orangeAccent,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.air,
            value: '$avgStress%',
            label: 'Avg Stress',
            backgroundColor: AppColors.lightBlueAccent,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textColor,
              fontSize: 20,
              height: 28 / 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.text2Color,
              fontSize: 12,
              height: 16 / 12,
            ),
          ),
        ],
      ),
    );
  }
}
