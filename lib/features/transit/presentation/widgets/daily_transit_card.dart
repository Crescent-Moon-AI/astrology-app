import 'package:flutter/material.dart';
import '../../domain/models/daily_transit.dart';

class DailyTransitCard extends StatelessWidget {
  final DailyTransitEvent event;

  const DailyTransitCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor(theme), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _badgeColor(theme).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              event.time,
              style: theme.textTheme.labelMedium?.copyWith(
                color: _badgeColor(theme),
                fontWeight: FontWeight.w600,
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Title and icon
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(_eventIcon, size: 16, color: _badgeColor(theme)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        event.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData get _eventIcon {
    switch (event.eventType) {
      case 'transit_aspect':
        return Icons.auto_awesome;
      case 'sky_aspect':
        return Icons.public;
      case 'house_ingress':
        return Icons.house_outlined;
      case 'sign_ingress':
      case 'sky_ingress':
        return Icons.change_circle_outlined;
      default:
        return Icons.stars;
    }
  }

  Color _badgeColor(ThemeData theme) {
    switch (event.eventType) {
      case 'transit_aspect':
        return Colors.amber;
      case 'sky_aspect':
      case 'sky_ingress':
        return Colors.teal;
      case 'house_ingress':
        return Colors.blue;
      case 'sign_ingress':
        return Colors.purple;
      default:
        return theme.colorScheme.primary;
    }
  }

  Color _borderColor(ThemeData theme) {
    return theme.colorScheme.outline.withValues(alpha: 0.2);
  }

  String? get _subtitle {
    switch (event.eventType) {
      case 'transit_aspect':
      case 'sky_aspect':
        return '${event.transitPlanetCn} ${event.aspectCn} ${event.natalPlanetCn}';
      case 'house_ingress':
        return '${event.transitPlanetCn} → 第${event.houseNumber}宫';
      case 'sign_ingress':
        return '${event.transitPlanetCn} → ${event.signCn} (第${event.activatedHouse}宫)';
      case 'sky_ingress':
        return '${event.transitPlanetCn} → ${event.signCn}';
      default:
        return null;
    }
  }
}
