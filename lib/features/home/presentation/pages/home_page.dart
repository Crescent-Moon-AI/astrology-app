import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../../settings/presentation/providers/profile_providers.dart';
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
    final profileAsync = ref.watch(userProfileProvider);
    final hasBirthData = profileAsync.asData?.value.core.birthDate != null;
    final fortuneAsync = ref.watch(dailyFortuneProvider);

    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Moon visual area — always shown
                      SizedBox(
                        height: 280,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Glow halo
                            Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF7B61FF,
                                    ).withAlpha(60),
                                    blurRadius: 60,
                                    spreadRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                            // Moon body
                            Container(
                              width: 190,
                              height: 190,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const RadialGradient(
                                  center: Alignment(-0.3, -0.3),
                                  radius: 0.85,
                                  colors: [
                                    Color(0xFFD8D0C8),
                                    Color(0xFFB0A898),
                                    Color(0xFF807870),
                                    Color(0xFF504840),
                                  ],
                                  stops: [0.0, 0.4, 0.75, 1.0],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF9B8FFF,
                                    ).withAlpha(80),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: CustomPaint(
                                  painter: _MoonCraterPainter(),
                                ),
                              ),
                            ),
                            // Date scroller always on top
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: const DateScroller(),
                            ),
                            // No birth data: show prompt overlay on moon
                            if (!hasBirthData)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 60),
                                  Text(
                                    l10n.homeFortuneNoBirthData,
                                    style: const TextStyle(
                                      color: CosmicColors.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  GestureDetector(
                                    onTap: () =>
                                        context.push('/settings/birth-data'),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 28,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: CosmicColors.primaryGradient,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: Text(
                                        l10n.homeFortuneAddInfo,
                                        style: const TextStyle(
                                          color: CosmicColors.textPrimary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      // Fortune data below moon (only when birth data exists)
                      if (hasBirthData)
                        fortuneAsync.when(
                          data: (fortune) => Column(
                            children: [
                              FortuneHeader(fortune: fortune),
                              FortuneScoreSection(fortune: fortune),
                            ],
                          ),
                          loading: () => const Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: CosmicColors.primaryLight,
                            ),
                          ),
                          error: (err, _) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
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
                      const SizedBox(height: 100),
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

/// Paints subtle crater-like texture on the moon surface.
class _MoonCraterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = const Color(0xFF686058).withAlpha(100);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.35, size.height * 0.32),
        width: size.width * 0.45,
        height: size.height * 0.28,
      ),
      paint,
    );

    paint.color = const Color(0xFF585048).withAlpha(80);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.65, size.height * 0.62),
        width: size.width * 0.3,
        height: size.height * 0.22,
      ),
      paint,
    );

    paint.color = const Color(0xFF706860).withAlpha(60);
    canvas.drawCircle(
      Offset(size.width * 0.55, size.height * 0.28),
      size.width * 0.07,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.60),
      size.width * 0.05,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.72, size.height * 0.42),
      size.width * 0.04,
      paint,
    );

    paint.color = Colors.white.withAlpha(40);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.38, size.height * 0.38),
        width: size.width * 0.5,
        height: size.height * 0.45,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_MoonCraterPainter _) => false;
}
