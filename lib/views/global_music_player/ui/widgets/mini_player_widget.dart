import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/global_music_player_cubit.dart';

/// Mini music player that appears at the bottom of screens
class MiniPlayerWidget extends StatelessWidget {
  const MiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalMusicPlayerCubit, GlobalMusicPlayerState>(
      builder: (context, state) {
        if (state is GlobalMusicPlayerInitial) {
          return const SizedBox.shrink();
        }

        final song = _extractSong(state);
        final currentPosition = _extractPosition(state);
        final isPlaying = state is GlobalMusicPlayerPlaying;

        return Container(
          height: 70,
          decoration: _buildDecoration(context),
          child: Row(
            children: [
              _buildAlbumArt(song.albumArt),
              const SizedBox(width: 12),
              _buildSongInfo(song),
              _buildPlayPauseButton(context, isPlaying),
              _buildCloseButton(context),
              const SizedBox(width: 8),
            ],
          ),
        );
      },
    );
  }

  /// Extract song from state
  dynamic _extractSong(GlobalMusicPlayerState state) {
    if (state is GlobalMusicPlayerPlaying) {
      return state.currentSong;
    } else if (state is GlobalMusicPlayerPaused) {
      return state.currentSong;
    }
    throw Exception('Invalid state');
  }

  /// Extract position from state
  Duration _extractPosition(GlobalMusicPlayerState state) {
    if (state is GlobalMusicPlayerPlaying) {
      return state.currentPosition;
    } else if (state is GlobalMusicPlayerPaused) {
      return state.currentPosition;
    }
    return Duration.zero;
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, -2),
        ),
      ],
    );
  }

  Widget _buildAlbumArt(String albumArt) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(albumArt), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildSongInfo(dynamic song) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            song.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            song.artist,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayPauseButton(BuildContext context, bool isPlaying) {
    return IconButton(
      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 32),
      onPressed: () {
        context.read<GlobalMusicPlayerCubit>().togglePlayPause();
      },
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        context.read<GlobalMusicPlayerCubit>().stop();
      },
    );
  }
}
