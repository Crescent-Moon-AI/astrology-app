import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

class SectionRevealButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SectionRevealButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.expand_more, size: 18),
      label: Text(l10n?.progressiveContinueReading ?? 'Continue Reading'),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
