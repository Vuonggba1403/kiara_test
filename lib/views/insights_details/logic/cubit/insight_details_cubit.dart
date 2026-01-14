import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:kiara_app_test/core/models/wellbeing_models.dart';
import 'package:kiara_app_test/views/insights_details/logic/repositories/insight_details_repository.dart';

part 'insight_details_state.dart';

class InsightDetailsCubit extends Cubit<InsightDetailsState> {
  final InsightDetailsRepository _repository;

  InsightDetailsCubit({InsightDetailsRepository? repository})
    : _repository = repository ?? InsightDetailsRepository(),
      super(InsightDetailsInitial()) {
    loadDetails();
  }

  Future<void> loadDetails() async {
    emit(InsightDetailsLoading());

    try {
      // Fetch data from repository
      final results = await Future.wait([
        _repository.getMonthlyProgress(),
        _repository.getWellbeingProfile(),
        _repository.getRecommendedAlbums(),
        _repository.getPersonalizedInsights(),
        _repository.getOverallWellbeingSummary(),
      ]);

      final monthlyProgress = results[0] as List<WeekProgress>;
      final wellbeingProfile = results[1] as WellbeingProfile;
      final recommendations = results[2] as List<RecommendedAlbum>;
      final personalizedInsights = results[3] as List<PersonalizedInsight>;
      final summary = results[4] as Map<String, dynamic>;

      emit(
        InsightDetailsLoaded(
          monthlyProgress: monthlyProgress,
          wellbeingProfile: wellbeingProfile,
          overallWellbeing: summary['overallWellbeing'] as int,
          growth: summary['growth'] as int,
          checkIns: summary['checkIns'] as int,
          insightText: summary['insightText'] as String,
          recommendations: recommendations,
          personalizedInsights: personalizedInsights,
        ),
      );
    } catch (e) {
      // Handle error if needed
      emit(InsightDetailsInitial());
    }
  }
}
