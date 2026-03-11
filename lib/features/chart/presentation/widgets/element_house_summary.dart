import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/planet_data.dart';
import '../../domain/models/house_data.dart';

/// Element & House analysis sections matching the reference app's layout.
/// Reverse-engineered from com.tarot.yuejian:
///   - ElementAnalysisBean: subject, interpretation, analysis, analysisTags,
///     analysisItems (fire/water/air/earth ItemElement with score + signs),
///     partners (compatible/complementary sign lists)
///   - HouseAnalysisBean: subject, interpretation, analysis,
///     analysisItems (ItemHouseInfo with house code/subject + score)
class ElementHouseSummary extends StatelessWidget {
  final List<PlanetData> planets;
  final AnglesData angles;

  const ElementHouseSummary({
    super.key,
    required this.planets,
    required this.angles,
  });

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode == 'zh';
    final elementScores = _calcElementScores();
    final houseScores = _calcHouseScores();
    final dominantElement = _dominantKey(elementScores);
    final dominantHouse = _dominantHouseKey(houseScores);

    return Column(
      children: [
        _ElementSection(
          elementScores: elementScores,
          dominantElement: dominantElement,
          planets: planets,
          angles: angles,
          isZh: isZh,
        ),
        const SizedBox(height: 24),
        _HouseSection(
          houseScores: houseScores,
          dominantHouse: dominantHouse,
          dominantElement: dominantElement,
          isZh: isZh,
        ),
      ],
    );
  }

  /// Calculate element scores as fractions (0..1), matching the reference
  /// app's ItemElement.score field.
  Map<String, double> _calcElementScores() {
    final counts = {'fire': 0, 'earth': 0, 'air': 0, 'water': 0};
    for (final p in planets) {
      final el = _signToElement(p.sign);
      if (el != null) counts[el] = counts[el]! + 1;
    }
    final ascEl = _signToElement(angles.ascSign);
    if (ascEl != null) counts[ascEl] = counts[ascEl]! + 1;

    final total = counts.values.fold(0, (a, b) => a + b);
    if (total == 0) return {'fire': 0.25, 'earth': 0.25, 'air': 0.25, 'water': 0.25};
    return counts.map((k, v) => MapEntry(k, v / total));
  }

  /// Calculate house scores as fractions, matching HouseAnalysisBean structure.
  /// Groups houses by thematic areas as in the reference app.
  Map<int, double> _calcHouseScores() {
    final counts = <int, int>{for (var i = 1; i <= 12; i++) i: 0};
    for (final p in planets) {
      if (p.house != null && p.house! >= 1 && p.house! <= 12) {
        counts[p.house!] = counts[p.house!]! + 1;
      }
    }
    final total = counts.values.fold(0, (a, b) => a + b);
    if (total == 0) return counts.map((k, _) => MapEntry(k, 0.0));
    return counts.map((k, v) => MapEntry(k, v / total));
  }

  String _dominantKey(Map<String, double> m) =>
      m.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

  int _dominantHouseKey(Map<int, double> m) =>
      m.entries.where((e) => e.value > 0).fold(
        m.entries.first,
        (a, b) => b.value > a.value ? b : a,
      ).key;

  static String? _signToElement(String sign) => switch (sign) {
        'Aries' || 'Leo' || 'Sagittarius' => 'fire',
        'Taurus' || 'Virgo' || 'Capricorn' => 'earth',
        'Gemini' || 'Libra' || 'Aquarius' => 'air',
        'Cancer' || 'Scorpio' || 'Pisces' => 'water',
        _ => null,
      };
}

// ── Element colors matching reference app's color scheme ──
// Fire: #FED8D8 / #AD2929,  Water: #B6DAFF / #2964AD
// Air:  #A3FFF4 / #54C8BA,  Earth: #FDD5A7 / #CA8743

Color _elColorLight(String el) => switch (el) {
      'fire' => const Color(0xFFFED8D8),
      'water' => const Color(0xFFB6DAFF),
      'air' => const Color(0xFFA3FFF4),
      'earth' => const Color(0xFFFDD5A7),
      _ => const Color(0xFFCCCCCC),
    };

