import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
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
        title: Text(l10n.transitActiveTransits),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => context.pushNamed('calendar'),
            tooltip: l10n.calendarTitle,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(activeTransitsProvider);
          ref.invalidate(upcomingTransitsProvider(30));
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Active transits section
            _SectionHeader(title: l10n.transitActiveTransits),
            const SizedBox(height: 8),
            activeAsync.when(
              data: (alerts) => _buildTransitList(context, alerts, l10n),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),

            const SizedBox(height: 24),

            // Upcoming transits section
            _SectionHeader(title: l10n.transitUpcoming),
            const SizedBox(height: 8),
            upcomingAsync.when(
              data: (alerts) => _buildTransitList(context, alerts, l10n),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ],
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
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            l10n.transitNoActive,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      );
    }

    return Column(
      children: alerts
          .map((alert) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
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
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
