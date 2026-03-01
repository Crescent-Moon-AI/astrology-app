import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/scenario.dart';
import '../../l10n/scenario_strings.dart';
import 'scenario_icon_data.dart';

class ScenarioCard extends StatelessWidget {
  final Scenario scenario;
  final VoidCallback? onTap;

  const ScenarioCard({
    super.key,
    required this.scenario,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final title = resolveScenarioKey(scenario.title, locale);
    final description = resolveScenarioKey(scenario.description, locale);
    final visual = getScenarioVisual(scenario.slug);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: CosmicColors.borderGlow,
                width: 1,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  CosmicColors.surfaceElevated,
                  CosmicColors.surface,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon area with gradient background
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          visual.gradient[0].withValues(alpha: 0.35),
                          visual.gradient[1].withValues(alpha: 0.15),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Decorative large icon in background
                        Positioned(
                          right: -12,
                          top: -8,
                          child: Icon(
                            visual.icon,
                            size: 72,
                            color: visual.gradient[0].withValues(alpha: 0.12),
                          ),
                        ),
                        // Main emoji
                        Center(
                          child: Text(
                            visual.emoji,
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Text content
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: CosmicColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Text(
                            description,
                            style: const TextStyle(
                              color: CosmicColors.textSecondary,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
