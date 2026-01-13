import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiara_app_test/views/insights_details/logic/cubit/insight_details_cubit.dart';
import 'package:kiara_app_test/views/insights_details/ui/widgets/monthly_progress_chart.dart';
import 'package:kiara_app_test/views/insights_details/ui/widgets/overall_wellbeing_card.dart';
import 'package:kiara_app_test/views/insights_details/ui/widgets/wellbeing_profile_chart.dart';
import 'package:kiara_app_test/views/insights_details/ui/widgets/personalized_insights_section.dart';
import 'package:kiara_app_test/views/music_player/ui/music_player_page.dart';
import 'package:kiara_app_test/core/models/song_model.dart';

class InsightDetailsPage extends StatelessWidget {
  const InsightDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InsightDetailsCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F172A),
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
          title: const Text(
            'Insights',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: BlocBuilder<InsightDetailsCubit, InsightDetailsState>(
            builder: (context, state) {
              if (state is InsightDetailsLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF7CB342)),
                );
              }

              if (state is InsightDetailsLoaded) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      OverallWellbeingCard(
                        overallWellbeing: state.overallWellbeing,
                        growth: state.growth,
                        checkIns: state.checkIns,
                        insightText: state.insightText,
                      ),
                      const SizedBox(height: 24),
                      MonthlyProgressChart(data: state.monthlyProgress),
                      const SizedBox(height: 24),
                      WellbeingProfileChart(profile: state.wellbeingProfile),
                      const SizedBox(height: 32),
                      _buildRecommendedSection(context, state.recommendations),
                      const SizedBox(height: 32),
                      PersonalizedInsightsSection(
                        insights: state.personalizedInsights,
                      ),
                      const SizedBox(height: 12),
                      _buildBrowseAllButton(context),
                      const SizedBox(height: 100),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  /// Opens music player with selected song
  void _openMusicPlayer(BuildContext context, RecommendedAlbum album) {
    final song = SongModel(
      id: album.title.replaceAll(' ', '_').toLowerCase(),
      title: album.title,
      artist: album.category,
      albumArt: 'https://picsum.photos/300/300?random=${album.title.hashCode}',
      duration: _parseDuration(album.duration),
      audioUrl: '',
    );

    // Don't start playing, just navigate to player
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MusicPlayerPage(song: song)),
    );
  }

  /// Parse duration string like "15 min" to Duration
  Duration _parseDuration(String durationStr) {
    final minutes =
        int.tryParse(durationStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 15;
    return Duration(minutes: minutes);
  }

  Widget _buildRecommendedSection(
    BuildContext context,
    List<RecommendedAlbum> recommendations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recommended for You',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.music_note, color: Color(0xFF7CB342), size: 24),
          ],
        ),
        const SizedBox(height: 16),
        ...recommendations.map(
          (album) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildAlbumCard(context, album),
          ),
        ),
      ],
    );
  }

  Widget _buildAlbumCard(BuildContext context, RecommendedAlbum album) {
    return InkWell(
      onTap: () => _openMusicPlayer(context, album),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: album.color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Album icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.music_note,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    album.category,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  album.duration,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  album.plays,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.play_circle_filled,
              color: Colors.white.withOpacity(0.9),
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowseAllButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // Simply pop and let user manually navigate to Sounds tab
          Navigator.pop(context);
        },
        icon: const Icon(Icons.library_music),
        label: const Text(
          'Browse All Albums',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7CB342),
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
}
