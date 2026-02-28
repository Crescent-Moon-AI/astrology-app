import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/core_providers.dart';

class MoonPhase {
  final String date;
  final String phaseName;
  final double phaseAngle;
  final double illumination;
  final int lunarDay;
  final String nextFullMoon;
  final String nextNewMoon;
  final String emoji;

  const MoonPhase({
    required this.date,
    required this.phaseName,
    required this.phaseAngle,
    required this.illumination,
    required this.lunarDay,
    required this.nextFullMoon,
    required this.nextNewMoon,
    required this.emoji,
  });

  factory MoonPhase.fromJson(Map<String, dynamic> json) {
    return MoonPhase(
      date: json['date'] as String? ?? '',
      phaseName: json['phase_name'] as String? ?? '',
      phaseAngle: (json['phase_angle'] as num?)?.toDouble() ?? 0.0,
      illumination: (json['illumination'] as num?)?.toDouble() ?? 0.0,
      lunarDay: json['lunar_day'] as int? ?? 0,
      nextFullMoon: json['next_full_moon'] as String? ?? '',
      nextNewMoon: json['next_new_moon'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '',
    );
  }
}

final moonPhaseProvider = FutureProvider.autoDispose<MoonPhase>((ref) async {
  final dioClient = ref.watch(dioClientProvider);
  final today = DateTime.now().toIso8601String().substring(0, 10);
  final response = await dioClient.dio.get(
    '/api/astrology/moon-phase',
    queryParameters: {'date': today},
  );
  final data = response.data;
  // Support both { data: {...} } envelope and flat response.
  final payload =
      data is Map<String, dynamic> && data.containsKey('data')
          ? data['data'] as Map<String, dynamic>
          : data as Map<String, dynamic>;
  return MoonPhase.fromJson(payload);
});
