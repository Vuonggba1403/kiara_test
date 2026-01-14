import 'package:flutter/material.dart';
import 'package:kiara_app_test/core/models/wellbeing_models.dart';

/// Repository for fetching insight details data
class InsightDetailsRepository {
  /// Fetches monthly progress data
  Future<List<WeekProgress>> getMonthlyProgress() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 50));

    return [
      WeekProgress(week: 'W1', value: 65),
      WeekProgress(week: 'W2', value: 72),
      WeekProgress(week: 'W3', value: 78),
      WeekProgress(week: 'W4', value: 85),
    ];
  }

  /// Fetches wellbeing profile data
  Future<WellbeingProfile> getWellbeingProfile() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 50));

    return WellbeingProfile(
      mood: 85,
      energy: 75,
      sleep: 70,
      focus: 65,
      calm: 60,
      social: 55,
    );
  }

  /// Fetches recommended albums
  Future<List<RecommendedAlbum>> getRecommendedAlbums() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 50));

    return [
      RecommendedAlbum(
        title: 'Morning Clarity',
        category: 'Focus & Energy',
        duration: '15 min',
        plays: '1.2k plays',
        color: const Color(0xFF8B7355),
      ),
      RecommendedAlbum(
        title: 'Calm Waters',
        category: 'Relaxation',
        duration: '20 min',
        plays: '2.4k plays',
        color: const Color(0xFF4A6572),
      ),
      RecommendedAlbum(
        title: 'Inner Peace',
        category: 'Meditation',
        duration: '25 min',
        plays: '3.1k plays',
        color: const Color(0xFF5A6B4E),
      ),
    ];
  }

  /// Fetches personalized insights
  Future<List<PersonalizedInsight>> getPersonalizedInsights() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 50));

    return [
      PersonalizedInsight(
        title: 'Mood Patterns',
        description:
            'Your mood peaks on weekends and tends to dip mid-week. Consider scheduling self-care activities on Wednesdays.',
        icon: Icons.trending_up_outlined,
        color: const Color(0xFF7CB342),
      ),
      PersonalizedInsight(
        title: 'Energy Levels',
        description:
            'You have the most energy in the mornings. Try tackling important tasks before noon for optimal productivity.',
        icon: Icons.bolt_outlined,
        color: const Color(0xFFFFB74D),
      ),
      PersonalizedInsight(
        title: 'Stress Management',
        description:
            'Your stress levels decrease significantly after using frequency albums. Keep up this healthy habit!',
        icon: Icons.favorite_outline,
        color: const Color(0xFFEC407A),
      ),
    ];
  }

  /// Fetches overall wellbeing summary
  Future<Map<String, dynamic>> getOverallWellbeingSummary() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 50));

    return {
      'overallWellbeing': 85,
      'growth': 23,
      'checkIns': 28,
      'insightText':
          "You're doing wonderfully! Your emotional awareness has increased by 23% this month. You're taking meaningful steps toward balance and self-care.",
    };
  }
}
