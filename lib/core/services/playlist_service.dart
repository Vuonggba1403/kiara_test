import 'package:kiara_app_test/core/models/song_model.dart';
import 'package:kiara_app_test/core/repositories/music_repository.dart';

/// Service quản lý playlist và các thao tác với bài hát
class PlaylistService {
  static final MusicRepository _repository = MusicRepository();

  static Future<List<SongModel>> loadPlaylist() async {
    return await _repository.loadPlaylist();
  }

  static Future<SongModel?> getSongById(String id) async {
    return await _repository.getSongById(id);
  }

  static Future<List<SongModel>> searchSongs(String query) async {
    return await _repository.searchSongs(query);
  }
}
