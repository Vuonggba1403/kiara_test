import 'package:flutter/material.dart';
import 'mini_player_widget.dart';

/// Wraps a screen with global mini player at the bottom
class GlobalPlayerWrapper extends StatelessWidget {
  final Widget child;

  const GlobalPlayerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child, bottomNavigationBar: const MiniPlayerWidget());
  }
}
