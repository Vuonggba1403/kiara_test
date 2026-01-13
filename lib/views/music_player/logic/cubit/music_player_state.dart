part of 'music_player_cubit.dart';

@immutable
sealed class MusicPlayerState {}

final class MusicPlayerInitial extends MusicPlayerState {}

final class MusicPlayerLoading extends MusicPlayerState {}

final class MusicPlayerPlaying extends MusicPlayerState {
  final Duration currentPosition;
  final Duration totalDuration;

  MusicPlayerPlaying({
    required this.currentPosition,
    required this.totalDuration,
  });
}

final class MusicPlayerPaused extends MusicPlayerState {
  final Duration currentPosition;
  final Duration totalDuration;

  MusicPlayerPaused({
    required this.currentPosition,
    required this.totalDuration,
  });
}
