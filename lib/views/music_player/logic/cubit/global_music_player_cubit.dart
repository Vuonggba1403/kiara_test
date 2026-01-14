import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:kiara_app_test/core/models/song_model.dart';
import 'dart:async';

part 'global_music_player_state.dart';

/// Cubit quản lý trạng thái music player toàn cục
class GlobalMusicPlayerCubit extends Cubit<GlobalMusicPlayerState> {
  GlobalMusicPlayerCubit() : super(GlobalMusicPlayerInitial());

  SongModel? _currentSong;
  Timer? _progressTimer;

  SongModel? get currentSong => _currentSong;

  void loadSong(SongModel song) {
    _currentSong = song;
    _stopProgressTimer();
    emit(
      GlobalMusicPlayerPaused(
        currentSong: song,
        currentPosition: Duration.zero,
      ),
    );
  }

  void playSong(SongModel song) {
    _currentSong = song;
    emit(
      GlobalMusicPlayerPlaying(
        currentSong: song,
        currentPosition: Duration.zero,
      ),
    );
    _startProgressTimer(Duration.zero, song.duration);
  }

  void togglePlayPause() {
    final currentState = state;
    if (currentState is GlobalMusicPlayerPlaying) {
      _stopProgressTimer();
      emit(
        GlobalMusicPlayerPaused(
          currentSong: currentState.currentSong,
          currentPosition: currentState.currentPosition,
        ),
      );
    } else if (currentState is GlobalMusicPlayerPaused) {
      emit(
        GlobalMusicPlayerPlaying(
          currentSong: currentState.currentSong,
          currentPosition: currentState.currentPosition,
        ),
      );
      _startProgressTimer(
        currentState.currentPosition,
        currentState.currentSong.duration,
      );
    }
  }

  void seekTo(Duration position) {
    final currentState = state;
    if (currentState is GlobalMusicPlayerPlaying) {
      _startProgressTimer(position, currentState.currentSong.duration);
    } else if (currentState is GlobalMusicPlayerPaused) {
      emit(
        GlobalMusicPlayerPaused(
          currentSong: currentState.currentSong,
          currentPosition: position,
        ),
      );
    }
  }

  void stop() {
    _stopProgressTimer();
    _currentSong = null;
    emit(GlobalMusicPlayerInitial());
  }

  void _startProgressTimer(Duration startPosition, Duration totalDuration) {
    _stopProgressTimer();

    Duration currentPosition = startPosition;

    _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSong == null) {
        timer.cancel();
        return;
      }

      if (currentPosition.inSeconds < totalDuration.inSeconds) {
        currentPosition = Duration(seconds: currentPosition.inSeconds + 1);
        emit(
          GlobalMusicPlayerPlaying(
            currentSong: _currentSong!,
            currentPosition: currentPosition,
          ),
        );
      } else {
        timer.cancel();
        emit(
          GlobalMusicPlayerPaused(
            currentSong: _currentSong!,
            currentPosition: totalDuration,
          ),
        );
      }
    });
  }

  void _stopProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = null;
  }

  @override
  Future<void> close() {
    _stopProgressTimer();
    return super.close();
  }
}
