import 'package:flutter/material.dart';

class SoundsPage extends StatelessWidget {
  const SoundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E293B),
      body: const Center(
        child: Text(
          'Sounds Page',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
