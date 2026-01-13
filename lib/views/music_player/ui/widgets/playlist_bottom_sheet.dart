import 'package:flutter/material.dart';
import 'package:kiara_app_test/core/models/song_model.dart';

/// Bottom sheet displaying playlist of songs
class PlaylistBottomSheet extends StatelessWidget {
  final SongModel? currentSong;
  final Function(SongModel) onSongSelected;

  const PlaylistBottomSheet({
    super.key,
    this.currentSong,
    required this.onSongSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Sample playlist data
    final playlist = [
      SongModel(
        id: 'deep_ocean_calm',
        title: 'Deep Ocean Calm',
        artist: '432 Hz healing frequency',
        albumArt: 'https://picsum.photos/300/300?random=1',
        duration: const Duration(minutes: 30),
        audioUrl: '',
      ),
      SongModel(
        id: 'morning_focus',
        title: 'Morning Focus',
        artist: '40 Hz gamma waves',
        albumArt: 'https://picsum.photos/300/300?random=2',
        duration: const Duration(minutes: 20),
        audioUrl: '',
      ),
      SongModel(
        id: 'night_serenity',
        title: 'Night Serenity',
        artist: '528 Hz + Delta waves',
        albumArt: 'https://picsum.photos/300/300?random=3',
        duration: const Duration(minutes: 45),
        audioUrl: '',
      ),
      SongModel(
        id: 'chakra_balance',
        title: 'Chakra Balance',
        artist: '7 chakra frequencies',
        albumArt: 'https://picsum.photos/300/300?random=4',
        duration: const Duration(minutes: 25),
        audioUrl: '',
      ),
      SongModel(
        id: 'forest_meditation',
        title: 'Forest Meditation',
        artist: '417 Hz transformation',
        albumArt: 'https://picsum.photos/300/300?random=5',
        duration: const Duration(minutes: 35),
        audioUrl: '',
      ),
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1E293B),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Playlist',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              // Playlist items
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: playlist.length,
                  itemBuilder: (context, index) {
                    final song = playlist[index];
                    final isCurrentSong = currentSong?.id == song.id;

                    return _buildPlaylistItem(
                      context,
                      song,
                      isCurrentSong,
                      index,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaylistItem(
    BuildContext context,
    SongModel song,
    bool isCurrentSong,
    int index,
  ) {
    return InkWell(
      onTap: () {
        onSongSelected(song);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCurrentSong
              ? const Color(0xFF7CB342).withOpacity(0.2)
              : const Color(0xFF2D3748),
          borderRadius: BorderRadius.circular(12),
          border: isCurrentSong
              ? Border.all(color: const Color(0xFF7CB342), width: 1)
              : null,
        ),
        child: Row(
          children: [
            // Play button
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isCurrentSong
                    ? const Color(0xFF7CB342)
                    : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isCurrentSong ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Song info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: TextStyle(
                      color: isCurrentSong
                          ? const Color(0xFF7CB342)
                          : Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artist,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Duration & check mark
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatDuration(song.duration),
                  style: TextStyle(
                    color: isCurrentSong
                        ? const Color(0xFF7CB342)
                        : Colors.white.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isCurrentSong) ...[
                  const SizedBox(height: 4),
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF7CB342),
                    size: 16,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  static void show(
    BuildContext context, {
    SongModel? currentSong,
    required Function(SongModel) onSongSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PlaylistBottomSheet(
        currentSong: currentSong,
        onSongSelected: onSongSelected,
      ),
    );
  }
}
