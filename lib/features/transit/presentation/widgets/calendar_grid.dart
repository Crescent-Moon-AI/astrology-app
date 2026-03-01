import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/astro_calendar_event.dart';
import 'calendar_day_cell.dart';

class CalendarGrid extends StatelessWidget {
  final int year;
  final int month;
  final List<AstroCalendarEvent> events;
  final void Function(int day, List<AstroCalendarEvent> dayEvents)? onDayTap;

  const CalendarGrid({
    super.key,
    required this.year,
    required this.month,
    required this.events,
    this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isZh = locale.startsWith('zh');
    final now = DateTime.now();
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    // Sunday = 0 start for grid offset
    final startWeekday = firstDay.weekday % 7;

    // Group events by day
    final eventsByDay = <int, List<AstroCalendarEvent>>{};
    for (final event in events) {
      if (event.exactDatetime.year == year &&
          event.exactDatetime.month == month) {
        final day = event.exactDatetime.day;
        eventsByDay.putIfAbsent(day, () => []).add(event);
      }
    }

    final weekdays = isZh
        ? ['日', '一', '二', '三', '四', '五', '六']
        : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Column(
      children: [
        // Weekday header row
        Row(
          children: weekdays
              .map((d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: const TextStyle(
                          color: CosmicColors.textTertiary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 4),

        // Calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
          ),
          itemCount: startWeekday + daysInMonth,
          itemBuilder: (context, index) {
            if (index < startWeekday) {
              return const SizedBox.shrink();
            }
            final day = index - startWeekday + 1;
            final isToday = now.year == year &&
                now.month == month &&
                now.day == day;
            final dayEvents = eventsByDay[day] ?? [];

            return CalendarDayCell(
              day: day,
              isToday: isToday,
              events: dayEvents,
              onTap: () => onDayTap?.call(day, dayEvents),
            );
          },
        ),
      ],
    );
  }
}
