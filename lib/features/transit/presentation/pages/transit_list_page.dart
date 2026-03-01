import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/breathing_loader.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../domain/models/user_transit_alert.dart';
import '../providers/transit_providers.dart';
import '../widgets/transit_card.dart';

class TransitListPage extends ConsumerWidget {
  const TransitListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final activeAsync = ref.watch(activeTransitsProvider);
    final upcomingAsync = ref.watch(upcomingTransitsProvider(30));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.transitActiveTransits,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: CosmicColors.textPrimary,
          ),
        ),
        backgroundColor: CosmicColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month,
                color: CosmicColors.primaryLight),
            onPressed: () => context.pushNamed('calendar'),
            tooltip: l10n.calendarTitle,
          ),
        ],
      ),
      body: StarfieldBackground(
        child: RefreshIndicator(
          color: CosmicColors.primary,
          backgroundColor: CosmicColors.surfaceElevated,
          onRefresh: () async {
            ref.invalidate(activeTransitsProvider);
            ref.invalidate(upcomingTransitsProvider(30));
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionHeader(
                title: l10n.transitActiveTransits,
                icon: Icons.radio_button_checked,
                color: CosmicColors.secondary,
              ),
              const SizedBox(height: 10),
              activeAsync.when(
                data: (alerts) => _buildTransitList(context, alerts, l10n),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: BreathingLoader()),
                ),
                error: (error, _) => _buildError(context, error),
              ),

              const SizedBox(height: 28),

              _SectionHeader(
                title: l10n.transitUpcoming,
                icon: Icons.schedule,
                color: CosmicColors.primaryLight,
              ),
              const SizedBox(height: 10),
              upcomingAsync.when(
                data: (alerts) => _buildTransitList(context, alerts, l10n),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: BreathingLoader()),
                ),
                error: (error, _) => _buildError(context, error),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransitList(
    BuildContext context,
    List<UserTransitAlert> alerts,
    AppLocalizations l10n,
  ) {
    if (alerts.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            children: [
              const Text('\u2728', style: TextStyle(fontSize: 32)),
              const SizedBox(height: 8),
              Text(
                l10n.transitNoActive,
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: alerts
          .map((alert) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TransitCard(
                  alert: alert,
                  onTap: () => context.pushNamed(
                    'transitDetail',
                    pathParameters: {'id': alert.id},
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.cloud_off,
                size: 36, color: CosmicColors.textTertiary),
            const SizedBox(height: 8),
            Text(
              'Error: $error',
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: CosmicColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
