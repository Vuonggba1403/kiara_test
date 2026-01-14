import 'package:kiara_app_test/core/models/song_model.dart';
import 'package:kiara_app_test/core/repositories/music_repository.dart';

/// Service layer for playlist operations
/// This provides a convenient interface to MusicRepository
class PlaylistService {
  static final MusicRepository _repository = MusicRepository();

  /// Loads playlist from repository
  static Future<List<SongModel>> loadPlaylist() async {
    return await _repository.loadPlaylist();
  }

  /// Gets song by ID
  static Future<SongModel?> getSongById(String id) async {
    return await _repository.getSongById(id);
  }

  /// Searches songs
  static Future<List<SongModel>> searchSongs(String query) async {
    return await _repository.searchSongs(query);
  }
}
