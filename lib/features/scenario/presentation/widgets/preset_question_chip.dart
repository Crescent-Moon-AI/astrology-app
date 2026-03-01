import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';

class PresetQuestionChip extends StatelessWidget {
  final String question;
  final VoidCallback? onTap;

  const PresetQuestionChip({
    super.key,
    required this.question,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: CosmicColors.surfaceElevated,
          border: Border.all(
            color: CosmicColors.borderGlow,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 14,
              color: CosmicColors.primaryLight,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                question,
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
