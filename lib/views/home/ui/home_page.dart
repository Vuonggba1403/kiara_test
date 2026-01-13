import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E293B),
      body: const Center(
        child: Text(
          'Home Page',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
