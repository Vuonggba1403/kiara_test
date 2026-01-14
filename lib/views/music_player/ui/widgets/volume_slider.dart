import 'package:flutter/material.dart';
import 'package:kiara_app_test/core/functions/color_extension.dart';

/// Custom volume slider widget
class VolumeSlider extends StatefulWidget {
  const VolumeSlider({super.key});

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  double _volume = 0.6; // Default 60%

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.volume_up, color: Colors.white.withOpacity(0.4), size: 20),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              activeTrackColor: AppColors.lightGreen,
              inactiveTrackColor: Colors.white.withOpacity(0.2),
              thumbColor: AppColors.lightGreen,
              overlayColor: AppColors.lightGreen.withOpacity(0.3),
            ),
            child: Slider(
              value: _volume,
              min: 0.0,
              max: 1.0,
              onChanged: (value) {
                setState(() {
                  _volume = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
