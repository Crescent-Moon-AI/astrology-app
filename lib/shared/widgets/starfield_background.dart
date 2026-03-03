import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/cosmic_colors.dart';
import '../theme/theme_provider.dart';

/// A layered animated starfield background with nebula, twinkling stars,
/// and occasional shooting stars.
///
/// Three visual layers:
/// 1. **Nebula** — static [DecoratedBox] with [CosmicColors.nebulaGradient],
///    zero animation overhead.
/// 2. **Stars** — 120 particles drifting at three speed tiers with per-star
///    sin-wave twinkle. Single [CustomPaint] inside a [RepaintBoundary].
/// 3. **Shooting stars** — separate [RepaintBoundary], one meteor at a time
///    every 4-8 s with a fading trail. [shouldRepaint] returns false when idle.
///
/// When [reducedMotionProvider] is true all controllers stop; stars are painted
/// once at their initial positions and no shooting stars appear.
class StarfieldBackground extends ConsumerStatefulWidget {
  final Widget child;

  const StarfieldBackground({super.key, required this.child});

  @override
  ConsumerState<StarfieldBackground> createState() =>
      _StarfieldBackgroundState();
}

class _StarfieldBackgroundState extends ConsumerState<StarfieldBackground>
    with TickerProviderStateMixin {
  // --- Star layer ---
  late final AnimationController _starController;
  late final List<_Star> _stars;

  // --- Shooting star layer ---
  late final AnimationController _meteorController;
  _ShootingStar? _activeMeteor;
  final Random _meteorRandom = Random();

  @override
  void initState() {
    super.initState();

    // Star drift + twinkle controller (60 s loop)
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    // Generate 120 stars across three layers with richer color variety
    final random = Random(42);
    _stars = List.generate(120, (i) {
      // Layer 0 (0..49): small / slow — distant stars
      // Layer 1 (50..89): medium — mid-field
      // Layer 2 (90..119): large / fast — nearby, with glow
      final layer = i < 50 ? 0 : (i < 90 ? 1 : 2);
      // Color distribution: 60% white, 15% amber, 15% pale blue, 10% violet
      final colorRoll = random.nextDouble();
      final starColor = colorRoll < 0.15
          ? _StarColor.amber
          : colorRoll < 0.30
          ? _StarColor.blue
          : colorRoll < 0.40
          ? _StarColor.violet
          : _StarColor.white;
      return _Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        radius: (layer + 1) * 0.5 + random.nextDouble() * 0.5,
        speed: (layer + 1) * 0.02,
        baseOpacity: 0.3 + random.nextDouble() * 0.5,
        twinklePhase: random.nextDouble() * 2.0 * pi,
        twinkleSpeed: 1.0 + random.nextDouble() * 2.0, // 1-3 cycles per 60s
        color: starColor,
        hasGlow: layer == 2, // only large stars get glow halos
      );
    });

    // Shooting star controller (single meteor, 1.2 s flight)
    _meteorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _meteorController.addStatusListener(_onMeteorStatus);

    // Schedule the first meteor
    _scheduleMeteor();
  }

  void _onMeteorStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _activeMeteor = null;
      });
      _scheduleMeteor();
    }
  }

  void _scheduleMeteor() {
    // Wait 4-8 seconds before firing the next meteor
    final delayMs = 4000 + _meteorRandom.nextInt(4001);
    Future.delayed(Duration(milliseconds: delayMs), () {
      if (!mounted) return;
      // Don't fire in reduced-motion mode
      final reducedMotion = ref.read(reducedMotionProvider);
      if (reducedMotion) {
        // Re-schedule; will check again later
        _scheduleMeteor();
        return;
      }
      _fireMeteor();
    });
  }

  void _fireMeteor() {
    // Randomize start in the upper-right quadrant
    final startX = 0.6 + _meteorRandom.nextDouble() * 0.4; // 0.6 - 1.0
    final startY = _meteorRandom.nextDouble() * 0.3; // 0.0 - 0.3

    // Diagonal trajectory toward bottom-left with slight randomization
    final angle = pi * 0.65 + (_meteorRandom.nextDouble() - 0.5) * 0.3;
    final length = 0.3 + _meteorRandom.nextDouble() * 0.2; // 0.3 - 0.5

    final endX = startX + cos(angle) * length;
    final endY = startY - sin(angle) * length; // sin is negative (going down)

    setState(() {
      _activeMeteor = _ShootingStar(
        startX: startX,
        startY: startY,
        endX: endX,
        endY: endY,
      );
    });

    _meteorController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _starController.dispose();
    _meteorController.removeStatusListener(_onMeteorStatus);
    _meteorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = ref.watch(reducedMotionProvider);

    if (reducedMotion) {
      _starController.stop();
      _meteorController.stop();
      _activeMeteor = null;
    } else {
      if (!_starController.isAnimating) {
        _starController.repeat();
      }
    }

    return Stack(
      children: [
        // Layer 0: Background color
        const Positioned.fill(
          child: ColoredBox(color: CosmicColors.background),
        ),

        // Layer 1a: Primary nebula — purple (upper-left)
        const Positioned.fill(
          child: Opacity(
            opacity: 0.45,
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: CosmicColors.nebulaGradient),
              child: SizedBox.expand(),
            ),
          ),
        ),

        // Layer 1b: Secondary nebula — blue (upper-right)
        const Positioned.fill(
          child: Opacity(
            opacity: 0.35,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: CosmicColors.nebulaBlueGradient,
              ),
              child: SizedBox.expand(),
            ),
          ),
        ),

        // Layer 1c: Tertiary nebula — teal accent (lower-left)
        const Positioned.fill(
          child: Opacity(
            opacity: 0.2,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: CosmicColors.nebulaTealGradient,
              ),
              child: SizedBox.expand(),
            ),
          ),
        ),

        // Layer 1d: Vignette — darkened edges for depth
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: CosmicColors.vignetteGradient),
            child: SizedBox.expand(),
          ),
        ),

        // Layer 2: Stars (drift + twinkle)
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
                    animation: _starController,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _StarfieldPainter(
                          stars: _stars,
                          animationValue: _starController.value,
                        ),
                      );
                    },
                  ),
          ),
        ),

        // Layer 3: Shooting stars (separate RepaintBoundary)
        if (!reducedMotion)
          Positioned.fill(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _meteorController,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _ShootingStarPainter(
                      meteor: _activeMeteor,
                      progress: _meteorController.value,
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

// ---------------------------------------------------------------------------
// Data models
// ---------------------------------------------------------------------------

enum _StarColor { white, amber, blue, violet }

class _Star {
  final double x;
  final double y;
  final double radius;
  final double speed;
  final double baseOpacity;
  final double twinklePhase;
  final double twinkleSpeed;
  final _StarColor color;
  final bool hasGlow; // large stars get a soft blur halo

  const _Star({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.baseOpacity,
    required this.twinklePhase,
    required this.twinkleSpeed,
    this.color = _StarColor.white,
    this.hasGlow = false,
  });
}

class _ShootingStar {
  final double startX;
  final double startY;
  final double endX;
  final double endY;

  const _ShootingStar({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
  });
}

// ---------------------------------------------------------------------------
// Painters
// ---------------------------------------------------------------------------

class _StarfieldPainter extends CustomPainter {
  final List<_Star> stars;
  final double animationValue;

  // Color constants
  static const _colorWhite = Colors.white;
  static const _colorAmber = Color(0xFFFFB347);
  static const _colorBlue = Color(0xFF9BB8ED);
  static const _colorViolet = Color(0xFFC4B5FF);

  _StarfieldPainter({required this.stars, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);

    for (final star in stars) {
      // Drift position (wrapping)
      final dx = (star.x + animationValue * star.speed) % 1.0;
      final dy = (star.y + animationValue * star.speed * 0.3) % 1.0;

      // Twinkle: sin wave oscillation on opacity
      final twinkle = sin(
        animationValue * 2.0 * pi * star.twinkleSpeed + star.twinklePhase,
      );
      // Map sin(-1..1) to a 0.5..1.0 multiplier so stars never fully vanish
      final opacityMultiplier = 0.75 + 0.25 * twinkle;
      final opacity = (star.baseOpacity * opacityMultiplier).clamp(0.0, 1.0);

      final baseColor = switch (star.color) {
        _StarColor.amber => _colorAmber,
        _StarColor.blue => _colorBlue,
        _StarColor.violet => _colorViolet,
        _StarColor.white => _colorWhite,
      };

      final center = Offset(dx * size.width, dy * size.height);

      // Draw soft glow halo for large stars (Layer 2)
      if (star.hasGlow) {
        glowPaint.color = baseColor.withValues(alpha: opacity * 0.25);
        canvas.drawCircle(center, star.radius * 3.0, glowPaint);
      }

      // Draw star core
      paint.color = baseColor.withValues(alpha: opacity);
      canvas.drawCircle(center, star.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_StarfieldPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class _ShootingStarPainter extends CustomPainter {
  final _ShootingStar? meteor;
  final double progress;

  _ShootingStarPainter({required this.meteor, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final m = meteor;
    if (m == null || progress <= 0.0) return;

    // Current head position (lerp along trajectory)
    final headX = m.startX + (m.endX - m.startX) * progress;
    final headY = m.startY + (m.endY - m.startY) * progress;

    // Trail start position (lags behind the head)
    final trailLength = 0.12; // fraction of the full trajectory
    final trailProgress = (progress - trailLength).clamp(0.0, 1.0);
    final tailX = m.startX + (m.endX - m.startX) * trailProgress;
    final tailY = m.startY + (m.endY - m.startY) * trailProgress;

    final headOffset = Offset(headX * size.width, headY * size.height);
    final tailOffset = Offset(tailX * size.width, tailY * size.height);

    // Fade in quickly, fade out toward end
    final fadeCurve = progress < 0.1
        ? progress / 0.1
        : progress > 0.7
        ? (1.0 - progress) / 0.3
        : 1.0;
    final alpha = fadeCurve.clamp(0.0, 1.0);

    // Draw the trail as a gradient line
    final trailPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.6 * alpha),
          Colors.white.withValues(alpha: 0.9 * alpha),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromPoints(tailOffset, headOffset))
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(tailOffset, headOffset, trailPaint);

    // Bright head glow
    final headPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9 * alpha)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(headOffset, 1.5, headPaint);

    // Soft outer glow around the head
    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3 * alpha)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(headOffset, 3.0, glowPaint);
  }

  @override
  bool shouldRepaint(_ShootingStarPainter oldDelegate) {
    // Zero cost when idle: no meteor means no repaint
    if (oldDelegate.meteor == null && meteor == null) return false;
    return oldDelegate.meteor != meteor || oldDelegate.progress != progress;
  }
}
