/// Model representing a music track
class SongModel {
  final String id;
  final String title;
  final String artist;
  final String albumArt;
  final Duration duration;
  final String audioUrl;

  const SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumArt,
    required this.duration,
    required this.audioUrl,
  });
}
