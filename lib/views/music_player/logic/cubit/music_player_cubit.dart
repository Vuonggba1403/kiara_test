import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:kiara_app_test/core/models/song_model.dart';
import 'dart:async';

part 'music_player_state.dart';

class MusicPlayerCubit extends Cubit<MusicPlayerState> {
  MusicPlayerCubit() : super(MusicPlayerInitial());

  SongModel? currentSong;
  bool isPlaying = false;
  Timer? _progressTimer;

  /// Loads and plays a song
  void playSong(SongModel song) {
    currentSong = song;
    isPlaying = true;

    // Start progress simulation
    _startProgressTimer(Duration.zero, song.duration);
  }

  /// Toggles play/pause state
  void togglePlayPause(Duration currentPosition, Duration totalDuration) {
    isPlaying = !isPlaying;

    if (isPlaying) {
      _startProgressTimer(currentPosition, totalDuration);
    } else {
      _stopProgressTimer();
      emit(
        MusicPlayerPaused(
          currentPosition: currentPosition,
          totalDuration: totalDuration,
        ),
      );
    }
  }

  /// Starts the progress timer to simulate playback
  void _startProgressTimer(Duration startPosition, Duration totalDuration) {
    _stopProgressTimer();

    Duration currentPosition = startPosition;

    emit(
      MusicPlayerPlaying(
        currentPosition: currentPosition,
        totalDuration: totalDuration,
      ),
    );

    _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentPosition.inSeconds < totalDuration.inSeconds) {
        currentPosition = Duration(seconds: currentPosition.inSeconds + 1);
        emit(
          MusicPlayerPlaying(
            currentPosition: currentPosition,
            totalDuration: totalDuration,
          ),
        );
      } else {
        timer.cancel();
        isPlaying = false;
        emit(
          MusicPlayerPaused(
            currentPosition: totalDuration,
            totalDuration: totalDuration,
          ),
        );
      }
    });
  }

  /// Stops the progress timer
  void _stopProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = null;
  }

  /// Seeks to a specific position
  void seekTo(Duration position, Duration total) {
    if (isPlaying) {
      _startProgressTimer(position, total);
    } else {
      emit(MusicPlayerPaused(currentPosition: position, totalDuration: total));
    }
  }

  @override
  Future<void> close() {
    _stopProgressTimer();
    return super.close();
  }
}
