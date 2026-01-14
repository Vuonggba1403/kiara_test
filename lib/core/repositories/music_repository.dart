import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:kiara_app_test/core/models/song_model.dart';

/// Repository quản lý dữ liệu playlist từ JSON
class MusicRepository {
  /// Load danh sách bài hát từ file JSON
  Future<List<SongModel>> loadPlaylist() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/playlist.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> playlistData = jsonData['playlist'];

      return playlistData.map((item) {
        return SongModel(
          id: item['id'],
          title: item['title'],
          artist: item['artist'],
          albumArt: item['image'],
          duration: _parseDuration(item['duration']),
          audioUrl: item['audioUrl'] ?? '',
        );
      }).toList();
    } catch (e) {
      return _getDefaultPlaylist();
    }
  }

  Duration _parseDuration(String durationStr) {
    final parts = durationStr.split(':');
    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;
      return Duration(minutes: minutes, seconds: seconds);
    }
    return const Duration(minutes: 15);
  }

  List<SongModel> _getDefaultPlaylist() {
    return [
      const SongModel(
        id: 'deep_ocean_calm',
        title: 'Deep Ocean Calm',
        artist: '432 Hz healing frequency',
        albumArt:
            'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=300&h=300&fit=crop',
        duration: Duration(minutes: 30),
        audioUrl: '',
      ),
      const SongModel(
        id: 'morning_focus',
        title: 'Morning Focus',
        artist: '40 Hz gamma waves',
        albumArt:
            'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?w=300&h=300&fit=crop',
        duration: Duration(minutes: 20),
        audioUrl: '',
      ),
      const SongModel(
        id: 'night_serenity',
        title: 'Night Serenity',
        artist: '528 Hz + Delta waves',
        albumArt:
            'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=300&h=300&fit=crop',
        duration: Duration(minutes: 45),
        audioUrl: '',
      ),
      const SongModel(
        id: 'chakra_balance',
        title: 'Chakra Balance',
        artist: '7 chakra frequencies',
        albumArt:
            'https://images.unsplash.com/photo-1545389336-cf090694435e?w=300&h=300&fit=crop',
        duration: Duration(minutes: 25),
        audioUrl: '',
      ),
      const SongModel(
        id: 'forest_meditation',
        title: 'Forest Meditation',
        artist: '417 Hz transformation',
        albumArt:
            'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=300&h=300&fit=crop',
        duration: Duration(minutes: 35),
        audioUrl: '',
      ),
    ];
  }

  Future<SongModel?> getSongById(String id) async {
    final playlist = await loadPlaylist();
    try {
      return playlist.firstWhere((song) => song.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<SongModel>> searchSongs(String query) async {
    final playlist = await loadPlaylist();
    final lowercaseQuery = query.toLowerCase();

    return playlist.where((song) {
      return song.title.toLowerCase().contains(lowercaseQuery) ||
          song.artist.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
