import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/breathing_loader.dart';
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
        title: Text(
          l10n.transitDetail,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: CosmicColors.textPrimary,
          ),
        ),
        backgroundColor: CosmicColors.background,
        elevation: 0,
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
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        CosmicColors.primary.withValues(alpha: 0.15),
                        CosmicColors.surfaceElevated,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: CosmicColors.borderGlow),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _buildTitle(alert),
                              style: const TextStyle(
                                color: CosmicColors.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SeverityBadge(severity: event.severity),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            alert.applying
                                ? Icons.arrow_forward
                                : Icons.arrow_back,
                            size: 16,
                            color: alert.applying
                                ? CosmicColors.secondary
                                : CosmicColors.primaryLight,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            alert.applying
                                ? l10n.transitApplying
                                : l10n.transitSeparating,
                            style: const TextStyle(
                              color: CosmicColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Orb: ${alert.orb.toStringAsFixed(2)}\u00B0',
                            style: const TextStyle(
                              color: CosmicColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Transit details card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: CosmicColors.surfaceElevated,
                    border: Border.all(color: CosmicColors.borderGlow),
                  ),
                  child: Column(
                    children: [
                      _DetailRow(
                        icon: Icons.wb_sunny_outlined,
                        label: 'Transit Planet',
                        value:
                            '${event.planet} ${alert.transitDegree.toStringAsFixed(1)}\u00B0 ${alert.transitSign}',
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Divider(color: CosmicColors.divider),
                      ),
                      _DetailRow(
                        icon: Icons.dark_mode_outlined,
                        label: 'Natal Planet',
                        value:
                            '${alert.natalPlanet} ${alert.natalDegree.toStringAsFixed(1)}\u00B0 ${alert.natalSign}',
                      ),
                      if (alert.natalHouse != null) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Divider(color: CosmicColors.divider),
                        ),
                        _DetailRow(
                          icon: Icons.home_outlined,
                          label: 'House',
                          value: '${alert.natalHouse}',
                        ),
                      ],
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Divider(color: CosmicColors.divider),
                      ),
                      _DetailRow(
                        icon: Icons.pin_drop_outlined,
                        label: 'Exact Date',
                        value: event.exactDate,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Divider(color: CosmicColors.divider),
                      ),
                      _DetailRow(
                        icon: Icons.date_range_outlined,
                        label: 'Active Period',
                        value: '${event.startDate} \u2013 ${event.endDate}',
                      ),
                    ],
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
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final repo = ref.read(transitRepositoryProvider);
                      await repo.dismissTransit(transitAlertId);
                      ref.invalidate(activeTransitsProvider);
                      if (context.mounted) {
                        context.pop();
                      }
                    },
                    icon: const Icon(Icons.visibility_off, size: 18),
                    label: Text(l10n.transitDismiss),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CosmicColors.textSecondary,
                      side: const BorderSide(color: CosmicColors.borderGlow),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: BreathingLoader()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off,
                  size: 48, color: CosmicColors.textTertiary),
              const SizedBox(height: 12),
              Text(
                'Error: $error',
                style: const TextStyle(color: CosmicColors.textSecondary),
              ),
            ],
          ),
        ),
      ),

      // Ask AI button
      bottomNavigationBar: detailAsync.when(
        data: (_) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                gradient: CosmicColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: CosmicColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.pushNamed(
                      'chat',
                      queryParameters: {'scenario_id': 'transit_reading'},
                    );
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.auto_awesome,
                            color: CosmicColors.textPrimary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          l10n.transitAskAi,
                          style: const TextStyle(
                            color: CosmicColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: CosmicColors.primaryLight),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
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
    final start = DateTime.tryParse(startDate);
    final end = DateTime.tryParse(endDate);
    final exact = DateTime.tryParse(exactDate);
    final now = DateTime.now();

    if (start == null || end == null) return const SizedBox.shrink();

    final totalDuration = end.difference(start).inHours;
    final elapsed = now.difference(start).inHours;
    final progress =
        totalDuration > 0 ? (elapsed / totalDuration).clamp(0.0, 1.0) : 0.0;

    double? exactPosition;
    if (exact != null && totalDuration > 0) {
      exactPosition =
          (exact.difference(start).inHours / totalDuration).clamp(0.0, 1.0);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: CosmicColors.surfaceElevated,
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress bar
          Stack(
            children: [
              // Background
              Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: CosmicColors.surface,
                ),
              ),
              // Progress
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: CosmicColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: CosmicColors.primary.withValues(alpha: 0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
              // Exact date marker
              if (exactPosition != null)
                Positioned(
                  left: exactPosition *
                      (MediaQuery.of(context).size.width - 96),
                  child: Container(
                    width: 3,
                    height: 8,
                    decoration: BoxDecoration(
                      color: CosmicColors.secondary,
                      borderRadius: BorderRadius.circular(1.5),
                      boxShadow: [
                        BoxShadow(
                          color: CosmicColors.secondary.withValues(alpha: 0.6),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Date labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                startDate,
                style: const TextStyle(
                  color: CosmicColors.textTertiary,
                  fontSize: 11,
                ),
              ),
              if (exact != null)
                Text(
                  'Exact: $exactDate',
                  style: const TextStyle(
                    color: CosmicColors.secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              Text(
                endDate,
                style: const TextStyle(
                  color: CosmicColors.textTertiary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
