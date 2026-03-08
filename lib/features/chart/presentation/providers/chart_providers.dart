import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/core/providers/core_providers.dart';
import 'package:astrology_app/features/chart/domain/models/birth_data.dart';
import 'package:astrology_app/features/chart/domain/services/chart_calculation_service.dart';
import 'package:astrology_app/features/settings/presentation/providers/profile_providers.dart';

final chartCalculationServiceProvider = Provider<ChartCalculationService>((
  ref,
) {
  final engine = ref.watch(astroEngineProvider);
  return ChartCalculationService(engine);
});

final currentBirthDataProvider = Provider<AsyncValue<BirthData?>>((ref) {
  final profileAsync = ref.watch(userProfileProvider);
  return profileAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
    data: (profile) {
      final core = profile.core;
      final place = profile.currentBirthPlace;

      if (core.birthDate == null ||
          core.birthTime == null ||
          place?.latitude == null ||
          place?.longitude == null) {
        return const AsyncValue.data(null);
      }

      final tz = _ianaToOffset(place?.timezone) ?? 8.0;

      return AsyncValue.data(
        BirthData(
          name: '',
          birthDate: core.birthDate!,
          birthTime: core.birthTime!,
          latitude: place!.latitude!,
          longitude: place.longitude!,
          timezone: tz,
          location: place.normalizedName ?? '',
        ),
      );
    },
  );
});

/// Convert common IANA timezone identifiers to UTC offset in hours.
/// Falls back to 8.0 (CST) for unrecognized zones.
double? _ianaToOffset(String? iana) {
  if (iana == null || iana.isEmpty) return null;

  // Common timezones used by the app's Chinese-first user base
  const offsets = <String, double>{
    'Asia/Shanghai': 8.0,
    'Asia/Chongqing': 8.0,
    'Asia/Hong_Kong': 8.0,
    'Asia/Taipei': 8.0,
    'Asia/Macau': 8.0,
    'Asia/Tokyo': 9.0,
    'Asia/Seoul': 9.0,
    'Asia/Singapore': 8.0,
    'Asia/Kuala_Lumpur': 8.0,
    'Asia/Bangkok': 7.0,
    'Asia/Ho_Chi_Minh': 7.0,
    'Asia/Jakarta': 7.0,
    'Asia/Kolkata': 5.5,
    'Asia/Colombo': 5.5,
    'Asia/Karachi': 5.0,
    'Asia/Dubai': 4.0,
    'Asia/Riyadh': 3.0,
    'Europe/London': 0.0,
    'Europe/Paris': 1.0,
    'Europe/Berlin': 1.0,
    'Europe/Rome': 1.0,
    'Europe/Madrid': 1.0,
    'Europe/Moscow': 3.0,
    'Europe/Istanbul': 3.0,
    'America/New_York': -5.0,
    'America/Chicago': -6.0,
    'America/Denver': -7.0,
    'America/Los_Angeles': -8.0,
    'America/Anchorage': -9.0,
    'Pacific/Honolulu': -10.0,
    'America/Toronto': -5.0,
    'America/Vancouver': -8.0,
    'America/Sao_Paulo': -3.0,
    'America/Argentina/Buenos_Aires': -3.0,
    'America/Mexico_City': -6.0,
    'Australia/Sydney': 10.0,
    'Australia/Melbourne': 10.0,
    'Australia/Perth': 8.0,
    'Pacific/Auckland': 12.0,
    'Atlantic/Reykjavik': 0.0,
    'UTC': 0.0,
    'GMT': 0.0,
  };

  return offsets[iana];
}