Color _elColorDark(String el) => switch (el) {
      'fire' => const Color(0xFFAD2929),
      'water' => const Color(0xFF2964AD),
      'air' => const Color(0xFF54C8BA),
      'earth' => const Color(0xFFCA8743),
      _ => const Color(0xFF666666),
    };

String _elNameZh(String el) => switch (el) {
      'fire' => '火',
      'water' => '水',
      'air' => '风',
      'earth' => '土',
      _ => '',
    };

String _elNameEn(String el) => switch (el) {
      'fire' => 'Fire',
      'water' => 'Water',
      'air' => 'Air',
      'earth' => 'Earth',
      _ => '',
    };

String _elNameFullZh(String el) => switch (el) {
      'fire' => '火象',
      'water' => '水象',
      'air' => '风象',
      'earth' => '土象',
      _ => '',
    };

// ─────────────────────────────────────────────────
//  Element Section  (火象人)
//  Matches reference: item_star_middle1 layout
// ─────────────────────────────────────────────────
class _ElementSection extends StatelessWidget {
  final Map<String, double> elementScores;
  final String dominantElement;
  final List<PlanetData> planets;
  final AnglesData angles;
  final bool isZh;

  const _ElementSection({
    required this.elementScores,
    required this.dominantElement,
    required this.planets,
    required this.angles,
    required this.isZh,
  });

