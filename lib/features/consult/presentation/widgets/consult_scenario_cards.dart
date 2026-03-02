import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../scenario/presentation/providers/scenario_providers.dart';

class ConsultScenarioCards extends ConsumerWidget {
  const ConsultScenarioCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final hotAsync = ref.watch(hotScenariosProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.scenarioHotTitle,
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          hotAsync.when(
            data: (scenarios) => Column(
              children: scenarios.take(3).map((s) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildHotCard(context, s),
                );
              }).toList(),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildHotCard(BuildContext context, dynamic scenario) {
    final title = scenario.title as String;

    return GestureDetector(
      onTap: () => context.push('/chat?scenario_id=${scenario.id}'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: CosmicColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
