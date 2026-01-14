import 'dart:math';
import 'package:flutter/material.dart';

class MoodScalePainter extends CustomPainter {
  final int tickCount;
  final Color color;

  MoodScalePainter({required this.tickCount, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.width / 2 * 0.78;

    // Mood axis = trên cùng
    const angle = -pi / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    /// 1️⃣ LINE CHÍNH
    final end = Offset(
      center.dx + radius * cos(angle),
      center.dy + radius * sin(angle),
    );
    canvas.drawLine(center, end, paint);

    /// 2️⃣ GẠCH CHIA + SỐ
    for (int i = 1; i <= tickCount; i++) {
      final t = i / tickCount;
      final tickRadius = radius * t;

      final tickCenter = Offset(
        center.dx + tickRadius * cos(angle),
        center.dy + tickRadius * sin(angle),
      );

      // SỐ 25 / 50 / 75 / 100
      final value = (t * 100).round();
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$value',
          style: TextStyle(color: color.withOpacity(0.7), fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(tickCenter.dx + 6, tickCenter.dy - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
