import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/house_overlay_data.dart';

/// Table for synastry showing which planets fall in which houses.
class HouseOverlayTable extends StatelessWidget {
  final List<HouseOverlayEntry> overlays;
  final String personName;

  const HouseOverlayTable({
    super.key,
    required this.overlays,
    required this.personName,
  });

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode == 'zh';

    return Container(
      decoration: BoxDecoration(
        color: CosmicColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Person name header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              isZh
                  ? '$personName 的行星落入宫位'
                  : '$personName\'s planets in houses',
              style: const TextStyle(
                color: CosmicColors.secondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1, color: CosmicColors.borderGlow),

          // Column headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    isZh ? '行星' : 'Planet',
                    style: const TextStyle(
                      color: CosmicColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 24,
                  child: Icon(
                    Icons.arrow_forward,
                    size: 12,
                    color: CosmicColors.textTertiary,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    isZh ? '宫位' : 'House',
                    style: const TextStyle(
                      color: CosmicColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: CosmicColors.borderSubtle),

          // Overlay rows
          ...overlays.map((entry) => _buildRow(entry, isZh)),
        ],
      ),
    );
  }

  Widget _buildRow(HouseOverlayEntry entry, bool isZh) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CosmicColors.borderSubtle, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              isZh ? entry.planetNameCn : entry.planetName,
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            width: 24,
            child: Icon(
              Icons.arrow_forward,
              size: 12,
              color: CosmicColors.textTertiary,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              isZh
                  ? '第${entry.houseNumber}宫 (${entry.houseSignCn})'
                  : 'House ${entry.houseNumber} (${entry.houseSign})',
              style: const TextStyle(
                color: CosmicColors.primaryLight,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
