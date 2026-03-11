import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/mystical_loading_widget.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../domain/models/ritual_state.dart';
import '../providers/tarot_ritual_providers.dart';
import 'tarot_shuffle_page.dart';
import 'card_picker_page.dart';
import 'card_reveal_page.dart';
import 'spread_overview_page.dart';

class TarotRitualPage extends ConsumerStatefulWidget {
  final String sessionId;
  final String? initialQuestion;

  const TarotRitualPage({super.key, required this.sessionId, this.initialQuestion});

  @override
  ConsumerState<TarotRitualPage> createState() => _TarotRitualPageState();
}

class _TarotRitualPageState extends ConsumerState<TarotRitualPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tarotRitualProvider.notifier).loadSession(widget.sessionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ritualState = ref.watch(tarotRitualProvider);

    ref.listen<TarotRitualState>(tarotRitualProvider, (prev, next) {
      if (next.step == RitualState.reading &&
          prev?.step != RitualState.reading) {
        final conversationId = next.session?.conversationId;
        if (conversationId != null && context.mounted) {
          final qp = <String, String>{
            'conversation_id': conversationId,
            'tarot_session_id': widget.sessionId,
          };
          if (widget.initialQuestion?.isNotEmpty == true) {
            qp['initial_question'] = widget.initialQuestion!;
          }
          context.pushNamed('tarotQuestion', queryParameters: qp);
        }
      }
      if (next.step == RitualState.cancelled) {
        if (context.mounted && context.canPop()) {
          context.pop();
        }
      }
    });

    return Scaffold(
      backgroundColor: CosmicColors.backgroundDeep,
      body: _buildBody(ritualState),
    );
  }

  Widget _buildBody(TarotRitualState ritualState) {
    final l10n = AppLocalizations.of(context)!;

    if (ritualState.isLoading && ritualState.session == null) {
      return const StarfieldBackground(
        child: Center(child: MysticalLoadingWidget()),
      );
    }

    if (ritualState.error != null && ritualState.session == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: CosmicColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              ritualState.error!,
              style: const TextStyle(color: CosmicColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                gradient: CosmicColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => ref
                      .read(tarotRitualProvider.notifier)
                      .loadSession(widget.sessionId),
                  borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Text(
                      l10n.retry,
                      style: const TextStyle(
                        color: CosmicColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return switch (ritualState.step) {
      RitualState.shuffling => const TarotShufflePage(),
      RitualState.pickingCards ||
      RitualState.confirming => const CardPickerPage(),
      RitualState.revealing => const CardRevealPage(),
      RitualState.reading ||
      RitualState.completed => const SpreadOverviewPage(),
      RitualState.cancelled || RitualState.expired => _buildEndedView(l10n),
    };
  }

  Widget _buildEndedView(AppLocalizations l10n) {
    return Container(
      color: CosmicColors.backgroundDeep,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cancel_outlined,
              size: 48,
              color: CosmicColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.tarotCancel,
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: CosmicColors.primaryLight,
                side: const BorderSide(color: CosmicColors.borderGlow),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(l10n.tarotResume),
            ),
          ],
        ),
      ),
    );
  }
}
