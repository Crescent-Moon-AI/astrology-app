import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/character_avatar.dart';
import '../../../../shared/widgets/cosmic_button.dart';
import '../../../../shared/models/expression.dart';

class FreeConsultTab extends StatelessWidget {
  const FreeConsultTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const CharacterAvatar(
            expression: ExpressionId.greeting,
            size: CharacterAvatarSize.lg,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.consultPrompt,
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.consultSubtext,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: CosmicButton(
              label: l10n.consultStart,
              onPressed: () => context.push('/chat'),
            ),
          ),
        ],
      ),
    );
  }
}
