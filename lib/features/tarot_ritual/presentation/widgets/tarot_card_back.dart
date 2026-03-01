import 'dart:math';

import 'package:flutter/material.dart';

class TarotCardBack extends StatelessWidget {
  final double width;
  final double height;

  const TarotCardBack({super.key, this.width = 120, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4A3080), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3080).withAlpha(51), // 20%
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CustomPaint(
          painter: _MoonPhasesPainter(),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _MoonPhasesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Deep purple gradient background
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1A0A3E), Color(0xFF2D1B69), Color(0xFF1A0A3E)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(bgRect);
    canvas.drawRect(bgRect, bgPaint);

    final cx = size.width / 2;
    final cy = size.height / 2;

    // 2. Elliptical orbit lines
    final orbitPaint = Paint()
      ..color = const Color(0xFF6B4FA0)
          .withAlpha(26) // 10%
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (int i = 0; i < 3; i++) {
      final rx = size.width * (0.28 + i * 0.08);
      final ry = size.height * (0.38 + i * 0.04);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy), width: rx * 2, height: ry * 2),
        orbitPaint,
      );
    }

    // 3. Seven moon phases (top to bottom)
    // New→Waxing Crescent→First Quarter→Full→Last Quarter→Waning Crescent→New
    final moonRadius = size.width * 0.085;
    final fullMoonRadius = size.width * 0.12;
    final spacing = size.height * 0.105;
    final startY = cy - spacing * 3;

    final phases = [
      _MoonPhase.newMoon,
      _MoonPhase.waxingCrescent,
      _MoonPhase.firstQuarter,
      _MoonPhase.fullMoon,
      _MoonPhase.lastQuarter,
      _MoonPhase.waningCrescent,
      _MoonPhase.newMoon,
    ];

    for (int i = 0; i < phases.length; i++) {
      final y = startY + i * spacing;
      final r = (i == 3) ? fullMoonRadius : moonRadius;
      _drawMoonPhase(canvas, Offset(cx, y), r, phases[i]);
    }

    // 4. Scattered star dots
    final starPaint = Paint()
      ..color = Colors.white
          .withAlpha(77) // 30%
      ..style = PaintingStyle.fill;

    final rng = Random(42);
    for (int i = 0; i < 8; i++) {
      final sx = rng.nextDouble() * size.width;
      final sy = rng.nextDouble() * size.height;
      final sr = 0.5 + rng.nextDouble() * 1.0;
      canvas.drawCircle(Offset(sx, sy), sr, starPaint);
    }

    // 5. Inner border frame
    final framePaint = Paint()
      ..color = const Color(0xFF4A3080)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(6, 6, size.width - 12, size.height - 12),
        const Radius.circular(8),
      ),
      framePaint,
    );
  }

  void _drawMoonPhase(
    Canvas canvas,
    Offset center,
    double radius,
    _MoonPhase phase,
  ) {
    final lightPaint = Paint()
      ..color = const Color(0xFFE8E0F0)
      ..style = PaintingStyle.fill;

    final darkPaint = Paint()
      ..color = const Color(0xFF1A0A3E)
      ..style = PaintingStyle.fill;

    switch (phase) {
      case _MoonPhase.newMoon:
        // Dark circle with subtle rim
        canvas.drawCircle(center, radius, darkPaint);
        final rimPaint = Paint()
          ..color = const Color(0xFF3D2570)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8;
        canvas.drawCircle(center, radius, rimPaint);
        break;

      case _MoonPhase.fullMoon:
        canvas.drawCircle(center, radius, lightPaint);
        break;

      case _MoonPhase.firstQuarter:
        // Left half dark, right half light
        canvas.drawCircle(center, radius, lightPaint);
        final path = Path()
          ..addArc(Rect.fromCircle(center: center, radius: radius), pi / 2, pi)
          ..close();
        canvas.drawPath(path, darkPaint);
        break;

      case _MoonPhase.lastQuarter:
        // Right half dark, left half light
        canvas.drawCircle(center, radius, lightPaint);
        final path = Path()
          ..addArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, pi)
          ..close();
        canvas.drawPath(path, darkPaint);
        break;

      case _MoonPhase.waxingCrescent:
        canvas.drawCircle(center, radius, darkPaint);
        // Light crescent on right
        _drawCrescent(canvas, center, radius, lightPaint, isWaxing: true);
        break;

      case _MoonPhase.waningCrescent:
        canvas.drawCircle(center, radius, darkPaint);
        // Light crescent on left
        _drawCrescent(canvas, center, radius, lightPaint, isWaxing: false);
        break;
    }
  }

  void _drawCrescent(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint, {
    required bool isWaxing,
  }) {
    canvas.save();
    // Clip to circle
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );

    // Draw a circle offset to create crescent shape
    final offset = isWaxing ? radius * 0.6 : -radius * 0.6;
    final crescentCenter = Offset(center.dx + offset, center.dy);
    canvas.drawCircle(crescentCenter, radius, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum _MoonPhase {
  newMoon,
  waxingCrescent,
  firstQuarter,
  fullMoon,
  lastQuarter,
  waningCrescent,
}
