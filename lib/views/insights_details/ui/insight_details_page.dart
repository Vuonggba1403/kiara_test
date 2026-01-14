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
import 'package:kiara_app_test/views/music_player/ui/widgets/playlist_bottom_sheet.dart'
    show showPlaylistBottomSheet;
import 'package:kiara_app_test/core/models/song_model.dart';
import 'package:kiara_app_test/core/functions/color_extension.dart';
import 'package:kiara_app_test/views/global_music_player/logic/cubit/global_music_player_cubit.dart';
import 'package:kiara_app_test/core/services/playlist_service.dart';

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
      padding: const EdgeInsets.all(20),
      child: AnimatedColumn(
        children: [
          InsightsAppBar(
            title: "Insights",
            actionIconPath: 'assets/image/close.png',
            onActionTap: () => Navigator.pop(context),
          ),
          OverallWellbeingCard(
            overallWellbeing: state.overallWellbeing,
            growth: state.growth,
            checkIns: state.checkIns,
            insightText: state.insightText,
          ),
          const SizedBox(height: 24),
          WellbeingProfileChart(profile: state.wellbeingProfile),
          const SizedBox(height: 24),
          MonthlyProgressChart(data: state.monthlyProgress),
          const SizedBox(height: 32),
          PersonalizedInsightsSection(insights: state.personalizedInsights),
          const SizedBox(height: 32),
          RecommendedMusicSection(
            recommendations: state.recommendations,
            onSongTap: _handleSongTap,
          ),
          const SizedBox(height: 12),
          _buildBrowseAllButton(context),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  /// Handles song tap and opens music player
  void _handleSongTap(BuildContext context, SongModel song) {
    // Play song when tapped
    context.read<GlobalMusicPlayerCubit>().playSong(song);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MusicPlayerPage(song: song)),
    );
  }

  Widget _buildBrowseAllButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _navigateToSoundsPage(context),
        label: const Text(
          'Browse All Albums',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  void _navigateToSoundsPage(BuildContext context) {
    // Pop back to main tab and navigate to Sounds page (index 3)
    Navigator.pop(context);
    // The main tab will handle the navigation to index 3
  }

  Widget _buildLoadingSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: AnimatedColumn(
        children: [
          const SizedBox(height: 60),
          _buildSkeletonCard(height: 180),
          const SizedBox(height: 24),
          _buildSkeletonCard(height: 200),
          const SizedBox(height: 24),
          _buildSkeletonCard(height: 150),
          const SizedBox(height: 32),
          _buildSkeletonCard(height: 200),
          const SizedBox(height: 32),
          _buildSkeletonCard(height: 250),
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
