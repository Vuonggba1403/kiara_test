import 'package:flutter/material.dart';
import 'package:kiara_app_test/core/functions/color_extension.dart';

class InsightsAppBar extends StatelessWidget {
  final String title;
  final String actionIconPath;
  final VoidCallback onActionTap;

  const InsightsAppBar({
    super.key,
    required this.title,
    required this.actionIconPath,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                height: 36 / 30,
              ),
            ),
            IconButton(
              onPressed: onActionTap,
              icon: Image.asset(actionIconPath, width: 24, height: 24),
            ),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
