import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiara_app_test/core/functions/app_background.dart';
import 'package:kiara_app_test/core/functions/insights_app_bar.dart';
import 'package:kiara_app_test/core/functions/animated_list_view.dart';
import 'package:kiara_app_test/views/insights_details/logic/cubit/insight_details_cubit.dart';
import 'package:kiara_app_test/views/insights_details/ui/widgets/monthly_progress_chart.dart';
import 'package:kiara_app_test/views/insights_details/ui/widgets/overall_wellbeing_card.dart';
import 'package:kiara_app_test/views/insights_details/ui/widgets/wellbeing_profile_chart.dart';
import 'package:kiara_app_test/views/insights_details/ui/widgets/personalized_insights_section.dart';
import 'package:kiara_app_test/views/insights_details/ui/widgets/recommended_music_section.dart';
import 'package:kiara_app_test/views/music_player/ui/music_player_page.dart';
import 'package:kiara_app_test/core/models/song_model.dart';
import 'package:kiara_app_test/core/functions/color_extension.dart';
import 'package:kiara_app_test/views/music_player/logic/cubit/global_music_player_cubit.dart';

class _LayoutConfig {
  static const double padding = 20;
  static const double spacing = 24;
  static const double largeSpacing = 32;
  static const double bottomPadding = 100;
  static const double buttonVerticalPadding = 16;
  static const double buttonRadius = 16;

  static const double skeletonHeaderHeight = 60;
  static const double skeletonCard1Height = 180;
  static const double skeletonCard2Height = 200;
  static const double skeletonCard3Height = 150;
  static const double skeletonCard4Height = 200;
  static const double skeletonCard5Height = 250;
}

/// Trang hiển thị chi tiết insights về wellbeing
/// Bao gồm: overall wellbeing, profile chart, monthly progress, insights, music recommendations
class InsightDetailsPage extends StatefulWidget {
  const InsightDetailsPage({super.key});

  @override
  State<InsightDetailsPage> createState() => _InsightDetailsPageState();
}

class _InsightDetailsPageState extends State<InsightDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InsightDetailsCubit(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AppBackground(
          child: SafeArea(
            child: BlocBuilder<InsightDetailsCubit, InsightDetailsState>(
              builder: (context, state) {
                if (state is InsightDetailsLoading) {
                  return _buildLoadingSkeleton();
                }

                if (state is InsightDetailsLoaded) {
                  return _buildContent(context, state);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, InsightDetailsLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(_LayoutConfig.padding),
      child: AnimatedColumn(
        children: [
          _buildAppBar(context),
          _buildOverallWellbeingCard(state),
          const SizedBox(height: _LayoutConfig.spacing),
          WellbeingProfileChart(profile: state.wellbeingProfile),
          const SizedBox(height: _LayoutConfig.spacing),
          MonthlyProgressChart(data: state.monthlyProgress),
          const SizedBox(height: _LayoutConfig.largeSpacing),
          PersonalizedInsightsSection(insights: state.personalizedInsights),
          const SizedBox(height: _LayoutConfig.largeSpacing),
          _buildRecommendedMusic(context, state),
          const SizedBox(height: 12),
          _buildBrowseAllButton(context),
          const SizedBox(height: _LayoutConfig.bottomPadding),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return InsightsAppBar(
      title: "Insights",
      actionIconPath: 'assets/image/close.png',
      onActionTap: () => Navigator.pop(context),
    );
  }

  Widget _buildOverallWellbeingCard(InsightDetailsLoaded state) {
    return OverallWellbeingCard(
      overallWellbeing: state.overallWellbeing,
      growth: state.growth,
      checkIns: state.checkIns,
      insightText: state.insightText,
    );
  }

  Widget _buildRecommendedMusic(
    BuildContext context,
    InsightDetailsLoaded state,
  ) {
    return RecommendedMusicSection(
      recommendations: state.recommendations,
      onSongTap: _handleSongTap,
    );
  }

  /// Xử lý khi user tap vào bài hát - load nhạc và mở music player
  void _handleSongTap(BuildContext context, SongModel song) {
    context.read<GlobalMusicPlayerCubit>().loadSong(song);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MusicPlayerPage(song: song)),
    );
  }

  Widget _buildBrowseAllButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _navigateToSoundsPage(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: _LayoutConfig.buttonVerticalPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_LayoutConfig.buttonRadius),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Browse All Albums',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _navigateToSoundsPage(BuildContext context) {
    Navigator.pop(context);
  }

  /// Build loading skeleton khi đang load dữ liệu
  Widget _buildLoadingSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(_LayoutConfig.padding),
      child: AnimatedColumn(
        children: [
          const SizedBox(height: _LayoutConfig.skeletonHeaderHeight),
          _buildSkeletonCard(height: _LayoutConfig.skeletonCard1Height),
          const SizedBox(height: _LayoutConfig.spacing),
          _buildSkeletonCard(height: _LayoutConfig.skeletonCard2Height),
          const SizedBox(height: _LayoutConfig.spacing),
          _buildSkeletonCard(height: _LayoutConfig.skeletonCard3Height),
          const SizedBox(height: _LayoutConfig.largeSpacing),
          _buildSkeletonCard(height: _LayoutConfig.skeletonCard4Height),
          const SizedBox(height: _LayoutConfig.largeSpacing),
          _buildSkeletonCard(height: _LayoutConfig.skeletonCard5Height),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard({required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _ShimmerEffect(),
      ),
    );
  }
}

class _ShimmerEffect extends StatefulWidget {
  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.white.withOpacity(0.05),
                Colors.white.withOpacity(0.0),
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ],
            ),
          ),
        );
      },
    );
  }
}
