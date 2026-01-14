import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:kiara_app_test/views/insights/logic/repositories/insights_repository.dart';

part 'insights_state.dart';

/// Cubit quản lý trạng thái của trang Insights
/// Chịu trách nhiệm load và xử lý dữ liệu mood, energy, stress
class InsightsCubit extends Cubit<InsightsState> {
  final InsightsRepository _repository;

  InsightsCubit({InsightsRepository? repository})
    : _repository = repository ?? InsightsRepository(),
      super(InsightsLoading()) {
    loadInsights();
  }

  /// Load tất cả dữ liệu insights
  /// Bao gồm: mood data, energy/stress data, mood dates, AI insight
  Future<void> loadInsights() async {
    try {
      final results = await Future.wait([
        _repository.getMoodData(),
        _repository.getEnergyStressData(),
        _repository.getMoodDates(),
        _repository.getAIInsight(),
      ]);

      final moodData = results[0] as List<MoodPoint>;
      final energyStressData = results[1] as List<EnergyStressPoint>;
      final moodDates = results[2] as Set<DateTime>;
      final aiInsight = results[3] as String;

      final stats = await _repository.getStatistics(moodData, energyStressData);

      emit(
        InsightsLoaded(
          aiInsight: aiInsight,
          moodData: moodData,
          energyStressData: energyStressData,
          avgMood: stats['avgMood'] as double,
          avgEnergy: stats['avgEnergy'] as int,
          avgStress: stats['avgStress'] as int,
          moodDates: moodDates,
        ),
      );
    } catch (e) {
      emit(InsightsError('Failed to load insights: $e'));
    }
  }
}

/// Model cho 1 điểm dữ liệu mood
class MoodPoint {
  final String day;
  final double value;

  MoodPoint({required this.day, required this.value});
}

/// Model cho 1 điểm dữ liệu energy và stress
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
