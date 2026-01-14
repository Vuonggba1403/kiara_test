import 'package:kiara_app_test/views/insights/logic/cubit/insights_cubit.dart';

/// Repository for fetching insights data
class InsightsRepository {
  /// Fetches mood data for the week
  Future<List<MoodPoint>> getMoodData() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 50));

    return [
      MoodPoint(day: 'Mon', value: 3.5),
      MoodPoint(day: 'Tue', value: 2.8),
      MoodPoint(day: 'Wed', value: 4.2),
      MoodPoint(day: 'Thu', value: 3.8),
      MoodPoint(day: 'Fri', value: 4.5),
      MoodPoint(day: 'Sat', value: 4.3),
      MoodPoint(day: 'Sun', value: 5.0),
    ];
  }

  /// Fetches energy and stress data
  Future<List<EnergyStressPoint>> getEnergyStressData() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 50));

    return [
      EnergyStressPoint(day: 'Mon', energy: 70, stress: 25),
      EnergyStressPoint(day: 'Tue', energy: 55, stress: 48),
      EnergyStressPoint(day: 'Wed', energy: 82, stress: 15),
      EnergyStressPoint(day: 'Thu', energy: 65, stress: 28),
      EnergyStressPoint(day: 'Fri', energy: 88, stress: 10),
      EnergyStressPoint(day: 'Sat', energy: 62, stress: 18),
      EnergyStressPoint(day: 'Sun', energy: 85, stress: 12),
    ];
  }

  /// Fetches mood dates for calendar
  Future<Set<DateTime>> getMoodDates() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 50));

    final now = DateTime.now();
    return {
      DateTime(now.year, now.month, 1),
      DateTime(now.year, now.month, 3),
      DateTime(now.year, now.month, 5),
      DateTime(now.year, now.month, 6),
      DateTime(now.year, now.month, 7),
      DateTime(now.year, now.month, 8),
      DateTime(now.year, now.month, 10),
      DateTime(now.year, now.month, 11),
      DateTime(now.year, now.month, 12),
      DateTime(now.year, now.month, 13),
      DateTime(now.year, now.month, 14),
      DateTime(now.year, now.month, 15),
      DateTime(now.year, now.month, 17),
      DateTime(now.year, now.month, 18),
      DateTime(now.year, now.month, 19),
      DateTime(now.year, now.month, 20),
      DateTime(now.year, now.month, 21),
      DateTime(now.year, now.month, 22),
      DateTime(now.year, now.month, 24),
      DateTime(now.year, now.month, 25),
      DateTime(now.year, now.month, 26),
      DateTime(now.year, now.month, 27),
      DateTime(now.year, now.month, 28),
      DateTime(now.year, now.month, 29),
      DateTime(now.year, now.month, 31),
    };
  }

  /// Fetches AI-generated insight text
  Future<String> getAIInsight() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 50));

    return 'Your mood has been trending upward this week! You seem to feel your best on Friday and Sunday. Consider what activities or habits are contributing to these positive days.';
  }

  /// Calculates statistics
  Future<Map<String, dynamic>> getStatistics(
    List<MoodPoint> moodData,
    List<EnergyStressPoint> energyStressData,
  ) async {
    // Simulate calculation
    await Future.delayed(const Duration(milliseconds: 50));

    final avgMood = moodData.isEmpty
        ? 0.0
        : moodData.map((e) => e.value).reduce((a, b) => a + b) /
              moodData.length;

    final avgEnergy = energyStressData.isEmpty
        ? 0
        : (energyStressData.map((e) => e.energy).reduce((a, b) => a + b) /
                  energyStressData.length)
              .round();

    final avgStress = energyStressData.isEmpty
        ? 0
        : (energyStressData.map((e) => e.stress).reduce((a, b) => a + b) /
                  energyStressData.length)
              .round();

    return {'avgMood': avgMood, 'avgEnergy': avgEnergy, 'avgStress': avgStress};
  }
}
