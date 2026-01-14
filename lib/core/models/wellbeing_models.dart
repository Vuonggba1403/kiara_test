import 'package:flutter/material.dart';

/// Represents weekly progress data
class WeekProgress {
  final String week;
  final int value;

  WeekProgress({required this.week, required this.value});
}

/// Represents wellbeing profile across different dimensions
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

/// Represents a recommended music album
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

/// Represents a personalized insight with recommendations
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
