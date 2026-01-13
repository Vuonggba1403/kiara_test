import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

part 'insight_details_state.dart';

class InsightDetailsCubit extends Cubit<InsightDetailsState> {
  InsightDetailsCubit() : super(InsightDetailsInitial()) {
    loadDetails();
  }

  void loadDetails() {
    emit(InsightDetailsLoading());

    Future.delayed(const Duration(milliseconds: 300), () {
      final monthlyProgress = [
        WeekProgress(week: 'W1', value: 65),
        WeekProgress(week: 'W2', value: 72),
        WeekProgress(week: 'W3', value: 78),
        WeekProgress(week: 'W4', value: 85),
      ];

      final wellbeingProfile = WellbeingProfile(
        mood: 85,
        energy: 75,
        sleep: 70,
        focus: 65,
        calm: 60,
        social: 55,
      );

      final recommendations = [
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

      final personalizedInsights = [
        PersonalizedInsight(
          title: 'Mood Patterns',
          description:
              'Your mood peaks on weekends and tends to dip mid-week. Consider scheduling self-care activities on Wednesdays.',
          icon: Icons.trending_up,
          color: const Color(0xFF7CB342),
        ),
        PersonalizedInsight(
          title: 'Energy Levels',
          description:
              'You have the most energy in the mornings. Try tackling important tasks before noon for optimal productivity.',
          icon: Icons.bolt,
          color: const Color(0xFFFFB74D),
        ),
        PersonalizedInsight(
          title: 'Stress Management',
          description:
              'Your stress levels decrease significantly after using frequency albums. Keep up this healthy habit!',
          icon: Icons.favorite,
          color: const Color(0xFFEC407A),
        ),
      ];

      emit(
        InsightDetailsLoaded(
          monthlyProgress: monthlyProgress,
          wellbeingProfile: wellbeingProfile,
          overallWellbeing: 85,
          growth: 23,
          checkIns: 28,
          insightText:
              "You're doing wonderfully! Your emotional awareness has increased by 23% this month. You're taking meaningful steps toward balance and self-care.",
          recommendations: recommendations,
          personalizedInsights: personalizedInsights,
        ),
      );
    });
  }
}

class WeekProgress {
  final String week;
  final int value;

  WeekProgress({required this.week, required this.value});
}

class WellbeingProfile {
  final int mood;
  final int energy;
  final int sleep;
  final int focus;
  final int calm;
  final int social;

  WellbeingProfile({
    required this.mood,
    required this.energy,
    required this.sleep,
    required this.focus,
    required this.calm,
    required this.social,
  });
}

class RecommendedAlbum {
  final String title;
  final String category;
  final String duration;
  final String plays;
  final Color color;

  RecommendedAlbum({
    required this.title,
    required this.category,
    required this.duration,
    required this.plays,
    required this.color,
  });
}

class PersonalizedInsight {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  PersonalizedInsight({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
