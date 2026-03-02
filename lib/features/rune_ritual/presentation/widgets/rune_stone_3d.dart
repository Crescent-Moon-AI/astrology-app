import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/rune_card.dart';
import 'rune_stone.dart';

class RuneStone3D extends StatefulWidget {
  final RuneDefinition? rune;
  final bool showFace;
  final double size;
  final VoidCallback? onFlipComplete;

  const RuneStone3D({
    super.key,
    this.rune,
    this.showFace = false,
    this.size = 80,
    this.onFlipComplete,
  });

  @override
  State<RuneStone3D> createState() => _RuneStone3DState();
}

class _RuneStone3DState extends State<RuneStone3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = false;

  @override
  void initState() {
    super.initState();
    _showFront = widget.showFace;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
    _animation.addListener(() {
      if (_animation.value >= 0.5 && !_showFront && widget.showFace) {
        setState(() => _showFront = true);
      }
    });
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFlipComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(RuneStone3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showFace && !oldWidget.showFace) {
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * math.pi;
        final isBackVisible = angle < math.pi / 2;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: isBackVisible
              ? _buildBack()
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(math.pi),
                  child: widget.rune != null
                      ? RuneStone(rune: widget.rune!, size: widget.size)
                      : _buildBack(),
                ),
        );
      },
    );
  }

  Widget _buildBack() {
    return Container(
      width: widget.size,
      height: widget.size * 1.2,
      decoration: BoxDecoration(
        color: const Color(0xFF1A0A3E),
        borderRadius: BorderRadius.circular(widget.size * 0.15),
        border: Border.all(color: CosmicColors.borderGlow, width: 1.5),
      ),
      child: Center(
        child: Text(
          '?',
          style: TextStyle(
            color: CosmicColors.textTertiary,
            fontSize: widget.size * 0.35,
          ),
        ),
      ),
    );
  }
}
