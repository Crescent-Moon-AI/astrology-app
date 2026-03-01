import 'package:flutter/material.dart';

import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:astrology_app/shared/models/expression.dart';
import 'package:astrology_app/shared/theme/cosmic_colors.dart';
import 'package:astrology_app/shared/widgets/character_avatar.dart';
import 'package:astrology_app/shared/widgets/starfield_background.dart';

String _exprLabel(AppLocalizations l10n, ExpressionId expr) {
  switch (expr) {
    case ExpressionId.greeting:
      return l10n.exprGreeting;
    case ExpressionId.thinking:
      return l10n.exprThinking;
    case ExpressionId.happy:
      return l10n.exprHappy;
    case ExpressionId.caring:
      return l10n.exprCaring;
    case ExpressionId.mysterious:
      return l10n.exprMysterious;
    case ExpressionId.surprised:
      return l10n.exprSurprised;
    case ExpressionId.explaining:
      return l10n.exprExplaining;
    case ExpressionId.farewell:
      return l10n.exprFarewell;
  }
}

class AboutCharacterPage extends StatelessWidget {
  const AboutCharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isZh = Localizations.localeOf(context).languageCode == 'zh';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n?.characterAboutTitle ?? (isZh ? '关于星见' : 'About Xingjian'),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: CosmicColors.textPrimary,
          ),
        ),
        backgroundColor: CosmicColors.background.withValues(alpha: 0.9),
        elevation: 0,
      ),
      body: StarfieldBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CharacterAvatar(
                expression: ExpressionId.greeting,
                size: CharacterAvatarSize.lg,
              ),
              const SizedBox(height: 16),
              Text(
                isZh ? '\u661F\u89C1' : 'Xingjian',
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                isZh
                    ? '\u201C\u661F\u4E4B\u89C1\u8BC1\u8005\u201D'
                    : '"Star Seer"',
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: CosmicColors.surfaceElevated,
                  border: Border.all(color: CosmicColors.borderGlow),
                ),
                child: Text(
                  l10n?.characterAboutBackstory ??
                      (isZh
                          ? '星见是你的私人星象向导，将古老的占星智慧与现代洞察力相结合，帮助你在星辰下驾驭人生的旅程。'
                          : 'Xingjian is your personal guide through the cosmos, combining '
                              'ancient astrological wisdom with modern insight to help you '
                              'navigate life\'s journey under the stars.'),
                  style: const TextStyle(
                    color: CosmicColors.textSecondary,
                    fontSize: 15,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  const Icon(Icons.auto_awesome,
                      size: 18, color: CosmicColors.secondary),
                  const SizedBox(width: 8),
                  Text(
                    l10n?.characterExpressionGallery ??
                        (isZh ? '表情库' : 'Expressions'),
                    style: const TextStyle(
                      color: CosmicColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 2x4 grid of expressions
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: ExpressionId.values.map((expr) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CharacterAvatar(
                          expression: expr, size: CharacterAvatarSize.md),
                      const SizedBox(height: 4),
                      Text(
                        _exprLabel(l10n!, expr),
                        style: const TextStyle(
                          color: CosmicColors.textTertiary,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
