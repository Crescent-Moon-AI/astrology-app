import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/chart_data.dart';

/// Header card showing chart metadata (name, date, location).
class ChartInfoHeader extends StatelessWidget {
  final ChartInfo info;

  const ChartInfoHeader({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CosmicColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name in gold
          Text(
            info.name,
            style: const TextStyle(
              color: CosmicColors.secondary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),

          // Date
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 14,
                color: CosmicColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  info.date,
                  style: const TextStyle(
                    color: CosmicColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          // Location (if not empty)
          if (info.location.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: CosmicColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    info.location,
                    style: const TextStyle(
                      color: CosmicColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
