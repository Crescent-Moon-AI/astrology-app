import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/cosmic_ritual_button.dart';
import '../providers/meihua_providers.dart';
import '../widgets/three_hexagram_display.dart';

class MeihuaResultView extends ConsumerWidget {
  const MeihuaResultView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(meihuaProvider);
    final result = state.result;

    if (result == null) return const SizedBox.shrink();

    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          ThreeHexagramDisplay(result: result),
          const SizedBox(height: 24),
          // Meaning card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: CosmicColors.cardGradient,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: CosmicColors.borderGlow),
            ),
            child: Column(
              children: [
                Text(
                  '${l10n.meihuaMovingLine}: ${result.movingLine}',
                  style: const TextStyle(
                    color: CosmicColors.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isZh ? result.meaningZh : result.meaning,
                  style: const TextStyle(
                    color: CosmicColors.textPrimary,
                    fontSize: 16,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          CosmicRitualButton(
            label: l10n.meihuaGetReading,
            onPressed: () => ref.read(meihuaProvider.notifier).startReading(),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => ref.read(meihuaProvider.notifier).reset(),
            child: Text(
              l10n.meihuaTryAgain,
              style: const TextStyle(color: CosmicColors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}
