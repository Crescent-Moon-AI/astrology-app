import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/scenario.dart';
import '../../l10n/scenario_strings.dart';
import 'scenario_icon_data.dart';

class ScenarioCard extends StatelessWidget {
  final Scenario scenario;
  final VoidCallback? onTap;

  const ScenarioCard({super.key, required this.scenario, this.onTap});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final title = resolveScenarioKey(scenario.title, locale);
    final description = resolveScenarioKey(scenario.description, locale);
    final visual = getScenarioVisual(scenario.slug);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: CosmicColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // Icon area: 48x48 gradient square with emoji
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    visual.gradient[0].withAlpha(89), // 35%
                    visual.gradient[1].withAlpha(38), // 15%
                  ],
                ),
              ),
              child: Center(
                child: Text(visual.emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 12),
            // Title + description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: CosmicColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: CosmicColors.textSecondary,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Chevron
            const Icon(
              Icons.chevron_right,
              color: CosmicColors.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
