import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/cosmic_ritual_button.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../providers/iching_providers.dart';

class IChingQuestionPage extends ConsumerStatefulWidget {
  const IChingQuestionPage({super.key});

  @override
  ConsumerState<IChingQuestionPage> createState() => _IChingQuestionPageState();
}

class _IChingQuestionPageState extends ConsumerState<IChingQuestionPage> {
  final _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.ichingRitualTitle,
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '\u2630', // ☰ trigram symbol
                  style: TextStyle(fontSize: 64, color: CosmicColors.secondary),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.ichingQuestionPrompt,
                  style: const TextStyle(
                    color: CosmicColors.textSecondary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _questionController,
                  style: const TextStyle(color: CosmicColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: l10n.ichingQuestionHint,
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
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                CosmicRitualButton(
                  label: l10n.ichingBeginTossing,
                  onPressed: () async {
                    final notifier = ref.read(ichingRitualProvider.notifier);
                    await notifier.createSession(
                      conversationId: 'mock-conv-001',
                      question: _questionController.text,
                    );
                    final session = ref.read(ichingRitualProvider).session;
                    if (session != null && context.mounted) {
                      context.pushNamed(
                        'ichingRitual',
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
}
