import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/aspect_data.dart';
import 'aspect_nature_dot.dart';

/// Table of cross-aspects between two charts (transit, synastry, progressions).
class CrossAspectTable extends StatelessWidget {
  final List<AspectData> aspects;
  final String label1;
  final String label2;

  const CrossAspectTable({
    super.key,
    required this.aspects,
    required this.label1,
    required this.label2,
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
          ...aspects.map((aspect) => _buildRow(aspect, isZh)),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isZh) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          const SizedBox(width: 16), // dot space
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label1,
                  style: TextStyle(
                    color: CosmicColors.secondary.withValues(alpha: 0.8),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isZh ? '行星' : 'Planet',
                  style: const TextStyle(
                    color: CosmicColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              isZh ? '相位' : 'Aspect',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label2,
                  style: TextStyle(
                    color: CosmicColors.primaryLight.withValues(alpha: 0.8),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isZh ? '行星' : 'Planet',
                  style: const TextStyle(
                    color: CosmicColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 52,
            child: Text(
              isZh ? '容许度' : 'Orb',
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildRow(AspectData aspect, bool isZh) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CosmicColors.borderSubtle, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          AspectNatureDot(nature: aspect.nature),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              '${aspect.planet1Symbol} ${isZh ? aspect.planet1Cn : aspect.planet1}',
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              aspect.aspectSymbol,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CosmicColors.secondary,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '${aspect.planet2Symbol} ${isZh ? aspect.planet2Cn : aspect.planet2}',
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 52,
            child: Text(
              aspect.formattedOrb,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(
            width: 20,
            child: aspect.applying
                ? const Icon(
                    Icons.arrow_forward,
                    size: 12,
                    color: CosmicColors.primaryLight,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
