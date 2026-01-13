import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E293B),
      body: const Center(
        child: Text(
          'Profile Page',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
