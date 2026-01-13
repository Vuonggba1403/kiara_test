import 'dart:ui';
import 'package:flutter/material.dart';

/// Circular album artwork with Gaussian blur background
/// and continuous ripple animation when playing
class AlbumArt extends StatefulWidget {
  final String imageUrl;
  final bool isPlaying;

  const AlbumArt({super.key, required this.imageUrl, this.isPlaying = false});

  @override
  State<AlbumArt> createState() => _AlbumArtState();
}

class _AlbumArtState extends State<AlbumArt>
    with SingleTickerProviderStateMixin {
  static const double _size = 300;

  late final AnimationController _rippleController;

  @override
  void initState() {
    super.initState();

    // Controller for continuous ripple animation
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    if (widget.isPlaying) {
      _rippleController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AlbumArt oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Sync animation with play / pause state
    if (widget.isPlaying != oldWidget.isPlaying) {
      widget.isPlaying ? _rippleController.repeat() : _rippleController.stop();
    }
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 35,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            // Album image
            Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return _fallbackBackground();
              },
            ),

            // Gaussian blur layer (only when playing)
            if (widget.isPlaying)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(color: Colors.black.withOpacity(0.15)),
              ),

            // Ripple animation (only when playing)
            if (widget.isPlaying)
              AnimatedBuilder(
                animation: _rippleController,
                builder: (_, __) {
                  return Stack(
                    alignment: Alignment.center,
                    children: List.generate(4, (index) {
                      final delay = index * 0.25;
                      final progress = (_rippleController.value + delay) % 1.0;

                      final scale = 0.35 + progress * 0.7;
                      final opacity = (1 - progress).clamp(0.0, 1.0);

                      return Container(
                        width: _size * scale,
                        height: _size * scale,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(opacity * 0.35),
                            width: 2,
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Fallback UI when image fails to load
  Widget _fallbackBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade800, Colors.grey.shade900],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.music_note,
          size: 100,
          color: Colors.white.withOpacity(0.25),
        ),
      ),
    );
  }
}
