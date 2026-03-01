import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: CosmicColors.surfaceElevated,
            border: Border.all(color: CosmicColors.borderGlow),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: planet icons + severity badge
              Row(
                children: [
                  Icon(
                    _planetIcon(alert.transitEvent.planet),
                    size: 22,
                    color: CosmicColors.primaryLight,
                  ),
                  if (alert.transitEvent.aspectType != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        _aspectSymbol(alert.transitEvent.aspectType!),
                        style: const TextStyle(
                          fontSize: 16,
                          color: CosmicColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                  Icon(
                    _planetIcon(alert.natalPlanet),
                    size: 22,
                    color: CosmicColors.secondary,
                  ),
                  const Spacer(),
                  SeverityBadge(severity: alert.transitEvent.severity),
                ],
              ),
              const SizedBox(height: 10),

              // Transit description
              Text(
                _buildTitle(),
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Orb + applying/separating
              Row(
                children: [
                  Text(
                    'Orb: ${alert.orb.toStringAsFixed(1)}\u00B0',
                    style: const TextStyle(
                      color: CosmicColors.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    alert.applying
                        ? Icons.arrow_forward
                        : Icons.arrow_back,
                    size: 14,
                    color: alert.applying
                        ? CosmicColors.secondary
                        : CosmicColors.primaryLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    alert.applying
                        ? l10n.transitApplying
                        : l10n.transitSeparating,
                    style: const TextStyle(
                      color: CosmicColors.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: CosmicColors.textTertiary,
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
        return '\u2606';
      case 'opposition':
        return '\u260D';
      case 'trine':
        return '\u25B3';
      case 'square':
        return '\u25A1';
      case 'sextile':
        return '\u2731';
      default:
        return '\u2022';
    }
  }
}
