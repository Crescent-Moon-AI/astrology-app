import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/cosmic_ritual_button.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../domain/models/rune_spread.dart';
import '../providers/rune_providers.dart';

class RuneSpreadSelect extends ConsumerStatefulWidget {
  final String? conversationId;

  const RuneSpreadSelect({super.key, this.conversationId});

  @override
  ConsumerState<RuneSpreadSelect> createState() => _RuneSpreadSelectState();
}

class _RuneSpreadSelectState extends ConsumerState<RuneSpreadSelect> {
  RuneSpreadType _selectedSpread = RuneSpreadType.threeRune;
  final _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.runeRitualTitle,
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.runeSelectSpread,
                  style: const TextStyle(
                    color: CosmicColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ...RuneSpreadType.values.map(
                  (spread) => _buildSpreadCard(
                    spread,
                    isZh ? spread.nameZH : spread.nameEN,
                    '${spread.runeCount} ${isZh ? "符文" : "runes"}',
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _questionController,
                  style: const TextStyle(color: CosmicColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: l10n.runeQuestionHint,
                    hintStyle: const TextStyle(
                      color: CosmicColors.textTertiary,
                    ),
                    filled: true,
                    fillColor: CosmicColors.surfaceElevated,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: CosmicColors.borderGlow,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: CosmicColors.borderGlow,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: CosmicColors.primaryLight,
                      ),
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 32),
                CosmicRitualButton(
                  label: l10n.runeBeginRitual,
                  onPressed: () async {
                    final notifier = ref.read(runeRitualProvider.notifier);
                    await notifier.createSession(
                      conversationId: widget.conversationId ?? 'mock-conv-001',
                      spreadType: _selectedSpread.value,
                      question: _questionController.text,
                    );
                    final session = ref.read(runeRitualProvider).session;
                    if (session != null && context.mounted) {
                      context.pushNamed(
                        'runeRitual',
                        pathParameters: {'sessionId': session.id},
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpreadCard(
    RuneSpreadType spread,
    String title,
    String subtitle,
  ) {
    final isSelected = _selectedSpread == spread;

    return GestureDetector(
      onTap: () => setState(() => _selectedSpread = spread),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? CosmicColors.primary.withAlpha(38)
              : CosmicColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? CosmicColors.primaryLight
                : CosmicColors.borderGlow,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? CosmicColors.primaryLight
                          : CosmicColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: CosmicColors.textTertiary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: CosmicColors.primaryLight,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
