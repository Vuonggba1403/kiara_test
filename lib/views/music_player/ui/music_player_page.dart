import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiara_app_test/core/functions/app_background.dart';
import 'package:kiara_app_test/views/music_player/logic/cubit/global_music_player_cubit.dart';
import 'package:kiara_app_test/core/models/song_model.dart';
import 'package:kiara_app_test/views/music_player/ui/widgets/album_art.dart';
import 'package:kiara_app_test/views/music_player/ui/widgets/control_buttons.dart';
import 'package:kiara_app_test/views/music_player/ui/widgets/progress_bar.dart';
import 'package:kiara_app_test/views/music_player/ui/widgets/volume_slider.dart';
import 'package:kiara_app_test/views/music_player/ui/widgets/playlist_bottom_sheet.dart'
    show showPlaylistBottomSheet;

class _LayoutConfig {
  static const double horizontalPadding = 24;
  static const double spacing = 24;
  static const double largeSpacing = 32;
}

/// Trang phát nhạc chính
/// Hiển thị: album art, song info, progress bar, control buttons
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

    /// Lấy thông tin từ global state
    final currentSong = _getCurrentSong(globalState);
    final isPlaying = _isCurrentSongPlaying(globalState, currentSong);
    final currentPosition = _getCurrentPosition(globalState, currentSong);
    final totalDuration = _getTotalDuration(globalState, currentSong);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAppBar(context, globalCubit, currentSong),
        const SizedBox(height: _LayoutConfig.spacing),
        AlbumArt(imageUrl: currentSong.albumArt, isPlaying: isPlaying),
        const SizedBox(height: _LayoutConfig.spacing),
        _buildSongInfo(currentSong),
        const SizedBox(height: _LayoutConfig.spacing),
        _buildProgressBar(currentPosition, totalDuration, globalCubit),
        const SizedBox(height: _LayoutConfig.largeSpacing),
        _buildControlButtons(context, globalState, currentSong, isPlaying),
        const SizedBox(height: _LayoutConfig.spacing),
        _buildBottomControls(),
        const SizedBox(height: _LayoutConfig.largeSpacing),
      ],
    );
  }

  SongModel _getCurrentSong(GlobalMusicPlayerState state) {
    if (state is GlobalMusicPlayerPlaying) {
      return state.currentSong;
    } else if (state is GlobalMusicPlayerPaused) {
      return state.currentSong;
    }
    return song;
  }

  bool _isCurrentSongPlaying(
    GlobalMusicPlayerState state,
    SongModel currentSong,
  ) {
    return state is GlobalMusicPlayerPlaying &&
        state.currentSong.id == currentSong.id;
  }

  Duration _getCurrentPosition(
    GlobalMusicPlayerState state,
    SongModel currentSong,
  ) {
    if (state is GlobalMusicPlayerPlaying &&
        state.currentSong.id == currentSong.id) {
      return state.currentPosition;
    } else if (state is GlobalMusicPlayerPaused &&
        state.currentSong.id == currentSong.id) {
      return state.currentPosition;
    }
    return Duration.zero;
  }

  Duration _getTotalDuration(
    GlobalMusicPlayerState state,
    SongModel currentSong,
  ) {
    if (state is GlobalMusicPlayerPlaying &&
        state.currentSong.id == currentSong.id) {
      return state.currentSong.duration;
    } else if (state is GlobalMusicPlayerPaused &&
        state.currentSong.id == currentSong.id) {
      return state.currentSong.duration;
    }
    return currentSong.duration;
  }

  Widget _buildProgressBar(
    Duration currentPosition,
    Duration totalDuration,
    GlobalMusicPlayerCubit cubit,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _LayoutConfig.horizontalPadding,
      ),
      child: MusicProgressBar(
        currentPosition: currentPosition,
        totalDuration: totalDuration,
        onSeek: (position) => cubit.seekTo(position),
      ),
    );
  }

  Widget _buildControlButtons(
    BuildContext context,
    GlobalMusicPlayerState globalState,
    SongModel currentSong,
    bool isPlaying,
  ) {
    final globalCubit = context.read<GlobalMusicPlayerCubit>();

    return MusicControlButtons(
      isPlaying: isPlaying,
      onPlayPause: () =>
          _handlePlayPause(globalState, currentSong, globalCubit),
      onPrevious: () {},
      onNext: () {},
    );
  }

  void _handlePlayPause(
    GlobalMusicPlayerState state,
    SongModel currentSong,
    GlobalMusicPlayerCubit cubit,
  ) {
    if ((state is GlobalMusicPlayerPlaying ||
            state is GlobalMusicPlayerPaused) &&
        _isSameSong(state, currentSong)) {
      cubit.togglePlayPause();
    } else {
      cubit.playSong(currentSong);
    }
  }

  bool _isSameSong(GlobalMusicPlayerState state, SongModel song) {
    if (state is GlobalMusicPlayerPlaying) {
      return state.currentSong.id == song.id;
    } else if (state is GlobalMusicPlayerPaused) {
      return state.currentSong.id == song.id;
    }
    return false;
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
