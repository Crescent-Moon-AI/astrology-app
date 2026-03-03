import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/theme/theme_provider.dart';
import '../../../../shared/widgets/card_shimmer_overlay.dart';
import '../../domain/models/tarot_card.dart';
import 'tarot_card_back.dart';
import 'tarot_card_face.dart';

class TarotCard3D extends ConsumerStatefulWidget {
  final TarotCard? card;
  final bool showFace;
  final double width;
  final double height;
  final VoidCallback? onFlipComplete;
  final Duration duration;
  final bool isSelected;

  const TarotCard3D({
    super.key,
    this.card,
    this.showFace = false,
    this.width = 120,
    this.height = 200,
    this.onFlipComplete,
    this.duration = const Duration(milliseconds: 800),
    this.isSelected = false,
  });

  @override
  ConsumerState<TarotCard3D> createState() => _TarotCard3DState();
}

class _TarotCard3DState extends ConsumerState<TarotCard3D>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late AnimationController _glowController;
  bool _showFront = false;
  bool _flipCompleted = false;

  @override
  void initState() {
    super.initState();
    _showFront = widget.showFace;
    _flipCompleted = widget.showFace;

    _flipController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutBack),
    );
    _flipAnimation.addListener(() {
      if (_flipAnimation.value >= 0.5 && !_showFront && widget.showFace) {
        setState(() => _showFront = true);
      }
    });
    _flipAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _flipCompleted = true);
        widget.onFlipComplete?.call();
      }
    });

    // Gold glow pulsing during flip
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    if (widget.showFace) {
      _showFront = true;
      _flipCompleted = true;
      // Set controller to end state so the face is visible immediately
      // (angle = pi, isBackVisible = false, face counter-rotation cancels out)
      _flipController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(TarotCard3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showFace && !oldWidget.showFace) {
      _flipCompleted = false;
      _flipController.forward(from: 0);
      _glowController.forward(from: 0);
      // Haptic feedback at flip start
      final reducedMotion = ref.read(reducedMotionProvider);
      if (!reducedMotion) {
        HapticFeedback.lightImpact();
      }
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = ref.watch(reducedMotionProvider);

    // Selected state: float up with enhanced shadow
    final verticalOffset = widget.isSelected ? -8.0 : 0.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, verticalOffset, 0),
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = _flipAnimation.value * math.pi;
          final isBackVisible = angle < math.pi / 2;
          final glowIntensity = reducedMotion
              ? 0.0
              : _glowController.value * (1.0 - _flipAnimation.value);

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                // Base shadow
                BoxShadow(
                  color: CosmicColors.primary.withAlpha(
                    widget.isSelected ? 80 : 30,
                  ),
                  blurRadius: widget.isSelected ? 16 : 8,
                  spreadRadius: widget.isSelected ? 2 : 0,
                ),
                // Gold reveal glow during flip
                if (glowIntensity > 0)
                  BoxShadow(
                    color: CosmicColors.revealGoldGlow.withAlpha(
                      (glowIntensity * 150).round(),
                    ),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
              ],
            ),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: Stack(
                children: [
                  if (isBackVisible)
                    TarotCardBack(width: widget.width, height: widget.height)
                  else
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(math.pi),
                      child: widget.card != null
                          ? TarotCardFace(
                              card: widget.card!,
                              width: widget.width,
                              height: widget.height,
                            )
                          : TarotCardBack(
                              width: widget.width,
                              height: widget.height,
                            ),
                    ),
                  // Shimmer sweep after flip completes
                  if (_flipCompleted && _showFront && !reducedMotion)
                    Positioned.fill(
                      child: CardShimmerOverlay(
                        width: widget.width,
                        height: widget.height,
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
