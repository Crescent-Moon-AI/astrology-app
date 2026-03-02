import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/dice_result.dart';

class DiceMeaningCard extends StatefulWidget {
  final DiceResult result;

  const DiceMeaningCard({super.key, required this.result});

  @override
  State<DiceMeaningCard> createState() => _DiceMeaningCardState();
}

class _DiceMeaningCardState extends State<DiceMeaningCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');
    final meaning = isZh ? widget.result.meaningZh : widget.result.meaning;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: CosmicColors.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CosmicColors.borderGlow),
        ),
        child: Text(
          meaning,
          style: const TextStyle(
            color: CosmicColors.textPrimary,
            fontSize: 16,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
