import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiara_app_test/core/functions/color_extension.dart';
import 'package:kiara_app_test/core/models/song_model.dart';
import 'package:kiara_app_test/core/models/wellbeing_models.dart';
import 'package:kiara_app_test/core/services/playlist_service.dart';
import 'package:kiara_app_test/views/music_player/logic/cubit/global_music_player_cubit.dart';

class RecommendedMusicSection extends StatelessWidget {
  final List<RecommendedAlbum> recommendations;
  final void Function(BuildContext, SongModel) onSongTap;

  const RecommendedMusicSection({
    super.key,
    required this.recommendations,
    required this.onSongTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        ...recommendations.map(
          (album) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _RecommendedAlbumCard(album: album, onTap: onSongTap),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recommended for You',
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Image.asset(
            'assets/image/sounds.png',
            width: 22,
            height: 22,
            color: AppColors.primaryGreen,
          ),
        ],
      ),
    );
  }
}

class _RecommendedAlbumCard extends StatelessWidget {
  final RecommendedAlbum album;
  final void Function(BuildContext, SongModel) onTap;

  const _RecommendedAlbumCard({required this.album, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalMusicPlayerCubit, GlobalMusicPlayerState>(
      builder: (context, state) {
        return InkWell(
          onTap: () async {
            // Load playlist and get first song
            final playlist = await PlaylistService.loadPlaylist();
            if (playlist.isNotEmpty) {
              final firstSong = playlist[0];
              onTap(context, firstSong);
            }
          },
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: _cardGradient(album.color),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: album.color.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.05),
                  blurRadius: 8,
                  spreadRadius: -2,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(child: _AlbumInfo(album: album)),
                _AlbumMeta(album: album),
              ],
            ),
          ),
        );
      },
    );
  }

  LinearGradient _cardGradient(Color baseColor) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [baseColor.withOpacity(0.95), baseColor.withOpacity(0.75)],
    );
  }
}

class _AlbumInfo extends StatelessWidget {
  final RecommendedAlbum album;

  const _AlbumInfo({required this.album});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          album.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          album.category,
          style: TextStyle(
            color: AppColors.textColor.withOpacity(0.6),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _AlbumMeta extends StatelessWidget {
  final RecommendedAlbum album;

  const _AlbumMeta({required this.album});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          album.duration,
          style: const TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          album.plays,
          style: TextStyle(
            color: AppColors.textColor.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
