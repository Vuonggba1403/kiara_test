import 'package:flutter/material.dart';

class KiaraChatPage extends StatelessWidget {
  const KiaraChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E293B),
      body: const Center(
        child: Text(
          'Kiara Chat Page',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
