import 'package:flutter/material.dart';

import '../../domain/models/hexagram.dart';
import 'hexagram_symbol.dart';

class TransformationMorph extends StatefulWidget {
  final Hexagram primary;
  final Hexagram transformed;

  const TransformationMorph({
    super.key,
    required this.primary,
    required this.transformed,
  });

  @override
  State<TransformationMorph> createState() => _TransformationMorphState();
}

class _TransformationMorphState extends State<TransformationMorph>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showTransformed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _showTransformed = true);
      }
    });
    // Auto-play morph after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: HexagramSymbol(hexagram: widget.primary),
      secondChild: HexagramSymbol(hexagram: widget.transformed),
      crossFadeState: _showTransformed
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 800),
    );
  }
}
