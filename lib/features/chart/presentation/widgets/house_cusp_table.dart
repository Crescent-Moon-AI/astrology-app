import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/house_data.dart';

/// Table of house cusps with angles header and a 2-column layout.
class HouseCuspTable extends StatelessWidget {
  final HouseSystemData houses;

  const HouseCuspTable({super.key, required this.houses});

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode == 'zh';
    final angles = houses.angles;

    // Split cusps into two columns: 1-6, 7-12
    final leftCusps = houses.cusps.where((c) => c.number <= 6).toList();
    final rightCusps = houses.cusps.where((c) => c.number > 6).toList();

    return Container(
      decoration: BoxDecoration(
        color: CosmicColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // System name header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              '${isZh ? "宫位系统" : "House System"}: ${houses.system}',
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1, color: CosmicColors.borderGlow),

          // Angles row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: _buildAngle(
                    'ASC',
                    isZh ? angles.ascSignCn : angles.ascSign,
                    angles.ascDegree,
                    angles.ascMinute,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAngle(
                    'MC',
                    isZh ? angles.mcSignCn : angles.mcSign,
                    angles.mcDegree,
                    angles.mcMinute,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: CosmicColors.borderGlow),

          // House cusps in 2 columns
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: leftCusps
                        .map((c) => _buildCuspRow(c, isZh))
                        .toList(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: rightCusps
                        .map((c) => _buildCuspRow(c, isZh))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAngle(String label, String sign, int degree, int minute) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: CosmicColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: CosmicColors.primaryLight,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$sign $degree\u00B0$minute\'',
          style: const TextStyle(
            color: CosmicColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCuspRow(HouseCuspData cusp, bool isZh) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${cusp.number}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            cusp.formattedPosition,
            style: const TextStyle(
              color: CosmicColors.primaryLight,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
