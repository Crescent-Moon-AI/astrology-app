import 'package:flutter/material.dart';

import '../theme/cosmic_colors.dart';

/// A diagonal golden shimmer sweep that plays once over a card surface.
///
/// Wrap around a card widget after reveal to give a "shine" effect.
/// Respects reduced-motion by skipping the animation entirely when
/// [enabled] is false.
class CardShimmerOverlay extends StatefulWidget {
  final double width;
  final double height;
  final bool enabled;
  final VoidCallback? onComplete;

  const CardShimmerOverlay({
    super.key,
    required this.width,
    required this.height,
    this.enabled = true,
    this.onComplete,
  });

  @override
  State<CardShimmerOverlay> createState() => _CardShimmerOverlayState();
}

class _CardShimmerOverlayState extends State<CardShimmerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    if (widget.enabled) {
      _controller.forward();
    }
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(CardShimmerOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // Sweep from -1 to +2 so the gradient fully exits the card
        final sweep = -1.0 + _controller.value * 3.0;

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment(sweep - 0.3, -0.3),
                  end: Alignment(sweep + 0.3, 0.3),
                  colors: const [
                    CosmicColors.shimmerBase,
                    CosmicColors.tarotGoldLight,
                    CosmicColors.shimmerBase,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
              child: Container(color: Colors.white.withAlpha(40)),
            ),
          ),
        );
      },
    );
  }
}
