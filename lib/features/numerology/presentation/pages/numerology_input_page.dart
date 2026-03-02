import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/cosmic_ritual_button.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../domain/models/numerology_state.dart';
import '../providers/numerology_providers.dart';
import '../widgets/digit_cascade.dart';
import '../widgets/master_number_glow.dart';
import '../widgets/number_meaning_card.dart';

class NumerologyInputPage extends ConsumerStatefulWidget {
  const NumerologyInputPage({super.key});

  @override
  ConsumerState<NumerologyInputPage> createState() =>
      _NumerologyInputPageState();
}

class _NumerologyInputPageState extends ConsumerState<NumerologyInputPage> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(numerologyProvider);

    ref.listen<NumerologyRitualState>(numerologyProvider, (prev, next) {
      if (next.step == NumerologyState.reading &&
          prev?.step != NumerologyState.reading) {
        if (context.mounted) {
          final result = next.result;
          final birthDate = next.birthDate;
          final isZh = Localizations.localeOf(
            context,
          ).languageCode.startsWith('zh');
          final dateStr = birthDate != null
              ? '${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}'
              : '';
          final prompt = result != null
              ? (isZh
                    ? '我的出生日期是 $dateStr，生命灵数为 ${result.lifePathNumber}${result.isMasterNumber ? '（大师数字）' : ''}。请为我详细解读数字命理的含义。'
                    : 'My birth date is $dateStr, life path number is ${result.lifePathNumber}${result.isMasterNumber ? ' (Master Number)' : ''}. Please give me a detailed numerology reading.')
              : l10n.numerologyGetReading;
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
          l10n.numerologyTitle,
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

  Widget _buildBody(NumerologyRitualState state, AppLocalizations l10n) {
    return switch (state.step) {
      NumerologyState.input => _buildInputView(state, l10n),
      NumerologyState.calculating => _buildCalculatingView(state, l10n),
      NumerologyState.revealed => _buildResultView(state, l10n),
      NumerologyState.reading => _buildResultView(state, l10n),
    };
  }

  Widget _buildInputView(NumerologyRitualState state, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.tag, size: 80, color: CosmicColors.primaryLight),
          const SizedBox(height: 24),
          Text(
            l10n.numerologyPrompt,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => _pickDate(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: CosmicColors.surfaceElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: CosmicColors.borderGlow),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: CosmicColors.primaryLight,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _selectedDate != null
                        ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                        : l10n.numerologySelectDate,
                    style: TextStyle(
                      color: _selectedDate != null
                          ? CosmicColors.textPrimary
                          : CosmicColors.textTertiary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          CosmicRitualButton(
            label: l10n.numerologyCalculate,
            onPressed: _selectedDate != null
                ? () => ref.read(numerologyProvider.notifier).calculate()
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatingView(
    NumerologyRitualState state,
    AppLocalizations l10n,
  ) {
    final result = state.result;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.numerologyCalculating,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 32),
          if (result != null)
            DigitCascade(steps: result.calculationSteps)
          else
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                CosmicColors.primaryLight,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultView(NumerologyRitualState state, AppLocalizations l10n) {
    final result = state.result;
    if (result == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          if (result.isMasterNumber)
            MasterNumberGlow(number: result.lifePathNumber)
          else
            Text(
              '${result.lifePathNumber}',
              style: const TextStyle(
                color: CosmicColors.secondary,
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 16),
          Text(
            l10n.numerologyLifePath,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          NumberMeaningCard(result: result),
          const SizedBox(height: 32),
          CosmicRitualButton(
            label: l10n.numerologyGetReading,
            onPressed: () =>
                ref.read(numerologyProvider.notifier).startReading(),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => ref.read(numerologyProvider.notifier).reset(),
            child: Text(
              l10n.numerologyTryAnother,
              style: const TextStyle(color: CosmicColors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(1995, 6, 15),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: CosmicColors.primary,
              onPrimary: CosmicColors.textPrimary,
              surface: Color(0xFF1A1040),
              onSurface: CosmicColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() => _selectedDate = date);
      ref.read(numerologyProvider.notifier).setBirthDate(date);
    }
  }
}
