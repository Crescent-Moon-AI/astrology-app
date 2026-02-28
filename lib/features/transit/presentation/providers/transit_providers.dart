import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/transit_api.dart';
import '../../data/repositories/transit_repository_impl.dart';
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
final activeTransitsProvider =
    FutureProvider<List<UserTransitAlert>>((ref) async {
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
final transitDetailProvider =
    FutureProvider.family<UserTransitAlert, String>((ref, id) async {
  final repo = ref.watch(transitRepositoryProvider);
  return repo.getTransitDetail(id);
});

// Calendar events (parameterized by year+month)
final calendarEventsProvider =
    FutureProvider.family<CalendarData, ({int year, int month})>(
        (ref, params) async {
  final repo = ref.watch(transitRepositoryProvider);
  return repo.getCalendarEvents(params.year, params.month);
});
