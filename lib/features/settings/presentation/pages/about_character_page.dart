import 'package:flutter/material.dart';

import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:astrology_app/shared/models/expression.dart';
import 'package:astrology_app/shared/widgets/character_avatar.dart';

class AboutCharacterPage extends StatelessWidget {
  const AboutCharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isZh = Localizations.localeOf(context).languageCode == 'zh';

    return Scaffold(
      appBar:
          AppBar(title: Text(l10n?.characterAboutTitle ?? 'About Xingjian')),
      body: SingleChildScrollView(
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
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              isZh ? '\u201C\u661F\u4E4B\u89C1\u8BC1\u8005\u201D' : '"Star Seer"',
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: theme.colorScheme.outline),
            ),
            const SizedBox(height: 24),
            Text(
              l10n?.characterAboutBackstory ??
                  'Xingjian is your personal guide through the cosmos, combining '
                      'ancient astrological wisdom with modern insight to help you '
                      'navigate life\'s journey under the stars.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Text(
              l10n?.characterExpressionGallery ?? 'Expressions',
              style: theme.textTheme.titleMedium,
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
                      expr.name,
                      style: theme.textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
