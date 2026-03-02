import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';

class DimensionArc extends StatelessWidget {
  final String label;
  final int score;
  final Color color;
  final double size;

  const DimensionArc({
    super.key,
    required this.label,
    required this.score,
    this.color = CosmicColors.primaryLight,
    this.size = 72,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size + 20,
      child: Column(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _ArcPainter(progress: score / 100.0, color: color),
              child: Center(
                child: Text(
                  '$score',
                  style: TextStyle(
                    color: CosmicColors.textPrimary,
                    fontSize: size * 0.28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ArcPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const startAngle = 135 * math.pi / 180; // start from bottom-left
    const sweepTotal = 270 * math.pi / 180; // 270° arc

    // Background track
    final bgPaint = Paint()
      ..color = CosmicColors.surfaceHighlight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal,
      false,
      bgPaint,
    );

    // Progress arc
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
