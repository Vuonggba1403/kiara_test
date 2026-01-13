import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiara_app_test/views/global_music_player/logic/cubit/global_music_player_cubit.dart';
import 'package:kiara_app_test/core/models/song_model.dart';
import 'package:kiara_app_test/views/music_player/ui/widgets/album_art.dart';
import 'package:kiara_app_test/views/music_player/ui/widgets/control_buttons.dart';
import 'package:kiara_app_test/views/music_player/ui/widgets/progress_bar.dart';
import 'package:kiara_app_test/views/music_player/ui/widgets/volume_slider.dart';
import 'package:kiara_app_test/views/music_player/ui/widgets/playlist_bottom_sheet.dart';

class MusicPlayerPage extends StatelessWidget {
  final SongModel song;

  const MusicPlayerPage({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalMusicPlayerCubit, GlobalMusicPlayerState>(
      builder: (context, globalState) {
        return Scaffold(
          backgroundColor: const Color(0xFF1A1F3A),
          body: SafeArea(child: _buildBody(context, globalState)),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, GlobalMusicPlayerState globalState) {
    final globalCubit = context.read<GlobalMusicPlayerCubit>();

    // Sync with global state
    final isPlaying =
        globalState is GlobalMusicPlayerPlaying &&
        globalState.currentSong.id == song.id;

    final currentPosition =
        (globalState is GlobalMusicPlayerPlaying &&
            globalState.currentSong.id == song.id)
        ? globalState.currentPosition
        : (globalState is GlobalMusicPlayerPaused &&
              globalState.currentSong.id == song.id)
        ? globalState.currentPosition
        : Duration.zero;

    final totalDuration =
        (globalState is GlobalMusicPlayerPlaying &&
            globalState.currentSong.id == song.id)
        ? globalState.currentSong.duration
        : (globalState is GlobalMusicPlayerPaused &&
              globalState.currentSong.id == song.id)
        ? globalState.currentSong.duration
        : song.duration;

    return Column(
      children: [
        // App bar
        _buildAppBar(context, globalCubit),
        const Spacer(flex: 2),

        // Album art with continuous ripple effect
        AlbumArt(imageUrl: song.albumArt, isPlaying: isPlaying),

        const Spacer(flex: 2),

        // Song info
        _buildSongInfo(),

        const Spacer(),

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
                globalState.currentSong.id == song.id) {
              globalCubit.togglePlayPause();
            } else if (globalState is GlobalMusicPlayerPaused &&
                globalState.currentSong.id == song.id) {
              globalCubit.togglePlayPause();
            } else {
              globalCubit.playSong(song);
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
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_down,
              size: 28,
              color: Colors.white,
            ),
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
              PlaylistBottomSheet.show(
                context,
                currentSong: song,
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

  Widget _buildSongInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          Text(
            song.title,
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
            song.artist,
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
