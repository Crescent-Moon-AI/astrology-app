import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import 'coin_3d.dart';

class CoinTossAnimation extends StatelessWidget {
  final VoidCallback? onToss;

  const CoinTossAnimation({super.key, this.onToss});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onToss,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Coin3D(size: 56),
              SizedBox(width: 16),
              Coin3D(size: 56),
              SizedBox(width: 16),
              Coin3D(size: 56),
            ],
          ),
          const SizedBox(height: 24),
          if (onToss != null)
            Text(
              l10n.ichingTapToToss,
              style: const TextStyle(
                color: CosmicColors.textTertiary,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }
}
