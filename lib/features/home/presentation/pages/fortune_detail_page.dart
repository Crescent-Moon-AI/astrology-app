import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../domain/models/daily_fortune.dart';
import '../widgets/dimension_arc.dart';

class FortuneDetailPage extends StatelessWidget {
  final DailyFortune fortune;

  const FortuneDetailPage({super.key, required this.fortune});

  static const _dimensionColors = [
    Color(0xFFFF6B8A), // love
    Color(0xFF6C5CE7), // career
    Color(0xFFFDCB6E), // wealth
    Color(0xFF00CEC9), // study
  ];

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');

    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Custom AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
                    Text(
                      isZh ? '今日运势' : "Today's Fortune",
                      style: const TextStyle(
                        color: CosmicColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      // Large score arc centered
                      Center(
                        child: _buildBigScoreArc(fortune.overallScore, isZh),
                      ),
                      const SizedBox(height: 28),
                      // Fortune title
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
                      if (fortune.description.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        Text(
                          fortune.description,
                          style: const TextStyle(
                            color: CosmicColors.textSecondary,
                            fontSize: 15,
                            height: 1.8,
                          ),
                        ),
                      ],
                      const SizedBox(height: 28),
                      // Dimension scores
                      Text(
                        isZh ? '各维度运势' : 'Dimension Scores',
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildDimensionGrid(fortune.dimensions, isZh),
                      const SizedBox(height: 28),
                      // Lucky elements
                      Text(
                        isZh ? '幸运元素' : 'Lucky Elements',
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildLuckyElements(fortune.luckyElements, isZh),
                      const SizedBox(height: 40),
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

  Widget _buildBigScoreArc(int score, bool isZh) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(180, 180),
            painter: _LargeArcPainter(progress: score / 100.0),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score',
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isZh ? '综合指数' : 'Overall Score',
                style: const TextStyle(
                  color: CosmicColors.textTertiary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDimensionGrid(List<FortuneDimension> dims, bool isZh) {
    final labels = isZh
        ? {'love': '恋爱', 'career': '事业', 'wealth': '财富', 'study': '学业'}
        : {
            'love': 'Love',
            'career': 'Career',
            'wealth': 'Wealth',
            'study': 'Study',
          };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < dims.length && i < 4; i++)
            DimensionArc(
              label: labels[dims[i].key] ?? dims[i].key,
              score: dims[i].score,
              color: _dimensionColors[i % _dimensionColors.length],
              size: 72,
            ),
        ],
      ),
    );
  }

  Widget _buildLuckyElements(LuckyElements lucky, bool isZh) {
    final items = [
      (label: isZh ? '幸运色' : 'Color', value: lucky.color),
      (label: isZh ? '幸运数' : 'Number', value: '${lucky.number}'),
      (label: isZh ? '幸运花' : 'Flower', value: lucky.flower),
      (label: isZh ? '幸运石' : 'Stone', value: lucky.stone),
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
                  Text(
                    items[i].value,
                    style: const TextStyle(
                      color: CosmicColors.primaryLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
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

class _LargeArcPainter extends CustomPainter {
  final double progress;

  const _LargeArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const startAngle = 135 * math.pi / 180;
    const sweepTotal = 270 * math.pi / 180;

    // Background track
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

    // Progress arc with gradient
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
