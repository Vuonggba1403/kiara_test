part of 'insight_details_cubit.dart';

@immutable
sealed class InsightDetailsState {}

final class InsightDetailsInitial extends InsightDetailsState {}

final class InsightDetailsLoading extends InsightDetailsState {}

final class InsightDetailsLoaded extends InsightDetailsState {
  final List<WeekProgress> monthlyProgress;
  final WellbeingProfile wellbeingProfile;
  final int overallWellbeing;
  final int growth;
  final int checkIns;
  final String insightText;
  final List<RecommendedAlbum> recommendations;
  final List<PersonalizedInsight> personalizedInsights;

  InsightDetailsLoaded({
    required this.monthlyProgress,
    required this.wellbeingProfile,
    required this.overallWellbeing,
    required this.growth,
    required this.checkIns,
    required this.insightText,
    required this.recommendations,
    required this.personalizedInsights,
  });
}
