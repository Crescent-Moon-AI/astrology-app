import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/scenario.dart';
import '../../l10n/scenario_strings.dart';
import '../providers/scenario_providers.dart';
import 'scenario_icon_data.dart';

class CategoryFilterChips extends ConsumerWidget {
  final List<ScenarioCategory> categories;
  final ValueChanged<String?> onSelected;

  const CategoryFilterChips({
    super.key,
    required this.categories,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final selectedSlug = ref.watch(selectedCategoryProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('\u2728 ', style: TextStyle(fontSize: 13)),
                Text(l10n.scenarioAllCategories),
              ],
            ),
            selected: selectedSlug == null,
            onSelected: (_) => onSelected(null),
            selectedColor: CosmicColors.primary.withValues(alpha: 0.25),
            backgroundColor: CosmicColors.surfaceElevated,
            side: BorderSide(
              color: selectedSlug == null
                  ? CosmicColors.primary.withValues(alpha: 0.6)
                  : CosmicColors.borderGlow,
            ),
            labelStyle: TextStyle(
              color: selectedSlug == null
                  ? CosmicColors.textPrimary
                  : CosmicColors.textSecondary,
              fontSize: 13,
            ),
            checkmarkColor: CosmicColors.primary,
            showCheckmark: false,
          ),
          const SizedBox(width: 8),
          ...categories.map((cat) {
            final visual = getCategoryVisual(cat.icon);
            final isSelected = selectedSlug == cat.slug;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${visual.emoji} ',
                        style: const TextStyle(fontSize: 13)),
                    Text(resolveScenarioKey(cat.name, locale)),
                  ],
                ),
                selected: isSelected,
                onSelected: (_) => onSelected(
                  isSelected ? null : cat.slug,
                ),
                selectedColor: visual.accentColor.withValues(alpha: 0.25),
                backgroundColor: CosmicColors.surfaceElevated,
                side: BorderSide(
                  color: isSelected
                      ? visual.accentColor.withValues(alpha: 0.6)
                      : CosmicColors.borderGlow,
                ),
                labelStyle: TextStyle(
                  color: isSelected
                      ? CosmicColors.textPrimary
                      : CosmicColors.textSecondary,
                  fontSize: 13,
                ),
                showCheckmark: false,
              ),
            );
          }),
        ],
      ),
    );
  }
}
