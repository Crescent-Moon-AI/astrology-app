import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../domain/models/scenario.dart';
import '../providers/scenario_providers.dart';

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
    final selectedSlug = ref.watch(selectedCategoryProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: Text(l10n.scenarioAllCategories),
            selected: selectedSlug == null,
            onSelected: (_) => onSelected(null),
          ),
          const SizedBox(width: 8),
          ...categories.map((cat) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(cat.name),
                  selected: selectedSlug == cat.slug,
                  onSelected: (_) => onSelected(
                    selectedSlug == cat.slug ? null : cat.slug,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
