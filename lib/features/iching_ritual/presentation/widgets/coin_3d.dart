import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';

class Coin3D extends StatefulWidget {
  final bool? isYang; // null = rolling
  final double size;

  const Coin3D({super.key, this.isYang, this.size = 48});

  @override
  State<Coin3D> createState() => _Coin3DState();
}

class _Coin3DState extends State<Coin3D> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    if (widget.isYang == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(Coin3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isYang != null && oldWidget.isYang == null) {
      _controller.stop();
      _controller.reset();
    } else if (widget.isYang == null && oldWidget.isYang != null) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isYang == null) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.003)
              ..rotateX(_controller.value * math.pi * 2),
            child: _buildCoinFace(true),
          );
        },
      );
    }

    return _buildCoinFace(widget.isYang!);
  }

  Widget _buildCoinFace(bool isYang) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isYang
              ? [const Color(0xFFFDCB6E), const Color(0xFFD4A03C)]
              : [const Color(0xFF6C5CE7), const Color(0xFF4A3580)],
        ),
        border: Border.all(
          color: isYang
              ? CosmicColors.secondary.withAlpha(153)
              : CosmicColors.primaryLight.withAlpha(153),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isYang ? CosmicColors.secondary : CosmicColors.primary)
                .withAlpha(51),
            blurRadius: 8,
          ),
        ],
      ),
      child: Center(
        child: Text(
          isYang ? '\u4E7E' : '\u5764', // 乾 or 坤
          style: TextStyle(
            color: isYang ? const Color(0xFF4A3C00) : CosmicColors.textPrimary,
            fontSize: widget.size * 0.35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
