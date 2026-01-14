import 'package:flutter/material.dart';
import 'package:kiara_app_test/core/functions/color_extension.dart';

/// Displays the playback progress bar with time indicators
class MusicProgressBar extends StatelessWidget {
  final Duration currentPosition;
  final Duration totalDuration;
  final ValueChanged<Duration> onSeek;

  const MusicProgressBar({
    super.key,
    required this.currentPosition,
    required this.totalDuration,
    required this.onSeek,
  });

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double _calculateSliderValue() {
    if (totalDuration.inSeconds == 0) return 0.0;
    return currentPosition.inSeconds.toDouble().clamp(
      0.0,
      totalDuration.inSeconds.toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Time labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(currentPosition),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
              Text(
                _formatDuration(totalDuration),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Progress slider
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            activeTrackColor: AppColors.lightGreen,
            inactiveTrackColor: Colors.white.withOpacity(0.2),
            overlayColor: AppColors.lightGreen.withOpacity(0.3),
          ),
          child: Slider(
            value: _calculateSliderValue(),
            max: totalDuration.inSeconds.toDouble(),
            onChanged: (value) {
              onSeek(Duration(seconds: value.toInt()));
            },
          ),
        ),
      ],
    );
  }
}
