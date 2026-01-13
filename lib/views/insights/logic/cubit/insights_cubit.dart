import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'insights_state.dart';

class InsightsCubit extends Cubit<InsightsState> {
  InsightsCubit() : super(InsightsInitial()) {
    loadInsights();
  }

  void loadInsights() {
    emit(InsightsLoading());

    Future.delayed(const Duration(milliseconds: 300), () {
      final moodData = [
        MoodPoint(day: 'Mon', value: 3.5),
        MoodPoint(day: 'Tue', value: 2.8),
        MoodPoint(day: 'Wed', value: 4.2),
        MoodPoint(day: 'Thu', value: 3.8),
        MoodPoint(day: 'Fri', value: 4.5),
        MoodPoint(day: 'Sat', value: 4.3),
        MoodPoint(day: 'Sun', value: 5.0),
      ];

      final energyStressData = [
        EnergyStressPoint(day: 'Mon', energy: 70, stress: 25),
        EnergyStressPoint(day: 'Tue', energy: 55, stress: 48),
        EnergyStressPoint(day: 'Wed', energy: 82, stress: 15),
        EnergyStressPoint(day: 'Thu', energy: 65, stress: 28),
        EnergyStressPoint(day: 'Fri', energy: 88, stress: 10),
        EnergyStressPoint(day: 'Sat', energy: 62, stress: 18),
        EnergyStressPoint(day: 'Sun', energy: 85, stress: 12),
      ];

      // Generate mood dates for calendar (dates with mood entries)
      final now = DateTime.now();
      final moodDates = <DateTime>{
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

      emit(
        InsightsLoaded(
          aiInsight:
              'Your mood has been trending upward this week! You seem to feel your best on Friday and Sunday. Consider what activities or habits are contributing to these positive days.',
          moodData: moodData,
          energyStressData: energyStressData,
          avgMood: 4.3,
          avgEnergy: 75,
          avgStress: 28,
          moodDates: moodDates,
        ),
      );
    });
  }
}

class MoodPoint {
  final String day;
  final double value;

  MoodPoint({required this.day, required this.value});
}

class EnergyStressPoint {
  final String day;
  final double energy;
  final double stress;

  EnergyStressPoint({
    required this.day,
    required this.energy,
    required this.stress,
  });
}
