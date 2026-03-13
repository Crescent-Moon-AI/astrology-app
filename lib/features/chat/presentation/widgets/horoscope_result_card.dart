import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';

/// Structured display for horoscope tool results.
///
/// Shows zodiac sign, index scores as progress bars, and advice sections.
class HoroscopeResultCard extends StatelessWidget {
  final String payloadJson;

  const HoroscopeResultCard({super.key, required this.payloadJson});

  @override
  Widget build(BuildContext context) {
    final data = _parse();
    if (data == null) return const SizedBox.shrink();

    final isZh =
        Localizations.localeOf(context).languageCode.startsWith('zh');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        // Header: sign + period
        Row(
          children: [
            Text(
              isZh ? data.zodiacSign : data.zodiacSignEN,
              style: const TextStyle(
                color: CosmicColors.primaryLight,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              data.period,
              style: const TextStyle(
                color: CosmicColors.textTertiary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Score bars
        _ScoreBar(
          label: isZh ? '综合' : 'Overall',
          value: data.overallIndex,
          color: CosmicColors.primary,
        ),
        _ScoreBar(
          label: isZh ? '爱情' : 'Love',
          value: data.loveIndex,
          color: Colors.pink.shade300,
        ),
        _ScoreBar(
          label: isZh ? '事业' : 'Career',
          value: data.careerIndex,
          color: Colors.blue.shade300,
        ),
        _ScoreBar(
          label: isZh ? '财运' : 'Wealth',
          value: data.wealthIndex,
          color: Colors.amber.shade300,
        ),
        _ScoreBar(
          label: isZh ? '健康' : 'Health',
          value: data.healthIndex,
          color: Colors.green.shade300,
        ),
        const SizedBox(height: 8),
        // Lucky info
        Row(
          children: [
            Text(
              '${isZh ? "幸运数字" : "Lucky #"}: ${data.luckyNumber}',
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '${isZh ? "幸运色" : "Lucky color"}: ${data.luckyColor}',
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        // Daily tip
        if (data.dailyTip.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            data.dailyTip,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }

  _HoroscopeData? _parse() {
    try {
      final json = jsonDecode(payloadJson) as Map<String, dynamic>;
      final data = (json['data'] ?? json) as Map<String, dynamic>;
      return _HoroscopeData.fromJson(data);
    } catch (_) {
      return null;
    }
  }
}

class _ScoreBar extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _ScoreBar({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              label,
              style: const TextStyle(
                color: CosmicColors.textTertiary,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: value / 100,
                minHeight: 6,
                backgroundColor: CosmicColors.surfaceElevated,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 24,
            child: Text(
              '$value',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _HoroscopeData {
  final String zodiacSign;
  final String zodiacSignEN;
  final String period;
  final int luckyNumber;
  final String luckyColor;
  final int loveIndex;
  final int careerIndex;
  final int wealthIndex;
  final int healthIndex;
  final int overallIndex;
  final String dailyTip;

  _HoroscopeData({
    required this.zodiacSign,
    required this.zodiacSignEN,
    required this.period,
    required this.luckyNumber,
    required this.luckyColor,
    required this.loveIndex,
    required this.careerIndex,
    required this.wealthIndex,
    required this.healthIndex,
    required this.overallIndex,
    required this.dailyTip,
  });

  factory _HoroscopeData.fromJson(Map<String, dynamic> json) {
    return _HoroscopeData(
      zodiacSign: json['zodiac_sign'] as String? ?? '',
      zodiacSignEN: json['zodiac_sign_en'] as String? ?? '',
      period: json['period'] as String? ?? '',
      luckyNumber: json['lucky_number'] as int? ?? 0,
      luckyColor: json['lucky_color'] as String? ?? '',
      loveIndex: json['love_index'] as int? ?? 0,
      careerIndex: json['career_index'] as int? ?? 0,
      wealthIndex: json['wealth_index'] as int? ?? 0,
      healthIndex: json['health_index'] as int? ?? 0,
      overallIndex: json['overall_index'] as int? ?? 0,
      dailyTip: json['daily_tip'] as String? ?? '',
    );
  }
}
