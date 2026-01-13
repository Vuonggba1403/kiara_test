import 'package:flutter/material.dart';
import 'package:kiara_app_test/views/insights_details/logic/cubit/insight_details_cubit.dart';

class RecommendedSection extends StatelessWidget {
  final List<RecommendedAlbum> recommendations;

  const RecommendedSection({super.key, required this.recommendations});

  @override
  Widget build(BuildContext context) {
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
            Icon(Icons.music_note, color: const Color(0xFF7CB342), size: 24),
          ],
        ),
        const SizedBox(height: 16),
        ...recommendations.map(
          (album) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildAlbumCard(album),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Close current page and navigate to Sounds tab
              Navigator.pop(context);
              // Small delay to ensure navigation completes
              Future.delayed(const Duration(milliseconds: 100), () {
                // Get MainTabCubit from context and change to Sounds tab (index 3)
                final mainTabContext = Navigator.of(context).context;
                if (mainTabContext.mounted) {
                  // Find and update the page controller in MainTabView
                  _navigateToSoundsTab(mainTabContext);
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7CB342),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Browse All Albums',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToSoundsTab(BuildContext context) {
    // This will be handled by passing callback from parent
  }

  Widget _buildAlbumCard(RecommendedAlbum album) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: album.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
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
                  color: Color(0xFF7CB342),
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
        ],
      ),
    );
  }
}
