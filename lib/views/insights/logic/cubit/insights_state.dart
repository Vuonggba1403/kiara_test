part of 'insights_cubit.dart';

@immutable
sealed class InsightsState {}

final class InsightsInitial extends InsightsState {}

final class InsightsLoading extends InsightsState {}

final class InsightsLoaded extends InsightsState {
  final String aiInsight;
  final List<MoodPoint> moodData;
  final List<EnergyStressPoint> energyStressData;
  final double avgMood;
  final int avgEnergy;
  final int avgStress;
  final Set<DateTime> moodDates;

  InsightsLoaded({
    required this.aiInsight,
    required this.moodData,
    required this.energyStressData,
    required this.avgMood,
    required this.avgEnergy,
    required this.avgStress,
    required this.moodDates,
  });
}

final class InsightsError extends InsightsState {
  final String message;

  InsightsError(this.message);
}
