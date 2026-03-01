import '../../domain/models/astro_calendar_event.dart';
import '../../domain/models/user_transit_alert.dart';
import '../../domain/repositories/transit_repository.dart';
import '../datasources/transit_api.dart';

class TransitRepositoryImpl implements TransitRepository {
  final TransitApi _api;

  TransitRepositoryImpl(this._api);

  @override
  Future<List<UserTransitAlert>> getActiveTransits() async {
    final data = await _api.getActiveTransits();
    final items = data['items'] as List<dynamic>? ?? [];
    return items
        .map((e) => UserTransitAlert.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<UserTransitAlert>> getUpcomingTransits({int days = 30}) async {
    final data = await _api.getUpcomingTransits(days: days);
    final items = data['items'] as List<dynamic>? ?? [];
    return items
        .map((e) => UserTransitAlert.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<UserTransitAlert> getTransitDetail(String id) async {
    final data = await _api.getTransitDetail(id);
    return UserTransitAlert.fromJson(data);
  }

  @override
  Future<void> dismissTransit(String id) async {
    await _api.dismissTransit(id);
  }

  @override
  Future<CalendarData> getCalendarEvents(int year, int month) async {
    final data = await _api.getCalendarEvents(year, month);
    return CalendarData(
      universalEvents: (data['items'] as List<dynamic>? ?? [])
          .map((e) => AstroCalendarEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      personalEvents: const [],
    );
  }
}
