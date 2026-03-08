import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../providers/home_providers.dart';
import '../widgets/date_scroller.dart';
import '../widgets/fortune_header.dart';
import '../widgets/fortune_score_section.dart';
import '../widgets/quick_action_cards.dart';
import '../widgets/home_scenario_section.dart';
import '../widgets/explore_more_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final fortuneAsync = ref.watch(dailyFortuneProvider);

    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const DateScroller(),
                      fortuneAsync.when(
                        data: (fortune) => Column(
                          children: [
                            FortuneHeader(fortune: fortune),
                            FortuneScoreSection(fortune: fortune),
                          ],
                        ),
                        loading: () => const Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: CosmicColors.primaryLight,
                          ),
                        ),
                        error: (err, _) => Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Text(
                                l10n.errorLoadFailed,
                                style: const TextStyle(
                                  color: CosmicColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () =>
                                    ref.invalidate(dailyFortuneProvider),
                                child: Text(
                                  l10n.retry,
                                  style: const TextStyle(
                                    color: CosmicColors.primaryLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const QuickActionCards(),
                      const SizedBox(height: 8),
                      const HomeScenarioSection(),
                      const SizedBox(height: 8),
                      const ExploreMoreSection(),
                      const SizedBox(height: 100), // bottom padding for nav bar
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
