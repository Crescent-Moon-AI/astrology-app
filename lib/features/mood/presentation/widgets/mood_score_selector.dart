import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';

class MoodScoreSelector extends StatelessWidget {
  final int? selectedScore;
  final ValueChanged<int> onScoreSelected;

  const MoodScoreSelector({
    super.key,
    this.selectedScore,
    required this.onScoreSelected,
  });

  static const _scoreEmojis = [
    '\u{1F622}', // 1: Terrible
    '\u{1F61E}', // 2: Bad
    '\u{1F610}', // 3: Okay
    '\u{1F60A}', // 4: Good
    '\u{1F604}', // 5: Great
  ];

  String _scoreLabel(AppLocalizations l10n, int score) {
    switch (score) {
      case 1:
        return l10n.moodScore1;
      case 2:
        return l10n.moodScore2;
      case 3:
        return l10n.moodScore3;
      case 4:
        return l10n.moodScore4;
      case 5:
        return l10n.moodScore5;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        final score = index + 1;
        final isSelected = selectedScore == score;

        return GestureDetector(
          onTap: () => onScoreSelected(score),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(isSelected ? 8 : 4),
            decoration: isSelected
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CosmicColors.primary,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: CosmicColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ],
                  )
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: isSelected ? 36 : 28,
                  ),
                  child: Text(_scoreEmojis[index]),
                ),
                const SizedBox(height: 4),
                Text(
                  _scoreLabel(l10n, score),
                  style: TextStyle(
                    color: isSelected
                        ? CosmicColors.primaryLight
                        : CosmicColors.textTertiary,
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
