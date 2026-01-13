part of 'global_music_player_cubit.dart';

@immutable
sealed class GlobalMusicPlayerState {}

final class GlobalMusicPlayerInitial extends GlobalMusicPlayerState {}

final class GlobalMusicPlayerPlaying extends GlobalMusicPlayerState {
  final SongModel currentSong;
  final Duration currentPosition;

  GlobalMusicPlayerPlaying({
    required this.currentSong,
    required this.currentPosition,
  });
}

final class GlobalMusicPlayerPaused extends GlobalMusicPlayerState {
  final SongModel currentSong;
  final Duration currentPosition;

  GlobalMusicPlayerPaused({
    required this.currentSong,
    required this.currentPosition,
  });
}
