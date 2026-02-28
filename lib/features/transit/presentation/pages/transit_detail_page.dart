import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../providers/transit_providers.dart';
import '../widgets/severity_badge.dart';

class TransitDetailPage extends ConsumerWidget {
  final String transitAlertId;

  const TransitDetailPage({
    super.key,
    required this.transitAlertId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final detailAsync = ref.watch(transitDetailProvider(transitAlertId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.transitDetail),
      ),
      body: detailAsync.when(
        data: (alert) {
          final event = alert.transitEvent;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _buildTitle(alert),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                            SeverityBadge(severity: event.severity),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Applying / Separating indicator
                        Row(
                          children: [
                            Icon(
                              alert.applying
                                  ? Icons.arrow_forward
                                  : Icons.arrow_back,
                              size: 18,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              alert.applying
                                  ? l10n.transitApplying
                                  : l10n.transitSeparating,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Orb: ${alert.orb.toStringAsFixed(2)}\u00B0',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Transit details
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _DetailRow(
                          label: 'Transit Planet',
                          value:
                              '${event.planet} ${alert.transitDegree.toStringAsFixed(1)}\u00B0 ${alert.transitSign}',
                        ),
                        const Divider(),
                        _DetailRow(
                          label: 'Natal Planet',
                          value:
                              '${alert.natalPlanet} ${alert.natalDegree.toStringAsFixed(1)}\u00B0 ${alert.natalSign}',
                        ),
                        if (alert.natalHouse != null) ...[
                          const Divider(),
                          _DetailRow(
                            label: 'House',
                            value: '${alert.natalHouse}',
                          ),
                        ],
                        const Divider(),
                        _DetailRow(
                          label: 'Exact Date',
                          value: event.exactDate,
                        ),
                        const Divider(),
                        _DetailRow(
                          label: 'Active Period',
                          value: '${event.startDate} \u2013 ${event.endDate}',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Duration bar
                _DurationBar(
                  startDate: event.startDate,
                  endDate: event.endDate,
                  exactDate: event.exactDate,
                ),

                const SizedBox(height: 24),

                // Dismiss button
                OutlinedButton.icon(
                  onPressed: () async {
                    final repo = ref.read(transitRepositoryProvider);
                    await repo.dismissTransit(transitAlertId);
                    ref.invalidate(activeTransitsProvider);
                    if (context.mounted) {
                      context.pop();
                    }
                  },
                  icon: const Icon(Icons.visibility_off),
                  label: Text(l10n.transitDismiss),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),

      // Ask AI button at bottom
      bottomNavigationBar: detailAsync.when(
        data: (_) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              onPressed: () {
                context.pushNamed(
                  'chat',
                  queryParameters: {'scenario_id': 'transit_reading'},
                );
              },
              icon: const Icon(Icons.auto_awesome),
              label: Text(l10n.transitAskAi),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ),
        ),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  String _buildTitle(alert) {
    final event = alert.transitEvent;
    final aspect = event.aspectType ?? event.eventType;
    return '${event.planet} $aspect ${alert.natalPlanet}';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _DurationBar extends StatelessWidget {
  final String startDate;
  final String endDate;
  final String exactDate;

  const _DurationBar({
    required this.startDate,
    required this.endDate,
    required this.exactDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Parse dates to calculate progress
    final start = DateTime.tryParse(startDate);
    final end = DateTime.tryParse(endDate);
    final exact = DateTime.tryParse(exactDate);
    final now = DateTime.now();

    if (start == null || end == null) return const SizedBox.shrink();

    final totalDuration = end.difference(start).inHours;
    final elapsed = now.difference(start).inHours;
    final progress =
        totalDuration > 0 ? (elapsed / totalDuration).clamp(0.0, 1.0) : 0.0;

    // Exact date marker position
    double? exactPosition;
    if (exact != null && totalDuration > 0) {
      exactPosition =
          (exact.difference(start).inHours / totalDuration).clamp(0.0, 1.0);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor:
                    theme.colorScheme.surfaceContainerHighest,
                color: theme.colorScheme.primary,
              ),
            ),
            // Exact date marker
            if (exactPosition != null)
              Positioned(
                left: exactPosition *
                    (MediaQuery.of(context).size.width - 64),
                child: Container(
                  width: 3,
                  height: 8,
                  color: theme.colorScheme.error,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        // Date labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              startDate,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (exact != null)
              Text(
                'Exact: $exactDate',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            Text(
              endDate,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
