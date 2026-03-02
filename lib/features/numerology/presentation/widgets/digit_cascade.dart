import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';

class DigitCascade extends StatefulWidget {
  final List<int> steps;

  const DigitCascade({super.key, required this.steps});

  @override
  State<DigitCascade> createState() => _DigitCascadeState();
}

class _DigitCascadeState extends State<DigitCascade>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _visibleSteps = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.steps.length * 500),
    );
    _controller.addListener(() {
      final newVisible = (_controller.value * widget.steps.length).ceil();
      if (newVisible != _visibleSteps) {
        setState(() => _visibleSteps = newVisible);
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < _visibleSteps && i < widget.steps.length; i++)
          AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '${widget.steps[i]}',
                style: TextStyle(
                  color: i == widget.steps.length - 1
                      ? CosmicColors.secondary
                      : CosmicColors.textSecondary,
                  fontSize: i == widget.steps.length - 1 ? 48 : 24,
                  fontWeight: i == widget.steps.length - 1
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
