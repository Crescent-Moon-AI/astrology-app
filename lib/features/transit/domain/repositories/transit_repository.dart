import '../models/astro_calendar_event.dart';
import '../models/user_transit_alert.dart';

class CalendarData {
  final List<AstroCalendarEvent> universalEvents;
  final List<Map<String, dynamic>> personalEvents;

  const CalendarData({
    required this.universalEvents,
    required this.personalEvents,
  });
}

abstract class TransitRepository {
  Future<List<UserTransitAlert>> getActiveTransits();
  Future<List<UserTransitAlert>> getUpcomingTransits({int days = 30});
  Future<UserTransitAlert> getTransitDetail(String id);
  Future<void> dismissTransit(String id);
  Future<CalendarData> getCalendarEvents(int year, int month);
}
