import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';

class SectionRevealButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SectionRevealButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.expand_more,
          size: 18, color: CosmicColors.primaryLight),
      label: Text(
        l10n?.progressiveContinueReading ?? 'Continue Reading',
        style: const TextStyle(color: CosmicColors.primaryLight),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: CosmicColors.primary.withValues(alpha: 0.3),
          ),
        ),
        backgroundColor: CosmicColors.primary.withValues(alpha: 0.1),
      ),
    );
  }
}
