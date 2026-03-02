import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../domain/models/meihua_result.dart';
import '../../domain/models/meihua_state.dart';
import '../providers/meihua_providers.dart';
import '../widgets/method_selector.dart';
import 'meihua_input_page.dart';
import 'meihua_result_page.dart';

class MeihuaMethodPage extends ConsumerStatefulWidget {
  const MeihuaMethodPage({super.key});

  @override
  ConsumerState<MeihuaMethodPage> createState() => _MeihuaMethodPageState();
}

class _MeihuaMethodPageState extends ConsumerState<MeihuaMethodPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(meihuaProvider);

    ref.listen<MeihuaRitualData>(meihuaProvider, (prev, next) {
      if (next.step == MeihuaState.reading &&
          prev?.step != MeihuaState.reading) {
        if (context.mounted) {
          final result = next.result;
          final isZh = Localizations.localeOf(
            context,
          ).languageCode.startsWith('zh');
          final methodName = next.method == 'time'
              ? (isZh ? '时间' : 'time-based')
              : (isZh ? '数字' : 'number-based');
          final prompt = result != null
              ? (isZh
                    ? '我用梅花易数的${methodName}法起卦，得到本卦第${result.primaryHexagram.number}卦，变卦第${result.transformedHexagram.number}卦，动爻第${result.movingLine}爻。请为我解读。'
                    : 'I cast a Meihua Yishu hexagram using the $methodName method. Primary hexagram #${result.primaryHexagram.number}, transformed hexagram #${result.transformedHexagram.number}, moving line ${result.movingLine}. Please interpret this for me.')
              : l10n.meihuaGetReading;
          context.pushNamed(
            'chat',
            queryParameters: {'initial_message': prompt},
          );
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.meihuaRitualTitle,
          style: const TextStyle(
            color: CosmicColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: CosmicColors.textPrimary),
      ),
      extendBodyBehindAppBar: true,
      body: StarfieldBackground(
        child: SafeArea(child: _buildBody(state, l10n)),
      ),
    );
  }

  Widget _buildBody(MeihuaRitualData state, AppLocalizations l10n) {
    return switch (state.step) {
      MeihuaState.selectMethod => _buildMethodSelect(l10n),
      MeihuaState.input => const MeihuaInputView(),
      MeihuaState.calculating => _buildCalculatingView(l10n),
      MeihuaState.revealed || MeihuaState.reading => const MeihuaResultView(),
    };
  }

  Widget _buildMethodSelect(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '\u6885', // 梅
            style: TextStyle(fontSize: 64, color: CosmicColors.secondary),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.meihuaSelectMethod,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          MethodSelector(
            icon: Icons.access_time,
            title: l10n.meihuaTimeMethod,
            description: l10n.meihuaTimeMethodDesc,
            onTap: () => ref.read(meihuaProvider.notifier).selectMethod('time'),
          ),
          const SizedBox(height: 16),
          MethodSelector(
            icon: Icons.tag,
            title: l10n.meihuaNumberMethod,
            description: l10n.meihuaNumberMethodDesc,
            onTap: () =>
                ref.read(meihuaProvider.notifier).selectMethod('number'),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatingView(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              CosmicColors.primaryLight,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.meihuaCalculating,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
