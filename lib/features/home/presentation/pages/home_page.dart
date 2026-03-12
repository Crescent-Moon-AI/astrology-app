import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../../settings/presentation/providers/profile_providers.dart';
import '../../domain/models/daily_fortune.dart';
import '../providers/home_providers.dart';
import '../widgets/date_scroller.dart';
import '../widgets/fortune_header.dart';
import '../widgets/fortune_score_section.dart';
import '../widgets/quick_action_cards.dart';
import '../widgets/home_scenario_section.dart';
import '../widgets/explore_more_section.dart';
import '../../../transit/presentation/widgets/active_transits_section.dart';

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
                              const SizedBox(height: 16),
                              _LuckyElementsRow(fortune: fortune),
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
                      const ActiveTransitsSection(),
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

/// Compact horizontal row showing the 4 lucky elements: color swatch, number,
/// flower, and stone — matching the Yuejian home page design.
class _LuckyElementsRow extends StatelessWidget {
  final DailyFortune fortune;

  const _LuckyElementsRow({required this.fortune});

  static const _colorMap = <String, Color>{
    '红色': Color(0xFFE74C3C),
    '橙色': Color(0xFFE67E22),
    '黄色': Color(0xFFF1C40F),
    '绿色': Color(0xFF2ECC71),
    '蓝色': Color(0xFF3498DB),
    '紫色': Color(0xFF9B59B6),
    '粉色': Color(0xFFFF6B9D),
    '白色': Color(0xFFECF0F1),
    '黑色': Color(0xFF2C3E50),
    '金色': Color(0xFFFFD700),
    '银色': Color(0xFFC0C0C0),
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lucky = fortune.luckyElements;
    final colorValue = _colorMap[lucky.color] ?? CosmicColors.primaryLight;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _LuckyItem(
            top: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: colorValue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorValue.withAlpha(100),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            label: l10n.homeLuckyColor,
            value: lucky.color,
          ),
          _LuckyItem(
            top: _HexagonNumber(number: lucky.number),
            label: l10n.homeLuckyNumber,
            value: '${lucky.number}',
          ),
          _LuckyItem(
            top: const Icon(
              Icons.local_florist,
              color: Color(0xFFFF9FF3),
              size: 26,
            ),
            label: l10n.homeLuckyFlower,
            value: lucky.flower,
          ),
          _LuckyItem(
            top: const Icon(
              Icons.diamond_outlined,
              color: Color(0xFF74B9FF),
              size: 26,
            ),
            label: l10n.homeLuckyStone,
            value: lucky.stone,
          ),
        ],
      ),
    );
  }
}

class _LuckyItem extends StatelessWidget {
  final Widget top;
  final String label;
  final String value;

  const _LuckyItem({
    required this.top,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: BoxDecoration(
          color: CosmicColors.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CosmicColors.borderGlow),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            top,
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                color: CosmicColors.textTertiary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HexagonNumber extends StatelessWidget {
  final int number;

  const _HexagonNumber({required this.number});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HexPainter(),
      child: SizedBox(
        width: 28,
        height: 28,
        child: Center(
          child: Text(
            '$number',
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _HexPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CosmicColors.primaryLight.withAlpha(40)
      ..style = PaintingStyle.fill;
    final border = Paint()
      ..color = CosmicColors.primaryLight.withAlpha(120)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 1;
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * math.pi / 180;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, border);
  }

  @override
  bool shouldRepaint(_HexPainter _) => false;
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
