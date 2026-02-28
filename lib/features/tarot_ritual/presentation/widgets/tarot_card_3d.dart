import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/models/tarot_card.dart';
import 'tarot_card_back.dart';
import 'tarot_card_face.dart';

class TarotCard3D extends StatefulWidget {
  final TarotCard? card;
  final bool showFace;
  final double width;
  final double height;
  final VoidCallback? onFlipComplete;
  final Duration duration;

  const TarotCard3D({
    super.key,
    this.card,
    this.showFace = false,
    this.width = 120,
    this.height = 200,
    this.onFlipComplete,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<TarotCard3D> createState() => _TarotCard3DState();
}

class _TarotCard3DState extends State<TarotCard3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = false;

  @override
  void initState() {
    super.initState();
    _showFront = widget.showFace;
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutBack,
      ),
    );
    _animation.addListener(() {
      // Switch sides at the halfway point
      if (_animation.value >= 0.5 && !_showFront && widget.showFace) {
        setState(() => _showFront = true);
      }
    });
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFlipComplete?.call();
      }
    });

    if (widget.showFace) {
      _showFront = true;
    }
  }

  @override
  void didUpdateWidget(TarotCard3D oldWidget) {
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
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateY(angle),
          child: isBackVisible
              ? TarotCardBack(
                  width: widget.width,
                  height: widget.height,
                )
              : Transform(
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
        );
      },
    );
  }
}
