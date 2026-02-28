import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/cosmic_colors.dart';
import '../theme/theme_provider.dart';

/// A layered animated starfield background.
///
/// Three layers of stars drift slowly at different speeds. When reduced-motion
/// is enabled the stars are painted once without animation.
class StarfieldBackground extends ConsumerStatefulWidget {
  final Widget child;

  const StarfieldBackground({super.key, required this.child});

  @override
  ConsumerState<StarfieldBackground> createState() =>
      _StarfieldBackgroundState();
}

class _StarfieldBackgroundState extends ConsumerState<StarfieldBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    final random = Random(42);
    _stars = List.generate(300, (i) {
      // Layer 0: small / slow, Layer 1: medium, Layer 2: large / fast
      final layer = i ~/ 100;
      return _Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        radius: (layer + 1) * 0.5 + random.nextDouble() * 0.5,
        speed: (layer + 1) * 0.02,
        opacity: 0.3 + random.nextDouble() * 0.5,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = ref.watch(reducedMotionProvider);

    if (reducedMotion) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }

    return Stack(
      children: [
        // Background color
        Positioned.fill(
          child: ColoredBox(color: CosmicColors.background),
        ),
        // Starfield layer
        Positioned.fill(
          child: RepaintBoundary(
            child: reducedMotion
                ? CustomPaint(
                    painter: _StarfieldPainter(
                      stars: _stars,
                      animationValue: 0,
                    ),
                  )
                : AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _StarfieldPainter(
                          stars: _stars,
                          animationValue: _controller.value,
                        ),
                      );
                    },
                  ),
          ),
        ),
        // Content
        widget.child,
      ],
    );
  }
}

class _Star {
  final double x;
  final double y;
  final double radius;
  final double speed;
  final double opacity;

  const _Star({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.opacity,
  });
}

class _StarfieldPainter extends CustomPainter {
  final List<_Star> stars;
  final double animationValue;

  _StarfieldPainter({required this.stars, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final star in stars) {
      final dx = (star.x + animationValue * star.speed) % 1.0;
      final dy = (star.y + animationValue * star.speed * 0.3) % 1.0;

      paint.color = Colors.white.withValues(alpha: star.opacity);
      canvas.drawCircle(
        Offset(dx * size.width, dy * size.height),
        star.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarfieldPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
