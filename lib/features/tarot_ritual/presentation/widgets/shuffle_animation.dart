import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tarot_card_back.dart';

/// Multi-phase tarot shuffle animation:
///   Phase 1 (0.00-0.25): Cards burst outward from center into a circle
///   Phase 2 (0.25-0.60): Cards orbit and riffle-shuffle (crossing paths)
///   Phase 3 (0.60-0.85): Cards converge back to a tidy stack
///   Phase 4 (0.85-1.00): Stack settles with a glow pulse
///   Idle:                 Gentle breathing float (loops forever)
class ShuffleAnimation extends StatefulWidget {
  final VoidCallback? onComplete;

  const ShuffleAnimation({super.key, this.onComplete});

  @override
  State<ShuffleAnimation> createState() => _ShuffleAnimationState();
}

class _ShuffleAnimationState extends State<ShuffleAnimation>
    with TickerProviderStateMixin {
  static const _cardCount = 7;
  static const _shuffleDuration = Duration(milliseconds: 3200);

  late AnimationController _shuffleController;
  late AnimationController _idleController;
  bool _shuffleDone = false;

  @override
  void initState() {
    super.initState();

    _shuffleController = AnimationController(
      duration: _shuffleDuration,
      vsync: this,
    );

    _idleController = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    );

    _shuffleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _shuffleDone = true);
        _idleController.repeat(reverse: true);
        HapticFeedback.mediumImpact();
        widget.onComplete?.call();
      }
    });

    // Small delay then start
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        HapticFeedback.lightImpact();
        _shuffleController.forward();
      }
    });
  }

  @override
  void dispose() {
    _shuffleController.dispose();
    _idleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.30;
    final cardHeight = cardWidth / 0.6;
    final containerSize = cardWidth * 2.2;

    return SizedBox(
      width: containerSize,
      height: containerSize,
      child: _shuffleDone
          ? _buildIdleStack(cardWidth, cardHeight, containerSize)
          : _buildShuffleAnimation(cardWidth, cardHeight, containerSize),
    );
  }

  // --- Shuffle animation (phases 1-4) ---

  Widget _buildShuffleAnimation(
    double cardW,
    double cardH,
    double containerSize,
  ) {
    return AnimatedBuilder(
      animation: _shuffleController,
      builder: (context, _) {
        final t = _shuffleController.value;
        return Stack(
          clipBehavior: Clip.none,
          children: List.generate(_cardCount, (i) {
            final cardState = _computeCardState(i, t, containerSize, cardW, cardH);
            return Positioned(
              left: cardState.x,
              top: cardState.y,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateZ(cardState.rotation)
                  ..scaleByDouble(cardState.scale, cardState.scale, 1.0, 1.0),
                child: Opacity(
                  opacity: cardState.opacity,
                  child: _CardWithGlow(
                    width: cardW,
                    height: cardH,
                    glowIntensity: cardState.glow,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  _CardAnimState _computeCardState(
    int index,
    double t,
    double containerSize,
    double cardW,
    double cardH,
  ) {
    final cx = (containerSize - cardW) / 2;
    final cy = (containerSize - cardH) / 2;
    final angle = (index / _cardCount) * 2 * math.pi - math.pi / 2;
    final orbitRadius = containerSize * 0.34;

    // Phase 1: Burst outward (0.00 - 0.25)
    if (t < 0.25) {
      final p = Curves.easeOutBack.transform((t / 0.25).clamp(0.0, 1.0));
      final fadeIn = Curves.easeOut.transform((t / 0.12).clamp(0.0, 1.0));
      return _CardAnimState(
        x: cx + math.cos(angle) * orbitRadius * p,
        y: cy + math.sin(angle) * orbitRadius * p,
        rotation: angle * 0.3 * p,
        scale: 0.5 + 0.5 * p,
        opacity: fadeIn,
        glow: 0.3 * p,
      );
    }

    // Phase 2: Orbit & riffle (0.25 - 0.60)
    if (t < 0.60) {
      final p = ((t - 0.25) / 0.35).clamp(0.0, 1.0);
      // Each card orbits at different speed
      final speed = 1.0 + (index % 3) * 0.4;
      final currentAngle = angle + p * math.pi * 2.0 * speed;
      // Radius pulses in/out during shuffle
      final radiusPulse = orbitRadius * (0.7 + 0.3 * math.sin(p * math.pi * 3));
      // Riffle: cards briefly dip to center and back
      final riffleDip = math.sin(p * math.pi * 2) * orbitRadius * 0.3;
      final r = radiusPulse + riffleDip * ((index % 2 == 0) ? 1 : -1);

      return _CardAnimState(
        x: cx + math.cos(currentAngle) * r.clamp(0.0, double.infinity),
        y: cy + math.sin(currentAngle) * r.clamp(0.0, double.infinity),
        rotation: currentAngle * 0.2,
        scale: 0.85 + 0.15 * math.sin(p * math.pi * 4 + index),
        opacity: 1.0,
        glow: 0.2 + 0.3 * math.sin(p * math.pi * 2).abs(),
      );
    }

    // Phase 3: Converge to stack (0.60 - 0.85)
    if (t < 0.85) {
      final p = Curves.easeInOutCubic.transform(
        ((t - 0.60) / 0.25).clamp(0.0, 1.0),
      );
      // Ending angle after orbit
      final speed = 1.0 + (index % 3) * 0.4;
      final endAngle = angle + math.pi * 2.0 * speed;
      final fromX = cx + math.cos(endAngle) * orbitRadius * 0.7;
      final fromY = cy + math.sin(endAngle) * orbitRadius * 0.7;

      // Stack offsets: slight fan arrangement
      final stackIndex = index - _cardCount ~/ 2;
      final toX = cx + stackIndex * 3.0;
      final toY = cy + stackIndex * 3.0;
      final toRotation = stackIndex * 0.03;

      return _CardAnimState(
        x: fromX + (toX - fromX) * p,
        y: fromY + (toY - fromY) * p,
        rotation: endAngle * 0.2 * (1 - p) + toRotation * p,
        scale: (0.85 + 0.15 * (1 - p)).clamp(0.85, 1.0) + 0.15 * p,
        opacity: 1.0,
        glow: 0.5 * (1 - p),
      );
    }

    // Phase 4: Settle with glow (0.85 - 1.00)
    final p = Curves.easeOutQuart.transform(
      ((t - 0.85) / 0.15).clamp(0.0, 1.0),
    );
    final stackIndex = index - _cardCount ~/ 2;
    final glowPulse = math.sin(p * math.pi) * 0.6;

    return _CardAnimState(
      x: cx + stackIndex * 3.0,
      y: cy + stackIndex * 3.0,
      rotation: stackIndex * 0.03,
      scale: 1.0 + glowPulse * 0.05,
      opacity: 1.0,
      glow: glowPulse,
    );
  }

  // --- Idle breathing stack ---

  Widget _buildIdleStack(double cardW, double cardH, double containerSize) {
    return AnimatedBuilder(
      animation: _idleController,
      builder: (context, _) {
        final breathe = 0.97 + _idleController.value * 0.03;
        final floatY = math.sin(_idleController.value * math.pi) * 6;

        return Transform.translate(
          offset: Offset(0, floatY),
          child: Transform.scale(
            scale: breathe,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow behind the stack
                Container(
                  width: cardW * 1.3,
                  height: cardH * 1.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7B5EBF).withAlpha(
                          (30 + _idleController.value * 20).round(),
                        ),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
                // Bottom card
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..translateByDouble(-8.0, 8.0, 0.0, 1.0)
                    ..rotateZ(-0.05),
                  child: TarotCardBack(width: cardW, height: cardH),
                ),
                // Middle card
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..translateByDouble(0.0, 0.0, 0.0, 1.0)
                    ..rotateZ(0.02),
                  child: TarotCardBack(width: cardW, height: cardH),
                ),
                // Top card
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..translateByDouble(8.0, -8.0, 0.0, 1.0)
                    ..rotateZ(0.05),
                  child: TarotCardBack(width: cardW, height: cardH),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- Internal helper types ---

class _CardAnimState {
  final double x, y, rotation, scale, opacity, glow;
  const _CardAnimState({
    required this.x,
    required this.y,
    required this.rotation,
    required this.scale,
    required this.opacity,
    required this.glow,
  });
}

class _CardWithGlow extends StatelessWidget {
  final double width, height, glowIntensity;

  const _CardWithGlow({
    required this.width,
    required this.height,
    required this.glowIntensity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: glowIntensity > 0.05
            ? [
                BoxShadow(
                  color: const Color(0xFF7B5EBF).withAlpha(
                    (glowIntensity * 120).round().clamp(0, 255),
                  ),
                  blurRadius: 16 + glowIntensity * 24,
                  spreadRadius: glowIntensity * 6,
                ),
              ]
            : null,
      ),
      child: TarotCardBack(width: width, height: height),
    );
  }
}
