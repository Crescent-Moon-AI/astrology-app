import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/src/rust/api/api/astro.dart' as astro_ffi;
import '../../../../core/providers/core_providers.dart';
import '../../../settings/presentation/providers/profile_providers.dart';
import '../../data/datasources/transit_api.dart';
import '../../data/repositories/transit_repository_impl.dart';
import '../../domain/models/daily_transit.dart';
import '../../domain/models/user_transit_alert.dart';
import '../../domain/repositories/transit_repository.dart';

// API data source
final transitApiProvider = Provider<TransitApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return TransitApi(dioClient.dio);
});

// Repository
final transitRepositoryProvider = Provider<TransitRepository>((ref) {
  final api = ref.watch(transitApiProvider);
  return TransitRepositoryImpl(api);
});

// Active transits
final activeTransitsProvider = FutureProvider<List<UserTransitAlert>>((
  ref,
) async {
  final repo = ref.watch(transitRepositoryProvider);
  return repo.getActiveTransits();
});

// Upcoming transits (parameterized by days)
final upcomingTransitsProvider =
    FutureProvider.family<List<UserTransitAlert>, int>((ref, days) async {
      final repo = ref.watch(transitRepositoryProvider);
      return repo.getUpcomingTransits(days: days);
    });

// Single transit detail
final transitDetailProvider = FutureProvider.family<UserTransitAlert, String>((
  ref,
  id,
) async {
  final repo = ref.watch(transitRepositoryProvider);
  return repo.getTransitDetail(id);
});

// Daily transit scan (parameterized by date string, null = today)
final dailyTransitsProvider = FutureProvider.family<DailyTransitScan, String?>((
  ref,
  date,
) async {
  final repo = ref.watch(transitRepositoryProvider);
  return repo.getDailyTransits(date: date);
});

// Sky aspects scan (parameterized by date string, null = today)
final skyAspectsProvider = FutureProvider.family<DailyTransitScan, String?>((
  ref,
  date,
) async {
  final repo = ref.watch(transitRepositoryProvider);
  return repo.getSkyAspects(date: date);
});

// Tab index for transit/sky toggle (0=行运, 1=天象)
class TransitTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void set(int index) => state = index;
}

final transitTabIndexProvider = NotifierProvider<TransitTabNotifier, int>(
  TransitTabNotifier.new,
);

// Calendar events (parameterized by year+month)
final calendarEventsProvider =
    FutureProvider.family<CalendarData, ({int year, int month})>((
      ref,
      params,
    ) async {
      final repo = ref.watch(transitRepositoryProvider);
      return repo.getCalendarEvents(params.year, params.month);
    });

// ---------- Local FFI providers (no backend call) ----------

double _ianaToOffset(String? timezoneId) {
  if (timezoneId == null) return 8.0;
  if (timezoneId.startsWith('Asia/Shanghai') ||
      timezoneId.startsWith('Asia/Beijing') ||
      timezoneId.startsWith('Asia/Chongqing') ||
      timezoneId.startsWith('Asia/Urumqi') ||
      timezoneId.startsWith('PRC') ||
      timezoneId.startsWith('Asia/Hong_Kong') ||
      timezoneId.startsWith('Asia/Taipei')) {
    return 8.0;
  }
  if (timezoneId.startsWith('Asia/Tokyo') || timezoneId.startsWith('Japan')) {
    return 9.0;
  }
  if (timezoneId.startsWith('America/New_York') ||
      timezoneId.startsWith('US/Eastern')) {
    return -5.0;
  }
  if (timezoneId.startsWith('America/Los_Angeles') ||
      timezoneId.startsWith('US/Pacific')) {
    return -8.0;
  }
  if (timezoneId.startsWith('Europe/London') ||
      timezoneId.startsWith('UTC') ||
      timezoneId.startsWith('GMT')) {
    return 0.0;
  }
  return 8.0; // default CST
}

/// Local daily transit scan using Rust FFI (행운).
/// Requires birth data; returns empty scan if unavailable.
final localDailyTransitsProvider =
    FutureProvider.family<DailyTransitScan, String>((ref, dateStr) async {
      final profile = await ref.watch(userProfileProvider.future);
      final core = profile.core;
      if (core.birthDate == null || core.birthDate!.isEmpty) {
        return DailyTransitScan(scanDate: dateStr, events: []);
      }
      final place = profile.currentBirthPlace;
      final tz = _ianaToOffset(place?.timezone);
      final input = {
        'birth_date': core.birthDate!.substring(0, 10),
        'birth_time': core.birthTime ?? '12:00',
        'latitude': place?.latitude ?? 0.0,
        'longitude': place?.longitude ?? 0.0,
        'timezone': tz,
        if (place?.timezone != null) 'timezone_id': place!.timezone,
        'house_system': 'Placidus',
        'scan_date': dateStr,
      };
      final result = await astro_ffi.scanTransitEventsJson(
        inputJson: jsonEncode(input),
      );
      return DailyTransitScan.fromJson(
        jsonDecode(result) as Map<String, dynamic>,
      );
    });

/// Local sky aspects scan using Rust FFI (星象, universal, no birth data).
final localSkyAspectsProvider = FutureProvider.family<DailyTransitScan, String>(
  (ref, dateStr) async {
    final profile = await ref.watch(userProfileProvider.future);
    final tz = _ianaToOffset(profile.currentBirthPlace?.timezone);
    final input = {
      'scan_date': dateStr,
      'timezone': tz,
      if (profile.currentBirthPlace?.timezone != null)
        'timezone_id': profile.currentBirthPlace!.timezone,
    };
    final result = await astro_ffi.scanSkyAspectsJson(
      inputJson: jsonEncode(input),
    );
    return DailyTransitScan.fromJson(
      jsonDecode(result) as Map<String, dynamic>,
    );
  },
);

/// Local upcoming transits using Rust FFI range scan.
/// Scans `days` days starting from tomorrow, returns all events (flat list).
final localUpcomingTransitsProvider =
    FutureProvider.family<List<DailyTransitEvent>, int>((ref, days) async {
      final profile = await ref.watch(userProfileProvider.future);
      final core = profile.core;
      if (core.birthDate == null || core.birthDate!.isEmpty) {
        return [];
      }
      final place = profile.currentBirthPlace;
      final tz = _ianaToOffset(place?.timezone);

      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final startDate =
          '${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}';

      final input = {
        'birth_date': core.birthDate!.substring(0, 10),
        'birth_time': core.birthTime ?? '12:00',
        'latitude': place?.latitude ?? 0.0,
        'longitude': place?.longitude ?? 0.0,
        'timezone': tz,
        if (place?.timezone != null) 'timezone_id': place!.timezone,
        'house_system': 'Placidus',
        'start_date': startDate,
        'days': days,
      };
      final result = await astro_ffi.scanTransitRangeJson(
        inputJson: jsonEncode(input),
      );
      final List<dynamic> scans = jsonDecode(result) as List<dynamic>;
      return scans
          .expand(
            (scan) =>
                DailyTransitScan.fromJson(scan as Map<String, dynamic>).events,
          )
          .toList();
    });
