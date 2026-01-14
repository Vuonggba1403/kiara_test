import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiara_app_test/core/functions/app_background.dart';
import 'package:kiara_app_test/views/global_music_player/logic/cubit/global_music_player_cubit.dart';
import 'package:kiara_app_test/core/models/song_model.dart';
import 'package:kiara_app_test/views/music_player/ui/widgets/album_art.dart';
import 'package:kiara_app_test/views/music_player/ui/widgets/control_buttons.dart';
import 'package:kiara_app_test/views/music_player/ui/widgets/progress_bar.dart';
import 'package:kiara_app_test/views/music_player/ui/widgets/volume_slider.dart';
import 'package:kiara_app_test/views/music_player/ui/widgets/playlist_bottom_sheet.dart'
    show showPlaylistBottomSheet;

class MusicPlayerPage extends StatelessWidget {
  final SongModel song;

  const MusicPlayerPage({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalMusicPlayerCubit, GlobalMusicPlayerState>(
      builder: (context, globalState) {
        return Scaffold(
          body: AppBackground(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: _buildBody(context, globalState),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, GlobalMusicPlayerState globalState) {
    final globalCubit = context.read<GlobalMusicPlayerCubit>();

    // Get current song from global state, fallback to passed song
    SongModel currentSong = song;
    if (globalState is GlobalMusicPlayerPlaying) {
      currentSong = globalState.currentSong;
    } else if (globalState is GlobalMusicPlayerPaused) {
      currentSong = globalState.currentSong;
    }

    // Sync with global state
    final isPlaying =
        globalState is GlobalMusicPlayerPlaying &&
        globalState.currentSong.id == currentSong.id;

    final currentPosition =
        (globalState is GlobalMusicPlayerPlaying &&
            globalState.currentSong.id == currentSong.id)
        ? globalState.currentPosition
        : (globalState is GlobalMusicPlayerPaused &&
              globalState.currentSong.id == currentSong.id)
        ? globalState.currentPosition
        : Duration.zero;

    final totalDuration =
        (globalState is GlobalMusicPlayerPlaying &&
            globalState.currentSong.id == currentSong.id)
        ? globalState.currentSong.duration
        : (globalState is GlobalMusicPlayerPaused &&
              globalState.currentSong.id == currentSong.id)
        ? globalState.currentSong.duration
        : currentSong.duration;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App bar
        _buildAppBar(context, globalCubit, currentSong),
        const SizedBox(height: 24),

        // Album art with continuous ripple effect
        AlbumArt(imageUrl: currentSong.albumArt, isPlaying: isPlaying),

        const SizedBox(height: 24),

        // Song info
        _buildSongInfo(currentSong),

        const SizedBox(height: 24),

        // Progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: MusicProgressBar(
            currentPosition: currentPosition,
            totalDuration: totalDuration,
            onSeek: (position) {
              globalCubit.seekTo(position);
            },
          ),
        ),

        const SizedBox(height: 32),

        // Control buttons
        MusicControlButtons(
          isPlaying: isPlaying,
          onPlayPause: () {
            if (globalState is GlobalMusicPlayerPlaying &&
                globalState.currentSong.id == currentSong.id) {
              globalCubit.togglePlayPause();
            } else if (globalState is GlobalMusicPlayerPaused &&
                globalState.currentSong.id == currentSong.id) {
              globalCubit.togglePlayPause();
            } else {
              globalCubit.playSong(currentSong);
            }
          },
          onPrevious: () {},
          onNext: () {},
        ),

        const SizedBox(height: 24),

        // Bottom controls
        _buildBottomControls(),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    GlobalMusicPlayerCubit globalCubit,
    SongModel currentSong,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 28, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Now Playing',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.playlist_play,
              size: 28,
              color: Colors.white,
            ),
            onPressed: () {
              showPlaylistBottomSheet(
                context,
                currentSong: currentSong,
                onSongSelected: (selectedSong) {
                  globalCubit.playSong(selectedSong);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MusicPlayerPage(song: selectedSong),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSongInfo(SongModel currentSong) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          Text(
            currentSong.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            currentSong.artist,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.repeat,
              color: Colors.white.withOpacity(0.4),
              size: 24,
            ),
            onPressed: () {},
          ),
          const VolumeSlider(),
          IconButton(
            icon: Icon(
              Icons.shuffle,
              color: Colors.white.withOpacity(0.4),
              size: 24,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
