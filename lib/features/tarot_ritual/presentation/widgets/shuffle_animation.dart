import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'tarot_card_back.dart';

class ShuffleAnimation extends StatefulWidget {
  final VoidCallback? onComplete;

  const ShuffleAnimation({
    super.key,
    this.onComplete,
  });

  @override
  State<ShuffleAnimation> createState() => _ShuffleAnimationState();
}

class _ShuffleAnimationState extends State<ShuffleAnimation>
    with TickerProviderStateMixin {
  late AnimationController _breatheController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();

    _breatheController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 280,
      child: AnimatedBuilder(
        animation: Listenable.merge([_breatheController, _floatController]),
        builder: (context, child) {
          final breathe = 0.95 + (_breatheController.value * 0.05);
          final floatY = math.sin(_floatController.value * math.pi) * 8;

          return Transform.translate(
            offset: Offset(0, floatY),
            child: Transform.scale(
              scale: breathe,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Bottom card (offset left and down)
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..translateByDouble(-8.0, 8.0, 0.0, 1.0)
                      ..rotateZ(-0.05),
                    child: const TarotCardBack(
                      width: 110,
                      height: 185,
                    ),
                  ),
                  // Middle card (slight offset)
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..translateByDouble(0.0, 0.0, 0.0, 1.0)
                      ..rotateZ(0.02),
                    child: const TarotCardBack(
                      width: 110,
                      height: 185,
                    ),
                  ),
                  // Top card (offset right and up)
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..translateByDouble(8.0, -8.0, 0.0, 1.0)
                      ..rotateZ(0.05),
                    child: const TarotCardBack(
                      width: 110,
                      height: 185,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
