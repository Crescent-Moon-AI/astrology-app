import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/cosmic_ritual_button.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../domain/models/lenormand_spread.dart';
import '../providers/lenormand_providers.dart';

class LenormandSpreadSelect extends ConsumerStatefulWidget {
  final String? conversationId;

  const LenormandSpreadSelect({super.key, this.conversationId});

  @override
  ConsumerState<LenormandSpreadSelect> createState() =>
      _LenormandSpreadSelectState();
}

class _LenormandSpreadSelectState extends ConsumerState<LenormandSpreadSelect> {
  LenormandSpreadType _selectedSpread = LenormandSpreadType.threeCard;
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
          l10n.lenormandRitualTitle,
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
                  l10n.lenormandSelectSpread,
                  style: const TextStyle(
                    color: CosmicColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ...LenormandSpreadType.values.map(
                  (spread) => _buildSpreadCard(
                    spread,
                    isZh ? spread.nameZH : spread.nameEN,
                    '${spread.cardCount} ${isZh ? "牌" : "cards"}',
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _questionController,
                  style: const TextStyle(color: CosmicColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: l10n.lenormandQuestionHint,
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
                  label: l10n.lenormandBeginRitual,
                  onPressed: () async {
                    final notifier = ref.read(lenormandRitualProvider.notifier);
                    await notifier.createSession(
                      conversationId: widget.conversationId ?? 'mock-conv-001',
                      spreadType: _selectedSpread.value,
                      question: _questionController.text,
                    );
                    final session = ref.read(lenormandRitualProvider).session;
                    if (session != null && context.mounted) {
                      context.pushNamed(
                        'lenormandRitual',
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
    LenormandSpreadType spread,
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
