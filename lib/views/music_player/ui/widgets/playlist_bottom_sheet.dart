import 'package:flutter/material.dart';
import 'package:kiara_app_test/core/models/song_model.dart';
import 'package:kiara_app_test/core/functions/color_extension.dart';
import 'package:kiara_app_test/core/services/playlist_service.dart';
import 'package:kiara_app_test/core/functions/animated_list_view.dart';

/// Bottom sheet displaying playlist of songs
class PlaylistBottomSheet extends StatefulWidget {
  final SongModel? currentSong;
  final List<SongModel>? playlist;
  final Function(SongModel) onSongSelected;

  const PlaylistBottomSheet({
    super.key,
    this.currentSong,
    this.playlist,
    required this.onSongSelected,
  });

  @override
  State<PlaylistBottomSheet> createState() => _PlaylistBottomSheetState();
}

class _PlaylistBottomSheetState extends State<PlaylistBottomSheet>
    with TickerProviderStateMixin {
  late AnimationController _tiltController;
  late Animation<double> _tiltAnimation;
  late AnimationController _staggerController;
  late AnimationController _pulsingController;
  late Animation<double> _pulsingAnimation;
  SongModel? _selectedSong;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _tiltController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _tiltAnimation = Tween<double>(begin: 0.15, end: 0.0).animate(
      CurvedAnimation(parent: _tiltController, curve: Curves.easeOutCubic),
    );

    // Staggered animation controller - longer duration to cover all items
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Pulsing animation for play icon
    _pulsingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulsingAnimation = Tween<double>(begin: 0.9, end: 1.15).animate(
      CurvedAnimation(parent: _pulsingController, curve: Curves.easeInOut),
    );

    // Initialize selected song
    _selectedSong = widget.currentSong;

    // Start animations when bottom sheet opens
    _tiltController.forward();
    _staggerController.forward();
  }

  @override
  void dispose() {
    _tiltController.dispose();
    _staggerController.dispose();
    _pulsingController.dispose();
    // Không dispose _scrollController vì nó được quản lý bởi DraggableScrollableSheet
    super.dispose();
  }

  void _scrollToSelectedItem(List<SongModel> playlist) {
    if (_selectedSong == null || _scrollController == null) return;

    final selectedIndex = playlist.indexWhere(
      (song) => song.id == _selectedSong!.id,
    );
    if (selectedIndex == -1) return;

    // Đợi animation xong và bottom sheet mở hoàn toàn
    Future.delayed(const Duration(milliseconds: 400), () {
      if (_scrollController != null && _scrollController!.hasClients) {
        // Mỗi item có height khoảng 72px (padding + content)
        final itemHeight = 72.0;
        final targetOffset = selectedIndex * itemHeight;

        _scrollController!.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SongModel>>(
      future: widget.playlist != null
          ? Future.value(widget.playlist)
          : PlaylistService.loadPlaylist(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildLoadingSkeleton(context);
        }

        final playlist = snapshot.data!;

        // Auto-select first item if no currentSong is provided
        final currentSong =
            widget.currentSong ?? (playlist.isNotEmpty ? playlist[0] : null);

        // Use the selected song state
        if (_selectedSong == null && currentSong != null) {
          _selectedSong = currentSong;
        }

        return AnimatedBuilder(
          animation: _tiltAnimation,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.topCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_tiltAnimation.value),
              child: DraggableScrollableSheet(
                initialChildSize: 0.65,
                minChildSize: 0.4,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  // Gán ScrollController và scroll đến vị trí selected
                  _scrollController = scrollController;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToSelectedItem(playlist);
                  });

                  return Container(
                    decoration: const BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
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
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
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
                              final isSelected = _selectedSong?.id == song.id;

                              return _buildPlaylistItem(
                                context,
                                song,
                                isCurrentSong,
                                isSelected,
                                index,
                                playlist.length,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPlaylistItem(
    BuildContext context,
    SongModel song,
    bool isCurrentSong,
    bool isSelected,
    int index,
    int totalItems,
  ) {
    // Calculate delay for staggered animation (60ms delay per item)
    final delay = index * 0.05; // 60ms delay per item (0.05 of 1200ms)
    final animationDuration = 0.5; // 600ms animation duration (0.5 of 1200ms)

    return AnimatedBuilder(
      animation: _staggerController,
      builder: (context, child) {
        // Calculate animation progress for this specific item
        double animationValue = 0.0;

        if (_staggerController.value < delay) {
          // Haven't reached this item's start time yet
          animationValue = 0.0;
        } else if (_staggerController.value >= delay + animationDuration) {
          // Animation completed
          animationValue = 1.0;
        } else {
          // In the middle of animation - calculate progress
          final progress =
              (_staggerController.value - delay) / animationDuration;
          // Use easeOutQuint for smoother, more refined motion
          animationValue = _easeOutQuint(progress);
        }

        // Apply fade (opacity from 0 to 1)
        final opacity = animationValue;

        // Apply slide (translate from 12px below to 0)
        final translateY = (1.0 - animationValue) * 12;

        // Apply scale (from 0.96 to 1.0)
        final scale = 0.96 + (animationValue * 0.04);

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, translateY),
            child: Transform.scale(
              scale: scale,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedSong = song;
                  });

                  // Small delay before triggering the callback and closing
                  Future.delayed(const Duration(milliseconds: 150), () {
                    widget.onSongSelected(song);
                    Navigator.pop(context);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryGreen.withOpacity(0.15)
                        : const Color(0xFF2D3748),
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(
                            color: AppColors.primaryGreen.withOpacity(0.3),
                            width: 1,
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      // Play button with pulsing animation
                      AnimatedBuilder(
                        animation: _pulsingAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: isCurrentSong
                                ? _pulsingAnimation.value
                                : 1.0,
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryGreen
                                    : Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                isCurrentSong ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          );
                        },
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
                                color: isSelected
                                    ? AppColors.primaryGreen
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
                                color: isSelected
                                    ? AppColors.primaryGreen.withOpacity(0.7)
                                    : Colors.white.withOpacity(0.6),
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
                              color: isSelected
                                  ? AppColors.primaryGreen
                                  : Colors.white.withOpacity(0.6),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(height: 4),
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.primaryGreen,
                              size: 18,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Custom easeOutQuint curve for smoother, more refined motion
  double _easeOutQuint(double t) {
    return 1 - (1 - t) * (1 - t) * (1 - t) * (1 - t) * (1 - t);
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

/// Helper function to show playlist bottom sheet
void showPlaylistBottomSheet(
  BuildContext context, {
  SongModel? currentSong,
  List<SongModel>? playlist,
  required Function(SongModel) onSongSelected,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.6),
    isDismissible: true,
    enableDrag: true,
    builder: (context) => PlaylistBottomSheet(
      currentSong: currentSong,
      playlist: playlist,
      onSongSelected: onSongSelected,
    ),
  );
}

Widget _buildLoadingSkeleton(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      color: AppColors.cardDark,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    child: Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Loading items
        Expanded(
          child: AnimatedListBuilder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 6,
            itemBuilder: (context, index) => _buildSkeletonItem(),
          ),
        ),
      ],
    ),
  );
}

Widget _buildSkeletonItem() {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        // Album art skeleton
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 12),
        // Text skeleton
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 150,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Icon skeleton
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    ),
  );
}