  @override
  Widget build(BuildContext context) {
    // Sort elements by score descending (matching reference: Comparator in o.b)
    final sorted = elementScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final titleColor = _elColorLight(dominantElement);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CosmicColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Ring chart + element percentage list ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ring chart (matches rmv.setCircleItems in reference)
              SizedBox(
                width: 130,
                height: 130,
                child: CustomPaint(
                  painter: _ElementRingPainter(
                    elementScores: elementScores,
                    dominantElement: dominantElement,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Element percentage list (matches elementRecyclerView)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < sorted.length; i++) ...[
                      _ElementRow(
                        code: sorted[i].key,
                        score: sorted[i].value,
                        isZh: isZh,
                      ),
                      if (i < sorted.length - 1) const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Title: "火象人" (gradient text in reference) ──
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [titleColor, const Color(0xFFF5F5F5)],
            ).createShader(bounds),
            child: Text(
              isZh
                  ? '${_elNameFullZh(dominantElement)}人'
                  : '${_elNameEn(dominantElement)} Person',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 4),

          // ── Subtitle (interpretation field) ──
          Text(
            _elInterpretation(dominantElement, isZh),
            style: const TextStyle(
              color: CosmicColors.textTertiary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),

          // ── Description (analysis field) ──
          Text(
            _elAnalysis(dominantElement, isZh),
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 14,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 16),

          // ── Trait tags (analysisTags field) ──
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _elTags(dominantElement, isZh)
                .map((t) => _TagChip(label: t))
                .toList(),
          ),
          const SizedBox(height: 16),

          // ── Compatible & complementary signs (partners field) ──
          _PartnersSection(
            dominantElement: dominantElement,
            isZh: isZh,
          ),

          const SizedBox(height: 16),
          // ── Footer link (externalLink field) ──
          Row(
            children: [
              Expanded(
                child: Text(
                  isZh ? '查看深度解读' : 'View deep reading',
                  style: const TextStyle(
                    color: CosmicColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: CosmicColors.textTertiary,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
//  House Section  (X宫人)
//  Matches reference: item_star_middle2 layout
// ─────────────────────────────────────────────────
class _HouseSection extends StatelessWidget {
  final Map<int, double> houseScores;
  final int dominantHouse;
  final String dominantElement;
  final bool isZh;

  const _HouseSection({
    required this.houseScores,
    required this.dominantHouse,
    required this.dominantElement,
    required this.isZh,
  });

  @override
  Widget build(BuildContext context) {
    // Group houses by thematic area for display list
    // Reference app shows ItemHouseInfo list with house.subject + score
    final houseItems = houseScores.entries
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final titleColor = _elColorLight(dominantElement);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CosmicColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Ring chart + house percentage list ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // House ring chart (matches rmv in reference with 12 segments)
              SizedBox(
                width: 130,
                height: 130,
                child: CustomPaint(
                  painter: _HouseRingPainter(
                    houseScores: houseScores,
                    dominantElement: dominantElement,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // House item list (matches elementRecyclerView in middle2)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < houseItems.length && i < 4; i++) ...[
                      _HouseRow(
                        house: houseItems[i].key,
                        score: houseItems[i].value,
                        dominantElement: dominantElement,
                        isZh: isZh,
                      ),
                      if (i < min(houseItems.length, 4) - 1)
                        const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Title: "10宫人" (gradient text) ──
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [titleColor, const Color(0xFFF5F5F5)],
            ).createShader(bounds),
            child: Text(
              isZh ? '$dominantHouse宫人' : 'House $dominantHouse Person',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 4),

          // ── Subtitle (interpretation) ──
          Text(
            _houseInterpretation(dominantHouse, isZh),
            style: const TextStyle(
              color: CosmicColors.textTertiary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),

          // ── Description (analysis) ──
          Text(
            _houseAnalysis(dominantHouse, isZh),
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 14,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 16),

          // ── Footer link ──
          Row(
            children: [
              Expanded(
                child: Text(
                  isZh ? '查看深度解读' : 'View deep reading',
                  style: const TextStyle(
                    color: CosmicColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: CosmicColors.textTertiary,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
//  Ring Chart Painters
//  Reference: DLRoundMenuViewNum with CircleItem
// ─────────────────────────────────────────────────

class _ElementRingPainter extends CustomPainter {
  final Map<String, double> elementScores;
  final String dominantElement;

  _ElementRingPainter({
    required this.elementScores,
    required this.dominantElement,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = min(size.width, size.height) / 2 - 2;
    const strokeWidth = 14.0;
    const gapAngle = 0.06; // gap between segments

    // Order matches reference: air, fire, water, earth
    final order = ['air', 'fire', 'water', 'earth'];

    // Background ring
    canvas.drawCircle(
      center,
      outerRadius,
      Paint()
        ..color = const Color(0xFF1A1A2E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    double startAngle = -pi / 2;

    for (final el in order) {
      final score = elementScores[el] ?? 0;
      if (score <= 0) continue;

      final sweep = score * 2 * pi - gapAngle;
      if (sweep <= 0) continue;

      // Gradient paint from light to dark (matching reference gradient arrays)
      final lightColor = _elColorLight(el);
      final darkColor = _elColorDark(el);

      final rect = Rect.fromCircle(center: center, radius: outerRadius);
      final startRad = startAngle + gapAngle / 2;

      final paint = Paint()
        ..shader = SweepGradient(
          center: Alignment.center,
          startAngle: startRad,
          endAngle: startRad + sweep,
          colors: [lightColor, darkColor],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startRad, sweep, false, paint);

      // Draw label at midpoint of arc (matching reference: "火", "水", "风", "土")
      final midAngle = startRad + sweep / 2;
      final labelRadius = outerRadius;
      final lx = center.dx + labelRadius * cos(midAngle);
      final ly = center.dy + labelRadius * sin(midAngle);

      final label = _elNameZh(el);
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: lightColor,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(lx - tp.width / 2, ly - tp.height / 2));

      startAngle += score * 2 * pi;
    }

    // Draw center element symbol with size based on D0() mapping
    final dominantScore = elementScores[dominantElement] ?? 0;
    final centerSize = _diameterForScore((dominantScore * 100).toInt());
    final centerColor = _elColorLight(dominantElement);

    // Inner glow circle
    canvas.drawCircle(
      center,
      centerSize / 2,
      Paint()
        ..color = centerColor.withAlpha(20)
        ..style = PaintingStyle.fill,
    );

    // Center label
    final centerLabel = _elNameZh(dominantElement);
    final centerTp = TextPainter(
      text: TextSpan(
        text: centerLabel,
        style: TextStyle(
          color: centerColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    centerTp.paint(
      canvas,
      Offset(center.dx - centerTp.width / 2, center.dy - centerTp.height / 2),
    );
  }

  // Matches the D0() method in the reference adapter
  double _diameterForScore(int pct) {
    if (pct == 0) return 20;
    if (pct < 21) return 25;
    if (pct < 41) return 30;
    if (pct < 61) return 35;
    if (pct < 81) return 40;
    if (pct < 100) return 45;
    return 50;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _HouseRingPainter extends CustomPainter {
  final Map<int, double> houseScores;
  final String dominantElement;

  _HouseRingPainter({
    required this.houseScores,
    required this.dominantElement,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = min(size.width, size.height) / 2 - 2;
    const strokeWidth = 14.0;
    const segmentAngle = 2 * pi / 12;
    const gap = 0.04;

    // Draw background ring
    canvas.drawCircle(
      center,
      outerRadius,
      Paint()
        ..color = const Color(0xFF1A1A2E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Draw 12 segments, highlight those with planets
    // Colors match reference: selectBgColorMap and selectStrokeColorMap
    final lightColor = _elColorLight(dominantElement);
    final darkColor = _elColorDark(dominantElement);

    for (var h = 1; h <= 12; h++) {
      final score = houseScores[h] ?? 0;
      if (score <= 0) continue;

      final startAngle = -pi / 2 + (h - 1) * segmentAngle + gap / 2;
      final sweep = segmentAngle - gap;

      // Gradient stroke matching reference element-based coloring
      final rect = Rect.fromCircle(center: center, radius: outerRadius);
      final paint = Paint()
        ..shader = SweepGradient(
          center: Alignment.center,
          startAngle: startAngle,
          endAngle: startAngle + sweep,
          colors: [lightColor.withAlpha(0), lightColor.withAlpha(153)],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngle, sweep, false, paint);

      // Fill background for selected segment
      final bgPaint = Paint()
        ..shader = SweepGradient(
          center: Alignment.center,
          startAngle: startAngle,
          endAngle: startAngle + sweep,
          colors: [darkColor.withAlpha(200), darkColor],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth - 4;

      canvas.drawArc(rect, startAngle, sweep, false, bgPaint);

      // House number label
      final midAngle = startAngle + sweep / 2;
      final labelR = outerRadius;
      final lx = center.dx + labelR * cos(midAngle);
      final ly = center.dy + labelR * sin(midAngle);

      final tp = TextPainter(
        text: TextSpan(
          text: '$h',
          style: TextStyle(
            color: lightColor,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(lx - tp.width / 2, ly - tp.height / 2));
    }

    // Center: dominant house number
    final dominantHouse = houseScores.entries
        .where((e) => e.value > 0)
        .fold(
          houseScores.entries.first,
          (a, b) => b.value > a.value ? b : a,
        )
        .key;

    final centerTp = TextPainter(
      text: TextSpan(
        text: '$dominantHouse',
        style: TextStyle(
          color: lightColor,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    centerTp.paint(
      canvas,
      Offset(center.dx - centerTp.width / 2, center.dy - centerTp.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ─────────────────────────────────────────────────
//  Sub-widgets matching reference layouts
// ─────────────────────────────────────────────────

/// Element row: icon + name + percentage
/// Matches item_element_layout: ivIcon, tvElement, tvElementRatio
class _ElementRow extends StatelessWidget {
  final String code;
  final double score;
  final bool isZh;

  const _ElementRow({
    required this.code,
    required this.score,
    required this.isZh,
  });

  @override
  Widget build(BuildContext context) {
    final color = _elColorLight(code);
    final pctStr = '${(score * 100).round()}%';

    return Row(
      children: [
        // Element icon (ivIcon in reference)
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                _elColorLight(code).withAlpha(60),
                _elColorDark(code).withAlpha(40),
              ],
            ),
          ),
          child: Center(
            child: Text(
              _elNameZh(code),
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Element name (tvElement)
        Text(
          isZh ? _elNameFullZh(code) : _elNameEn(code),
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        // Percentage (tvElementRatio)
        Text(
          pctStr,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// House row: percentage + house subject
/// Matches item_house_layout: tvHouseRatio, tvTitle
class _HouseRow extends StatelessWidget {
  final int house;
  final double score;
  final String dominantElement;
  final bool isZh;

  const _HouseRow({
    required this.house,
    required this.score,
    required this.dominantElement,
    required this.isZh,
  });

  @override
  Widget build(BuildContext context) {
    final color = _elColorLight(dominantElement);
    final pctStr = '${(score * 100).round()}%';
    final subject = isZh ? _houseSubjectZh(house) : _houseSubjectEn(house);

    return Row(
      children: [
        SizedBox(
          width: 42,
          child: Text(
            pctStr,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            subject,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

/// Tag chip for analysisTags
/// Matches item_tag_layout: tvTag
class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x33FFFFFF)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: CosmicColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Partners section (compatible + complementary)
/// Matches reference: tvGoodMatchTitle/Value, tvComplementaryMatchTitle/Value
class _PartnersSection extends StatelessWidget {
  final String dominantElement;
  final bool isZh;

  const _PartnersSection({
    required this.dominantElement,
    required this.isZh,
  });

  @override
  Widget build(BuildContext context) {
    final compatible = _compatSigns(dominantElement);
    final complementary = _complSigns(dominantElement);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SignListRow(
          title: isZh ? '同频搭子' : 'Compatible',
          signs: compatible,
          isZh: isZh,
        ),
        const SizedBox(height: 10),
        _SignListRow(
          title: isZh ? '互补搭子' : 'Complementary',
          signs: complementary,
          isZh: isZh,
        ),
      ],
    );
  }
}

/// Row showing partner type + 3 sign chips
/// Matches: tvGoodMatchTitle + tvGoodMatchValue1..3
class _SignListRow extends StatelessWidget {
  final String title;
  final List<String> signs;
  final bool isZh;

  const _SignListRow({
    required this.title,
    required this.signs,
    required this.isZh,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            title,
            style: const TextStyle(
              color: CosmicColors.textTertiary,
              fontSize: 12,
            ),
          ),
        ),
        ...signs.map(
          (s) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0x22FFFFFF)),
              ),
              child: Text(
                isZh ? _signNameZh(s) : s,
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────
//  Data helpers
// ─────────────────────────────────────────────────

String _elInterpretation(String el, bool isZh) {
  if (!isZh) {
    return switch (el) {
      'fire' => 'Fire energy dominant — passionate and action-driven',
      'earth' => 'Earth energy dominant — practical and grounded',
      'air' => 'Air energy dominant — intellectual and communicative',
      'water' => 'Water energy dominant — intuitive and empathetic',
      _ => '',
    };
  }
  return switch (el) {
    'fire' => '火象能量主导 — 热情洋溢，行动力强',
    'earth' => '土象能量主导 — 务实稳重，脚踏实地',
    'air' => '风象能量主导 — 思维活跃，善于沟通',
    'water' => '水象能量主导 — 直觉敏锐，情感丰富',
    _ => '',
  };
}

String _elAnalysis(String el, bool isZh) {
  if (!isZh) {
    return switch (el) {
      'fire' =>
        'Your chart is dominated by fire energy. You are naturally passionate and enthusiastic, quick to act on ideas. Among others you are often the first to take action, energetic and driven. Slowing down occasionally leads to better decisions.',
      'earth' =>
        'Your chart is dominated by earth energy. You are practical and steady, preferring a solid foundation before acting. You value security and material stability, approaching life with patience and persistence.',
      'air' =>
        'Your chart is dominated by air energy. You are an excellent communicator and thinker, constantly exchanging ideas and building connections. Your mind is active and curious, always seeking to understand.',
      'water' =>
        'Your chart is dominated by water energy. You are deeply intuitive and emotionally perceptive, often sensing what others feel before they express it. You have a rich inner world and strong empathy.',
      _ => '',
    };
  }
  return switch (el) {
    'fire' =>
      '你的星盘火象能量占主导，天生热情充沛，想到什么就会立刻去做。不喜欢等待和犹豫，遇到新鲜事物总想试一试。在人群中往往是最先行动的那个，精力旺盛。偶尔会因为太着急而冲动决定，放慢一点会更稳。',
    'earth' =>
      '你的星盘土象能量占主导，务实稳重是你的底色。你喜欢有计划地行动，重视物质安全和稳定的生活基础。脚踏实地是你的信条，虽然不急于表现，但每一步都走得很扎实。',
    'air' =>
      '你的星盘风象能量占主导，思维活跃、善于沟通是你的天赋。你喜欢交流想法、结识不同的人。好奇心驱动着你不断学习和探索，信息的流通让你感到活力满满。',
    'water' =>
      '你的星盘水象能量占主导，直觉敏锐、情感丰富是你的核心特质。你常常能感受到他人未说出口的情绪，拥有丰富的内心世界和强大的共情能力。',
    _ => '',
  };
}

List<String> _elTags(String el, bool isZh) {
  if (!isZh) {
    return switch (el) {
      'fire' => ['Action-oriented', 'Passionate', 'Adventurous'],
      'earth' => ['Practical', 'Persistent', 'Reliable'],
      'air' => ['Communicative', 'Intellectual', 'Social'],
      'water' => ['Intuitive', 'Empathetic', 'Imaginative'],
      _ => [],
    };
  }
  return switch (el) {
    'fire' => ['行动力强', '热情洋溢', '勇于冒险'],
    'earth' => ['务实可靠', '坚持不懈', '稳重踏实'],
    'air' => ['善于沟通', '思维敏捷', '社交达人'],
    'water' => ['直觉敏锐', '情感丰富', '想象力强'],
    _ => [],
  };
}

List<String> _compatSigns(String el) => switch (el) {
      'fire' => ['Leo', 'Sagittarius', 'Aries'],
      'earth' => ['Virgo', 'Capricorn', 'Taurus'],
      'air' => ['Libra', 'Aquarius', 'Gemini'],
      'water' => ['Scorpio', 'Pisces', 'Cancer'],
      _ => [],
    };

List<String> _complSigns(String el) => switch (el) {
      'fire' => ['Libra', 'Aquarius', 'Gemini'],
      'earth' => ['Cancer', 'Scorpio', 'Pisces'],
      'air' => ['Aries', 'Leo', 'Sagittarius'],
      'water' => ['Taurus', 'Virgo', 'Capricorn'],
      _ => [],
    };

String _signNameZh(String sign) => switch (sign) {
      'Aries' => '白羊座',
      'Taurus' => '金牛座',
      'Gemini' => '双子座',
      'Cancer' => '巨蟹座',
      'Leo' => '狮子座',
      'Virgo' => '处女座',
      'Libra' => '天秤座',
      'Scorpio' => '天蝎座',
      'Sagittarius' => '射手座',
      'Capricorn' => '摩羯座',
      'Aquarius' => '水瓶座',
      'Pisces' => '双鱼座',
      _ => sign,
    };

String _houseSubjectZh(int h) => switch (h) {
      1 => '自我·形象',
      2 => '财富·价值',
      3 => '沟通·学习',
      4 => '家庭·根基',
      5 => '创造·恋爱',
      6 => '工作·健康',
      7 => '合作·伙伴',
      8 => '深度·转化',
      9 => '哲学·远行',
      10 => '事业·成就',
      11 => '社群·理想',
      12 => '灵性·隐秘',
      _ => '',
    };

String _houseSubjectEn(int h) => switch (h) {
      1 => 'Self & Image',
      2 => 'Wealth & Values',
      3 => 'Communication',
      4 => 'Home & Roots',
      5 => 'Creativity & Love',
      6 => 'Work & Health',
      7 => 'Partnership',
      8 => 'Transformation',
      9 => 'Philosophy & Travel',
      10 => 'Career & Status',
      11 => 'Community & Ideals',
      12 => 'Spirituality',
      _ => '',
    };

String _houseInterpretation(int h, bool isZh) {
  if (!isZh) {
    return 'House $h energy dominant — ${_houseSubjectEn(h)}';
  }
  return '$h宫能量主导 — ${_houseSubjectZh(h)}';
}

String _houseAnalysis(int h, bool isZh) {
  if (!isZh) {
    return switch (h) {
      1 =>
        'Your chart energy concentrates in the 1st house. You naturally focus on self-expression and identity. Your personality is your strongest asset, and you make strong first impressions.',
      2 =>
        'Your chart energy concentrates in the 2nd house. You are naturally drawn to building material security and understanding your own values.',
      3 =>
        'Your chart energy concentrates in the 3rd house. Communication and learning are your strengths. You thrive in environments with idea exchange.',
      4 =>
        'Your chart energy concentrates in the 4th house. Home and family are central. You find strength in your roots and private space.',
      5 =>
        'Your chart energy concentrates in the 5th house. Creativity, romance and self-expression bring you joy. You have a natural flair for the dramatic.',
      6 =>
        'Your chart energy concentrates in the 6th house. You find fulfillment in daily routines, work and health practices. Service matters deeply.',
      7 =>
        'Your chart energy concentrates in the 7th house. Partnerships are where you grow most. You learn about yourself through others.',
      8 =>
        'Your chart energy concentrates in the 8th house. You are drawn to life\'s deeper mysteries. Transformation and shared resources are key themes.',
      9 =>
        'Your chart energy concentrates in the 9th house. Philosophy, travel and higher learning expand your horizons. You seek meaning in the big picture.',
      10 =>
        'Your chart energy concentrates in the 10th house. Career and public standing matter deeply. You are driven to achieve recognition and leave your mark.',
      11 =>
        'Your chart energy concentrates in the 11th house. Community, friendships and collective ideals inspire you. You thrive in group settings.',
      12 =>
        'Your chart energy concentrates in the 12th house. Spirituality and the subconscious guide you. You have rich inner resources and deep compassion.',
      _ => '',
    };
  }
  return switch (h) {
    1 =>
      '你的星盘能量集中在1宫，在意自我表达和个人形象。个性鲜明是你最大的特点，给人留下深刻的第一印象。人生课题是找到真实的自己。',
    2 =>
      '你的星盘能量集中在2宫，在意财富积累和自我价值。物质安全感对你很重要，你善于发现和创造价值。',
    3 =>
      '你的星盘能量集中在3宫，在意沟通学习和信息交流。你在需要表达和交流的环境中如鱼得水。',
    4 =>
      '你的星盘能量集中在4宫，在意家庭根基和内在安全。家是你力量的源泉，你需要一个安稳的私密空间。',
    5 =>
      '你的星盘能量集中在5宫，在意创造表达和恋爱体验。你天生具有戏剧性的魅力，享受生活中的乐趣。',
    6 =>
      '你的星盘能量集中在6宫，在意工作效率和健康管理。你在日常事务的优化中找到成就感，服务他人让你充实。',
    7 =>
      '你的星盘能量集中在7宫，在意合作关系和人际互动。你在亲密关系中成长最多，通过他人了解自己。',
    8 =>
      '你的星盘能量集中在8宫，在意深度探索和内在转化。你对生命的深层奥秘有天然的好奇，善于在危机中成长。',
    9 =>
      '你的星盘能量集中在9宫，在意哲学思考和远方探索。你渴望在更广阔的视野中寻找人生意义。',
    10 =>
      '你的星盘10宫能量比较集中，在意自己在社会中取得的位置和成就。有事业心，愿意为长远目标付出努力，也希望得到外界的认可和尊重。人生课题是找到想要追求的方向，在社会中实现自己的价值。',
    11 =>
      '你的星盘能量集中在11宫，在意社群归属和理想追求。你在集体中找到归属感，友谊和共同愿景给你力量。',
    12 =>
      '你的星盘能量集中在12宫，在意灵性成长和内在世界。你拥有丰富的内在资源和深沉的慈悲心。',
    _ => '',
  };
}
