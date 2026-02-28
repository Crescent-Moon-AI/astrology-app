import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/mood_stats.dart';
import '../providers/mood_providers.dart';

class MoodTrendChart extends ConsumerStatefulWidget {
  const MoodTrendChart({super.key});

  @override
  ConsumerState<MoodTrendChart> createState() => _MoodTrendChartState();
}

class _MoodTrendChartState extends ConsumerState<MoodTrendChart> {
  String _selectedPeriod = '30d';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statsAsync = ref.watch(moodStatsProvider(_selectedPeriod));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Period selector
        Row(
          children: [
            _PeriodButton(
              label: '30d',
              isSelected: _selectedPeriod == '30d',
              onTap: () => setState(() => _selectedPeriod = '30d'),
            ),
            const SizedBox(width: 8),
            _PeriodButton(
              label: '90d',
              isSelected: _selectedPeriod == '90d',
              onTap: () => setState(() => _selectedPeriod = '90d'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Chart
        SizedBox(
          height: 200,
          child: statsAsync.when(
            data: (stats) => _buildChart(context, stats),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Text(
                'Error: $error',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChart(BuildContext context, MoodStats stats) {
    if (stats.dailyAverages.isEmpty) {
      return Center(
        child: Text(
          'No data yet',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }

    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _TrendChartPainter(
        dailyAverages: stats.dailyAverages,
        lineColor: Theme.of(context).colorScheme.primary,
        gridColor: Theme.of(context).colorScheme.outlineVariant,
        textColor: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  final Map<String, double> dailyAverages;
  final Color lineColor;
  final Color gridColor;
  final Color textColor;

  _TrendChartPainter({
    required this.dailyAverages,
    required this.lineColor,
    required this.gridColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dailyAverages.isEmpty) return;

    final sortedKeys = dailyAverages.keys.toList()..sort();
    final values = sortedKeys.map((k) => dailyAverages[k]!).toList();

    const paddingLeft = 30.0;
    const paddingBottom = 24.0;
    const paddingTop = 8.0;
    const paddingRight = 8.0;

    final chartWidth = size.width - paddingLeft - paddingRight;
    final chartHeight = size.height - paddingTop - paddingBottom;

    // Draw grid lines for scores 1-5
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (var i = 1; i <= 5; i++) {
      final y = paddingTop + chartHeight - ((i - 1) / 4) * chartHeight;
      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        gridPaint,
      );

      textPainter.text = TextSpan(
        text: '$i',
        style: TextStyle(color: textColor, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(paddingLeft - textPainter.width - 4, y - textPainter.height / 2),
      );
    }

    if (values.length < 2) {
      // Single point
      final x = paddingLeft + chartWidth / 2;
      final y =
          paddingTop + chartHeight - ((values[0] - 1) / 4) * chartHeight;
      final dotPaint = Paint()..color = lineColor;
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
      return;
    }

    // Build points
    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = paddingLeft + (i / (values.length - 1)) * chartWidth;
      final y =
          paddingTop + chartHeight - ((values[i] - 1) / 4) * chartHeight;
      points.add(Offset(x, y));
    }

    // Draw smooth curve using cubic Bezier
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (var i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = i + 2 < points.length ? points[i + 2] : points[i + 1];

      final cp1x = p1.dx + (p2.dx - p0.dx) / 6;
      final cp1y = p1.dy + (p2.dy - p0.dy) / 6;
      final cp2x = p2.dx - (p3.dx - p1.dx) / 6;
      final cp2y = p2.dy - (p3.dy - p1.dy) / 6;

      path.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
    }

    // Draw line
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    // Draw fill under curve
    final fillPath = Path.from(path);
    fillPath.lineTo(points.last.dx, paddingTop + chartHeight);
    fillPath.lineTo(points.first.dx, paddingTop + chartHeight);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [lineColor.withValues(alpha: 0.3), lineColor.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, paddingTop, size.width, chartHeight));
    canvas.drawPath(fillPath, fillPaint);

    // Draw dots
    final dotPaint = Paint()..color = lineColor;
    final dotBorderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Only draw dots if not too many points
    if (points.length <= 31) {
      for (final point in points) {
        canvas.drawCircle(point, 3.5, dotPaint);
        canvas.drawCircle(point, 3.5, dotBorderPaint);
      }
    }

    // X-axis date labels (show first, middle, last)
    final labelIndices = [0, sortedKeys.length ~/ 2, sortedKeys.length - 1];
    for (final idx in labelIndices.toSet()) {
      if (idx >= sortedKeys.length) continue;
      final dateStr = sortedKeys[idx];
      // Show MM-DD
      final shortDate = dateStr.substring(5);
      textPainter.text = TextSpan(
        text: shortDate,
        style: TextStyle(color: textColor, fontSize: 10),
      );
      textPainter.layout();
      final x = paddingLeft + (idx / math.max(1, sortedKeys.length - 1)) * chartWidth;
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - textPainter.height),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter oldDelegate) {
    return dailyAverages != oldDelegate.dailyAverages ||
        lineColor != oldDelegate.lineColor;
  }
}
