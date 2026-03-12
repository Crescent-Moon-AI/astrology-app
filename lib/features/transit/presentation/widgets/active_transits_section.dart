import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../providers/transit_providers.dart';
import 'transit_card.dart';

const _severityPriority = <String, int>{'major': 0, 'medium': 1, 'low': 2};

class ActiveTransitsSection extends ConsumerWidget {
  const ActiveTransitsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final activeAsync = ref.watch(activeTransitsProvider);

    return activeAsync.when(
      data: (alerts) {
        if (alerts.isEmpty) return const SizedBox.shrink();

        // Sort by severity (major first)
        final sorted = List.of(alerts)
          ..sort(
            (a, b) => (_severityPriority[a.transitEvent.severity] ?? 2)
                .compareTo(_severityPriority[b.transitEvent.severity] ?? 2),
          );
        final display = sorted.take(3).toList();
        final hasMore = alerts.length > 3;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.transitActiveTransits,
                    style: const TextStyle(
                      color: CosmicColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.pushNamed('transits'),
                    child: Text(
                      l10n.cardShowDetails,
                      style: const TextStyle(color: CosmicColors.primaryLight),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: display.length + (hasMore ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  if (index < display.length) {
                    final alert = display[index];
                    return SizedBox(
                      width: 260,
                      child: TransitCard(
                        alert: alert,
                        onTap: () => context.pushNamed(
                          'transitDetail',
                          pathParameters: {'id': alert.id},
                        ),
                      ),
                    );
                  }
                  // "查看全部" card
                  return GestureDetector(
                    onTap: () => context.pushNamed('transits'),
                    child: Container(
                      width: 260,
                      decoration: BoxDecoration(
                        color: CosmicColors.surfaceElevated.withAlpha(120),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: CosmicColors.borderGlow),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '查看全部 ${alerts.length} 个行运',
                              style: const TextStyle(
                                color: CosmicColors.primaryLight,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.chevron_right,
                              color: CosmicColors.primaryLight,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 48,
        child: Center(
          child: CircularProgressIndicator(color: CosmicColors.primary),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
