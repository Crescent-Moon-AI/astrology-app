import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';

class Dice3D extends StatefulWidget {
  final int? value;
  final bool isRolling;
  final double size;

  const Dice3D({super.key, this.value, this.isRolling = false, this.size = 64});

  @override
  State<Dice3D> createState() => _Dice3DState();
}

class _Dice3DState extends State<Dice3D> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    if (widget.isRolling) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(Dice3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRolling && !oldWidget.isRolling) {
      _controller.repeat();
    } else if (!widget.isRolling && oldWidget.isRolling) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isRolling) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateX(_controller.value * math.pi * 2)
              ..rotateY(_controller.value * math.pi),
            child: _buildDiceFace(((_controller.value * 6).toInt() % 6) + 1),
          );
        },
      );
    }

    return _buildDiceFace(widget.value ?? 1);
  }

  Widget _buildDiceFace(int value) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1040),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CosmicColors.primaryLight.withAlpha(102),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: CosmicColors.primary.withAlpha(51),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: CustomPaint(painter: _DiceDotsPainter(value: value)),
    );
  }
}

class _DiceDotsPainter extends CustomPainter {
  final int value;

  _DiceDotsPainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CosmicColors.secondary
      ..style = PaintingStyle.fill;

    final dotRadius = size.width * 0.08;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final offset = size.width * 0.25;

    // Dot positions for each value
    final dots = switch (value) {
      1 => [Offset(cx, cy)],
      2 => [Offset(cx - offset, cy - offset), Offset(cx + offset, cy + offset)],
      3 => [
        Offset(cx - offset, cy - offset),
        Offset(cx, cy),
        Offset(cx + offset, cy + offset),
      ],
      4 => [
        Offset(cx - offset, cy - offset),
        Offset(cx + offset, cy - offset),
        Offset(cx - offset, cy + offset),
        Offset(cx + offset, cy + offset),
      ],
      5 => [
        Offset(cx - offset, cy - offset),
        Offset(cx + offset, cy - offset),
        Offset(cx, cy),
        Offset(cx - offset, cy + offset),
        Offset(cx + offset, cy + offset),
      ],
      6 => [
        Offset(cx - offset, cy - offset),
        Offset(cx + offset, cy - offset),
        Offset(cx - offset, cy),
        Offset(cx + offset, cy),
        Offset(cx - offset, cy + offset),
        Offset(cx + offset, cy + offset),
      ],
      _ => <Offset>[],
    };

    for (final dot in dots) {
      canvas.drawCircle(dot, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(_DiceDotsPainter oldDelegate) =>
      oldDelegate.value != value;
}
