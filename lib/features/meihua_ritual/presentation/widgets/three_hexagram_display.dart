import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/meihua_result.dart';
import 'trigram_builder.dart';

class ThreeHexagramDisplay extends StatelessWidget {
  final MeihuaResult result;

  const ThreeHexagramDisplay({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHexagramColumn(
          label: l10n.meihuaPrimaryHexagram,
          hexagram: result.primaryHexagram,
          isZh: isZh,
        ),
        // Arrow
        const Padding(
          padding: EdgeInsets.only(top: 48),
          child: Icon(
            Icons.arrow_forward,
            color: CosmicColors.textTertiary,
            size: 20,
          ),
        ),
        _buildHexagramColumn(
          label: l10n.meihuaTransformedHexagram,
          hexagram: result.transformedHexagram,
          isZh: isZh,
        ),
        if (result.mutualHexagram != null) ...[
          const Padding(
            padding: EdgeInsets.only(top: 48),
            child: Icon(
              Icons.arrow_forward,
              color: CosmicColors.textTertiary,
              size: 20,
            ),
          ),
          _buildHexagramColumn(
            label: l10n.meihuaMutualHexagram,
            hexagram: result.mutualHexagram!,
            isZh: isZh,
          ),
        ],
      ],
    );
  }

  Widget _buildHexagramColumn({
    required String label,
    required MeihuaHexagram hexagram,
    required bool isZh,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: CosmicColors.textTertiary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        // Upper trigram
        TrigramBuilderWidget(trigramNumber: hexagram.upperTrigramNumber),
        const SizedBox(height: 4),
        // Lower trigram
        TrigramBuilderWidget(trigramNumber: hexagram.lowerTrigramNumber),
        const SizedBox(height: 8),
        Text(
          isZh ? hexagram.nameZh : hexagram.name,
          style: const TextStyle(
            color: CosmicColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
