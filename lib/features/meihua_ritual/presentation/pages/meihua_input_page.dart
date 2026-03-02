import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/cosmic_ritual_button.dart';
import '../providers/meihua_providers.dart';

class MeihuaInputView extends ConsumerStatefulWidget {
  const MeihuaInputView({super.key});

  @override
  ConsumerState<MeihuaInputView> createState() => _MeihuaInputViewState();
}

class _MeihuaInputViewState extends ConsumerState<MeihuaInputView> {
  final _numAController = TextEditingController();
  final _numBController = TextEditingController();
  final _questionController = TextEditingController();

  @override
  void dispose() {
    _numAController.dispose();
    _numBController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(meihuaProvider);
    final isTimeMethod = state.method == 'time';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _questionController,
            style: const TextStyle(color: CosmicColors.textPrimary),
            decoration: InputDecoration(
              hintText: l10n.meihuaQuestionHint,
              hintStyle: const TextStyle(color: CosmicColors.textTertiary),
              filled: true,
              fillColor: CosmicColors.surfaceElevated,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: CosmicColors.borderGlow),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: CosmicColors.borderGlow),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: CosmicColors.primaryLight),
              ),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          if (isTimeMethod)
            _buildTimeDisplay(l10n)
          else
            _buildNumberInputs(l10n),
          const SizedBox(height: 32),
          CosmicRitualButton(
            label: l10n.meihuaCalculateButton,
            isLoading: state.isLoading,
            onPressed: () {
              final notifier = ref.read(meihuaProvider.notifier);
              notifier.setQuestion(_questionController.text);
              if (isTimeMethod) {
                notifier.setTime(DateTime.now());
              } else {
                final a = int.tryParse(_numAController.text) ?? 1;
                final b = int.tryParse(_numBController.text) ?? 1;
                notifier.setNumbers(a, b);
              }
              notifier.calculate();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDisplay(AppLocalizations l10n) {
    final now = DateTime.now();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.access_time,
            color: CosmicColors.secondary,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.meihuaCurrentTime,
            style: const TextStyle(
              color: CosmicColors.textTertiary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberInputs(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _numAController,
            style: const TextStyle(color: CosmicColors.textPrimary),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: l10n.meihuaNumberA,
              hintStyle: const TextStyle(color: CosmicColors.textTertiary),
              filled: true,
              fillColor: CosmicColors.surfaceElevated,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: CosmicColors.borderGlow),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: CosmicColors.borderGlow),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: CosmicColors.primaryLight),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: _numBController,
            style: const TextStyle(color: CosmicColors.textPrimary),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: l10n.meihuaNumberB,
              hintStyle: const TextStyle(color: CosmicColors.textTertiary),
              filled: true,
              fillColor: CosmicColors.surfaceElevated,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: CosmicColors.borderGlow),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: CosmicColors.borderGlow),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: CosmicColors.primaryLight),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
