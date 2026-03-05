import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/planet_data.dart';
import 'planet_sign_badge.dart';
import 'retrograde_badge.dart';

/// Table of planets with symbol, name, sign/degree, house, and retrograde indicator.
class PlanetTable extends StatelessWidget {
  final List<PlanetData> planets;
  final bool showHouse;

  const PlanetTable({
    super.key,
    required this.planets,
    this.showHouse = true,
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
          _buildHeader(isZh),
          const Divider(height: 1, color: CosmicColors.borderGlow),
          ...planets.map((planet) => _buildRow(planet, isZh)),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isZh) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              isZh ? '行星' : 'Planet',
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              isZh ? '星座 / 度数' : 'Sign / Degree',
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (showHouse)
            SizedBox(
              width: 48,
              child: Text(
                isZh ? '宫位' : 'House',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _buildRow(PlanetData planet, bool isZh) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CosmicColors.borderSubtle, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Row(
              children: [
                Text(
                  planet.symbol,
                  style: const TextStyle(
                    color: CosmicColors.secondary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    isZh ? planet.nameCn : planet.name,
                    style: const TextStyle(
                      color: CosmicColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PlanetSignBadge(
              signSymbol: planet.signSymbol,
              degree: planet.degree,
              minute: planet.minute,
            ),
          ),
          if (showHouse)
            SizedBox(
              width: 48,
              child: Text(
                planet.house != null ? '${planet.house}' : '-',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          SizedBox(
            width: 28,
            child: planet.retrograde
                ? const Align(
                    alignment: Alignment.centerRight,
                    child: RetrogradeBadge(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
