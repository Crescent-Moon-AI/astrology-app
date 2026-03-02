import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';

class MasterNumberGlow extends StatefulWidget {
  final int number;

  const MasterNumberGlow({super.key, required this.number});

  @override
  State<MasterNumberGlow> createState() => _MasterNumberGlowState();
}

class _MasterNumberGlowState extends State<MasterNumberGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(
      begin: 8,
      end: 24,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: CosmicColors.secondary.withAlpha(102),
                blurRadius: _glowAnimation.value,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Text(
            '${widget.number}',
            style: const TextStyle(
              color: CosmicColors.secondary,
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
