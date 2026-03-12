import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../domain/models/daily_fortune.dart';
import '../providers/home_providers.dart';
import '../widgets/dimension_arc.dart';
import '../../../transit/domain/models/daily_transit.dart';
import '../../../transit/presentation/providers/transit_providers.dart';

class FortuneDetailPage extends ConsumerStatefulWidget {
  final DailyFortune fortune;

  const FortuneDetailPage({super.key, required this.fortune});

  @override
  ConsumerState<FortuneDetailPage> createState() => _FortuneDetailPageState();
}

class _FortuneDetailPageState extends ConsumerState<FortuneDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // For weekly tab: 0 = this week, 1 = next week
  int _weekOffset = 0;

  static const _dimensionColors = [
    Color(0xFFFF6B8A), // love
    Color(0xFF6C5CE7), // career
    Color(0xFFFDCB6E), // wealth
    Color(0xFF00CEC9), // study
    Color(0xFF55EFC4), // social
    Color(0xFFFF9F43), // health
  ];

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
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');

    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Custom AppBar with tab bar
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: CosmicColors.textPrimary,
                        size: 20,
                      ),
                      onPressed: () => context.pop(),
                    ),
                    Expanded(
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: CosmicColors.primaryLight,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: CosmicColors.textPrimary,
                        unselectedLabelColor: CosmicColors.textTertiary,
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        tabs: [
                          Tab(text: isZh ? '日运' : 'Daily'),
                          Tab(text: isZh ? '周运' : 'Weekly'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48), // balance back button
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _DailyTab(
                      fortune: widget.fortune,
                      dimensionColors: _dimensionColors,
                      colorMap: _colorMap,
                      isZh: isZh,
                    ),
                    _WeeklyTab(
                      weekOffset: _weekOffset,
                      onWeekChanged: (offset) =>
                          setState(() => _weekOffset = offset),
                      dimensionColors: _dimensionColors,
                      colorMap: _colorMap,
                      isZh: isZh,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- Daily Tab ----------

class _DailyTab extends ConsumerWidget {
  final DailyFortune fortune;
  final List<Color> dimensionColors;
  final Map<String, Color> colorMap;
  final bool isZh;

  const _DailyTab({
    required this.fortune,
    required this.dimensionColors,
    required this.colorMap,
    required this.isZh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final dailyTransitAsync = ref.watch(dailyTransitsProvider(null));
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Overall score arc
          Center(
            child: _BigScoreArc(score: fortune.overallScore, isZh: isZh),
          ),
          const SizedBox(height: 24),
          // Title
          Text(
            fortune.title,
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              height: 1.4,
            ),
          ),
          // Advice / Avoid tags
          const SizedBox(height: 12),
          Row(
            children: [
              _Tag(
                label: isZh ? '宜' : 'Do',
                text: fortune.advice,
                color: const Color(0xFF55EFC4),
              ),
              const SizedBox(width: 10),
              _Tag(
                label: isZh ? '忌' : 'Avoid',
                text: fortune.avoid,
                color: const Color(0xFFFF7675),
              ),
            ],
          ),
          if (fortune.description.isNotEmpty) ...[
            const SizedBox(height: 18),
            Text(
              fortune.description,
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 15,
                height: 1.8,
              ),
            ),
          ],
          const SizedBox(height: 24),
          // Dimension scores
          _SectionTitle(text: isZh ? '各维度运势' : 'Dimension Scores'),
          const SizedBox(height: 14),
          _DimensionGrid(
            dimensions: fortune.dimensions,
            dimensionColors: dimensionColors,
          ),
          // Astro events (天象)
          if (fortune.astroEvents.isNotEmpty) ...[
            const SizedBox(height: 24),
            _SectionTitle(text: isZh ? '今日天象' : 'Celestial Events'),
            const SizedBox(height: 14),
            _AstroEventsSection(events: fortune.astroEvents, isZh: isZh),
          ],
          const SizedBox(height: 24),
          // Lucky elements
          _SectionTitle(text: isZh ? '幸运元素' : 'Lucky Elements'),
          const SizedBox(height: 14),
          _LuckyElementsVisual(
            lucky: fortune.luckyElements,
            colorMap: colorMap,
            isZh: isZh,
          ),
          // Daily transit timeline
          dailyTransitAsync.when(
            data: (scan) {
              if (scan.events.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SectionTitle(text: l10n.transitDailyTitle),
                      GestureDetector(
                        onTap: () => context.pushNamed('transits'),
                        child: Text(
                          l10n.cardShowDetails,
                          style: const TextStyle(
                            color: CosmicColors.primaryLight,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () => context.pushNamed('transits'),
                    child: _DailyTransitList(events: scan.events),
                  ),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 32),
          // AI consult entry
          _AiConsultEntry(isZh: isZh, fortuneType: 'daily'),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

// ---------- Weekly Tab ----------

class _WeeklyTab extends ConsumerWidget {
  final int weekOffset;
  final ValueChanged<int> onWeekChanged;
  final List<Color> dimensionColors;
  final Map<String, Color> colorMap;
  final bool isZh;

  const _WeeklyTab({
    required this.weekOffset,
    required this.onWeekChanged,
    required this.dimensionColors,
    required this.colorMap,
    required this.isZh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final today = DateTime(
      now.year,
      now.month,
      now.day,
    ); // date-only, stable across rebuilds
    final targetDate = today.add(Duration(days: weekOffset * 7));
    final weekFortuneAsync = ref.watch(weeklyFortuneProvider(targetDate));

    return Column(
      children: [
        // This week / Next week toggle
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            children: [
              _WeekToggleChip(
                label: isZh ? '本周' : 'This Week',
                selected: weekOffset == 0,
                onTap: () => onWeekChanged(0),
              ),
              const SizedBox(width: 10),
              _WeekToggleChip(
                label: isZh ? '下周' : 'Next Week',
                selected: weekOffset == 1,
                onTap: () => onWeekChanged(1),
              ),
            ],
          ),
        ),
        Expanded(
          child: weekFortuneAsync.when(
            data: (weekly) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Overall score
                  Center(
                    child: _BigScoreArc(score: weekly.overallScore, isZh: isZh),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    weekly.title,
                    style: const TextStyle(
                      color: CosmicColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _Tag(
                        label: isZh ? '宜' : 'Do',
                        text: weekly.advice,
                        color: const Color(0xFF55EFC4),
                      ),
                      const SizedBox(width: 10),
                      _Tag(
                        label: isZh ? '忌' : 'Avoid',
                        text: weekly.avoid,
                        color: const Color(0xFFFF7675),
                      ),
                    ],
                  ),
                  if (weekly.description.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    Text(
                      weekly.description,
                      style: const TextStyle(
                        color: CosmicColors.textSecondary,
                        fontSize: 15,
                        height: 1.8,
                      ),
                    ),
                  ],
                  // Time period breakdowns
                  if (weekly.periods.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _SectionTitle(text: isZh ? '分时段分析' : 'Period Analysis'),
                    const SizedBox(height: 14),
                    for (final period in weekly.periods) ...[
                      _PeriodCard(period: period),
                      const SizedBox(height: 12),
                    ],
                  ],
                  const SizedBox(height: 24),
                  // 6-dimension scores (including social)
                  _SectionTitle(text: isZh ? '六维运势' : 'Six Dimensions'),
                  const SizedBox(height: 14),
                  _DimensionGrid(
                    dimensions: weekly.dimensions,
                    dimensionColors: dimensionColors,
                    maxCount: 6,
                  ),
                  const SizedBox(height: 24),
                  // Lucky elements
                  _SectionTitle(text: isZh ? '幸运元素' : 'Lucky Elements'),
                  const SizedBox(height: 14),
                  _LuckyElementsVisual(
                    lucky: weekly.luckyElements,
                    colorMap: colorMap,
                    isZh: isZh,
                  ),
                  const SizedBox(height: 32),
                  // AI consult entry
                  _AiConsultEntry(isZh: isZh, fortuneType: 'weekly'),
                  const SizedBox(height: 48),
                ],
              ),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: CosmicColors.primaryLight,
              ),
            ),
            error: (err, _) => Center(
              child: Text(
                isZh ? '加载失败，请重试' : 'Load failed, please retry',
                style: const TextStyle(color: CosmicColors.textSecondary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------- Shared sub-widgets ----------

class _BigScoreArc extends StatelessWidget {
  final int score;
  final bool isZh;

  const _BigScoreArc({required this.score, required this.isZh});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(160, 160),
            painter: _LargeArcPainter(progress: score / 100.0),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score',
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isZh ? '综合指数' : 'Overall',
                style: const TextStyle(
                  color: CosmicColors.textTertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LargeArcPainter extends CustomPainter {
  final double progress;

  const _LargeArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const startAngle = 135 * math.pi / 180;
    const sweepTotal = 270 * math.pi / 180;

    final bgPaint = Paint()
      ..color = CosmicColors.surfaceHighlight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal,
      false,
      bgPaint,
    );

    final fgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [CosmicColors.primary, CosmicColors.primaryLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _LargeArcPainter old) =>
      old.progress != progress;
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: CosmicColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final String text;
  final Color color;

  const _Tag({required this.label, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(120)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _DimensionGrid extends StatelessWidget {
  final List<FortuneDimension> dimensions;
  final List<Color> dimensionColors;
  final int maxCount;

  const _DimensionGrid({
    required this.dimensions,
    required this.dimensionColors,
    this.maxCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    final count = dimensions.length.clamp(0, maxCount);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: 8,
        runSpacing: 12,
        children: [
          for (int i = 0; i < count; i++)
            DimensionArc(
              label: dimensions[i].label.isNotEmpty
                  ? dimensions[i].label
                  : dimensions[i].key,
              score: dimensions[i].score,
              color: dimensionColors[i % dimensionColors.length],
              size: count > 4 ? 64 : 72,
            ),
        ],
      ),
    );
  }
}

class _LuckyElementsVisual extends StatelessWidget {
  final LuckyElements lucky;
  final Map<String, Color> colorMap;
  final bool isZh;

  const _LuckyElementsVisual({
    required this.lucky,
    required this.colorMap,
    required this.isZh,
  });

  @override
  Widget build(BuildContext context) {
    final colorValue = colorMap[lucky.color] ?? CosmicColors.primaryLight;
    final items = [
      (
        icon: Container(
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
        label: isZh ? '幸运色' : 'Color',
        value: lucky.color,
      ),
      (
        icon: _HexNumber(number: lucky.number),
        label: isZh ? '幸运数' : 'Number',
        value: '${lucky.number}',
      ),
      (
        icon: const Icon(
          Icons.local_florist,
          color: Color(0xFFFF9FF3),
          size: 26,
        ),
        label: isZh ? '幸运花' : 'Flower',
        value: lucky.flower,
      ),
      (
        icon: const Icon(
          Icons.diamond_outlined,
          color: Color(0xFF74B9FF),
          size: 26,
        ),
        label: isZh ? '幸运石' : 'Stone',
        value: lucky.stone,
      ),
    ];

    return Row(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
              decoration: BoxDecoration(
                color: CosmicColors.surfaceElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: CosmicColors.borderGlow),
              ),
              child: Column(
                children: [
                  items[i].icon,
                  const SizedBox(height: 8),
                  Text(
                    items[i].value,
                    style: const TextStyle(
                      color: CosmicColors.primaryLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[i].label,
                    style: const TextStyle(
                      color: CosmicColors.textTertiary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _HexNumber extends StatelessWidget {
  final int number;
  const _HexNumber({required this.number});

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

class _PeriodCard extends StatelessWidget {
  final WeekPeriod period;
  const _PeriodCard({required this.period});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Score bar on the left
          _VerticalScoreBar(score: period.score),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      period.label,
                      style: const TextStyle(
                        color: CosmicColors.primaryLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${period.score}',
                      style: const TextStyle(
                        color: CosmicColors.textTertiary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  period.description,
                  style: const TextStyle(
                    color: CosmicColors.textSecondary,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalScoreBar extends StatelessWidget {
  final int score;
  const _VerticalScoreBar({required this.score});

  @override
  Widget build(BuildContext context) {
    final fraction = (score / 100.0).clamp(0.0, 1.0);
    return SizedBox(
      width: 6,
      height: 60,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(color: CosmicColors.surfaceHighlight),
            FractionallySizedBox(
              heightFactor: fraction,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C5CE7), Color(0xFFFF6B8A)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _WeekToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          gradient: selected ? CosmicColors.primaryGradient : null,
          color: selected ? null : CosmicColors.surfaceElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.transparent : CosmicColors.borderGlow,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? CosmicColors.textPrimary
                : CosmicColors.textSecondary,
            fontSize: 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ---------- Astro Events Section ----------

class _AstroEventsSection extends StatelessWidget {
  final List<AstroEvent> events;
  final bool isZh;

  const _AstroEventsSection({required this.events, required this.isZh});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < events.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  height: 1,
                  color: CosmicColors.borderGlow.withAlpha(60),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        CosmicColors.primary.withAlpha(60),
                        CosmicColors.primaryLight.withAlpha(40),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome,
                      color: CosmicColors.primaryLight,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        events[i].title,
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (events[i].description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          events[i].description,
                          style: const TextStyle(
                            color: CosmicColors.textSecondary,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ---------- AI Consult Entry ----------

class _AiConsultEntry extends StatelessWidget {
  final bool isZh;
  final String fortuneType;

  const _AiConsultEntry({required this.isZh, required this.fortuneType});

  static const _topicsZh = ['感情', '学业', '成长', '事业', '财运', '人际'];
  static const _topicsEn = [
    'Love',
    'Study',
    'Growth',
    'Career',
    'Wealth',
    'Social',
  ];

  @override
  Widget build(BuildContext context) {
    final topics = isZh ? _topicsZh : _topicsEn;
    final greeting = isZh
        ? '你好，我是星见 ✨ 今天有什么想和我聊聊的？'
        : 'Hi, I\'m Xingjian ✨ What would you like to discuss?';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CosmicColors.borderGlow),
        boxShadow: [
          BoxShadow(
            color: CosmicColors.primary.withAlpha(30),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + greeting
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: CosmicColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '✦',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  greeting,
                  style: const TextStyle(
                    color: CosmicColors.textPrimary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Topic chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: topics
                .map(
                  (topic) => _TopicChip(
                    label: topic,
                    onTap: () {
                      final message = isZh
                          ? '帮我分析一下我的$topic运势'
                          : 'Analyze my $topic fortune for me';
                      context.push(
                        '/chat?initial_message=${Uri.encodeComponent(message)}',
                      );
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _TopicChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: CosmicColors.primary.withAlpha(40),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CosmicColors.primaryLight.withAlpha(80)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: CosmicColors.primaryLight,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ---------- Daily Transit List ----------

class _DailyTransitList extends StatelessWidget {
  final List<DailyTransitEvent> events;

  const _DailyTransitList({required this.events});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        children: [
          for (int i = 0; i < events.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(
                  height: 1,
                  color: CosmicColors.borderGlow.withAlpha(60),
                ),
              ),
            _DailyTransitRow(event: events[i]),
          ],
        ],
      ),
    );
  }
}

class _DailyTransitRow extends StatelessWidget {
  final DailyTransitEvent event;

  const _DailyTransitRow({required this.event});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Time badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _typeColor.withAlpha(30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            event.time,
            style: TextStyle(
              color: _typeColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Icon
        Icon(_typeIcon, size: 16, color: _typeColor),
        const SizedBox(width: 8),
        // Title + subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (_subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  _subtitle!,
                  style: const TextStyle(
                    color: CosmicColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Color get _typeColor {
    switch (event.eventType) {
      case 'transit_aspect':
        return const Color(0xFFFFBE0B);
      case 'house_ingress':
        return const Color(0xFF3498DB);
      case 'sign_ingress':
        return const Color(0xFF9B59B6);
      default:
        return CosmicColors.primaryLight;
    }
  }

  IconData get _typeIcon {
    switch (event.eventType) {
      case 'transit_aspect':
        return Icons.auto_awesome;
      case 'house_ingress':
        return Icons.house_outlined;
      case 'sign_ingress':
        return Icons.change_circle_outlined;
      default:
        return Icons.stars;
    }
  }

  String? get _subtitle {
    switch (event.eventType) {
      case 'transit_aspect':
        return '${event.transitPlanetCn} ${event.aspectCn} ${event.natalPlanetCn}';
      case 'house_ingress':
        return '${event.transitPlanetCn} → 第${event.houseNumber}宫';
      case 'sign_ingress':
        return '${event.transitPlanetCn} → ${event.signCn} (第${event.activatedHouse}宫)';
      default:
        return null;
    }
  }
}
