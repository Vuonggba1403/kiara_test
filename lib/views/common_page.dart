import 'package:flutter/material.dart';
import 'package:kiara_app_test/core/functions/app_background.dart';

/// Trang placeholder cho các tab chưa được implement
/// Hiển thị text "CommonPage" ở giữa màn hình
class CommonPage extends StatelessWidget {
  const CommonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: const Center(
          child: Text(
            'CommonPage',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
