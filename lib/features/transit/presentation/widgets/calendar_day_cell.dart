import 'package:flutter/material.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/astro_calendar_event.dart';

class CalendarDayCell extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isCurrentMonth;
  final List<AstroCalendarEvent> events;
  final VoidCallback? onTap;

  const CalendarDayCell({
    super.key,
    required this.day,
    this.isToday = false,
    this.isCurrentMonth = true,
    this.events = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: isToday
              ? CosmicColors.primary.withValues(alpha: 0.15)
              : null,
          borderRadius: BorderRadius.circular(8),
          border: isToday
              ? Border.all(color: CosmicColors.primary, width: 1.5)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                fontSize: 14,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: isCurrentMonth
                    ? (isToday
                        ? CosmicColors.primaryLight
                        : CosmicColors.textPrimary)
                    : CosmicColors.textTertiary,
              ),
            ),
            const SizedBox(height: 2),
            // Event indicator dots (up to 3)
            if (events.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: events
                    .take(3)
                    .map((e) => Container(
                          width: 5,
                          height: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: _eventColor(e.eventType),
                            shape: BoxShape.circle,
                          ),
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Color _eventColor(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'full_moon':
      case 'new_moon':
        return CosmicColors.primaryLight;
      case 'solar_eclipse':
      case 'lunar_eclipse':
        return CosmicColors.error;
      case 'retrograde_start':
      case 'retrograde_end':
        return CosmicColors.secondary;
      case 'sign_ingress':
      default:
        return CosmicColors.success;
    }
  }
}
