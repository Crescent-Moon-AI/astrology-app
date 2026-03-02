import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/character_avatar.dart';
import '../../../../shared/widgets/cosmic_button.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../../../shared/models/expression.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');

    // Mood tags for decoration
    final moodTags = isZh
        ? [
            l10n.moodTagHappy,
            l10n.moodTagCalm,
            l10n.moodTagCreative,
            l10n.moodTagEnergetic,
            l10n.moodTagRomantic,
            l10n.moodTagTired,
          ]
        : [
            l10n.moodTagHappy,
            l10n.moodTagCalm,
            l10n.moodTagCreative,
            l10n.moodTagEnergetic,
            l10n.moodTagRomantic,
            l10n.moodTagTired,
          ];

    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.diaryTitle,
                    style: const TextStyle(
                      color: CosmicColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CharacterAvatar(
                          expression: ExpressionId.caring,
                          size: CharacterAvatarSize.lg,
                        ),
                        const SizedBox(height: 24),
                        // Mood tag bubbles
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: moodTags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: CosmicColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: CosmicColors.borderGlow,
                                ),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: CosmicColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.diaryEmptyHint,
                          style: const TextStyle(
                            color: CosmicColors.textSecondary,
                            fontSize: 15,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: CosmicButton(
                            label: l10n.diaryAddNew,
                            onPressed: () => context.push('/mood/history'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
