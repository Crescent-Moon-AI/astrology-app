import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../domain/models/user_transit_alert.dart';
import 'severity_badge.dart';

class TransitCard extends StatelessWidget {
  final UserTransitAlert alert;
  final VoidCallback? onTap;

  const TransitCard({
    super.key,
    required this.alert,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: planet icons + severity badge
              Row(
                children: [
                  Icon(
                    _planetIcon(alert.transitEvent.planet),
                    size: 22,
                    color: theme.colorScheme.primary,
                  ),
                  if (alert.transitEvent.aspectType != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        _aspectSymbol(alert.transitEvent.aspectType!),
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                  Icon(
                    _planetIcon(alert.natalPlanet),
                    size: 22,
                    color: theme.colorScheme.secondary,
                  ),
                  const Spacer(),
                  SeverityBadge(severity: alert.transitEvent.severity),
                ],
              ),
              const SizedBox(height: 10),

              // Transit description
              Text(
                _buildTitle(),
                style: theme.textTheme.titleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Orb + applying/separating
              Row(
                children: [
                  Text(
                    'Orb: ${alert.orb.toStringAsFixed(1)}°',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    alert.applying
                        ? Icons.arrow_forward
                        : Icons.arrow_back,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    alert.applying
                        ? l10n.transitApplying
                        : l10n.transitSeparating,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildTitle() {
    final event = alert.transitEvent;
    final aspect = event.aspectType ?? event.eventType;
    return '${event.planet} $aspect ${alert.natalPlanet}';
  }

  IconData _planetIcon(String planet) {
    switch (planet.toLowerCase()) {
      case 'sun':
        return Icons.wb_sunny;
      case 'moon':
        return Icons.nightlight_round;
      case 'mercury':
        return Icons.speed;
      case 'venus':
        return Icons.favorite;
      case 'mars':
        return Icons.local_fire_department;
      case 'jupiter':
        return Icons.cloud;
      case 'saturn':
        return Icons.hourglass_bottom;
      case 'uranus':
        return Icons.bolt;
      case 'neptune':
        return Icons.water;
      case 'pluto':
        return Icons.dark_mode;
      default:
        return Icons.circle;
    }
  }

  String _aspectSymbol(String aspectType) {
    switch (aspectType.toLowerCase()) {
      case 'conjunction':
        return '\u2606'; // star
      case 'opposition':
        return '\u260D'; // opposition
      case 'trine':
        return '\u25B3'; // triangle
      case 'square':
        return '\u25A1'; // square
      case 'sextile':
        return '\u2731'; // sextile
      default:
        return '\u2022'; // bullet
    }
  }
}
