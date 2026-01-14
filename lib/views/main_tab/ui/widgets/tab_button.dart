import 'package:flutter/material.dart';
import 'package:kiara_app_test/core/functions/color_extension.dart';

/// Widget hiển thị một tab button trong bottom navigation
/// Bao gồm icon và label, thay đổi màu sắc theo trạng thái active
class TabButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  // Constants cho styling
  static const double _iconSize = 26;
  static const double _spacing = 6;
  static const double _verticalPadding = 12;
  static const double _fontSize = 11;

  const TabButton({
    super.key,
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(),
            const SizedBox(height: _spacing),
            _buildLabel(),
          ],
        ),
      ),
    );
  }

  // Build icon với màu sắc thay đổi theo trạng thái
  Widget _buildIcon() {
    return ImageIcon(
      AssetImage(iconPath),
      size: _iconSize,
      color: isActive ? Colors.white : AppColors.mutedText,
    );
  }

  // Build label với style thay đổi theo trạng thái
  Widget _buildLabel() {
    return Text(
      label,
      style: TextStyle(
        fontSize: _fontSize,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
        color: isActive ? Colors.white : AppColors.mutedText,
      ),
    );
  }
}
