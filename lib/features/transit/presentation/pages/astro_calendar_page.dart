import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../domain/models/astro_calendar_event.dart';
import '../providers/transit_providers.dart';
import '../widgets/calendar_grid.dart';

class AstroCalendarPage extends ConsumerStatefulWidget {
  const AstroCalendarPage({super.key});

  @override
  ConsumerState<AstroCalendarPage> createState() => _AstroCalendarPageState();
}

class _AstroCalendarPageState extends ConsumerState<AstroCalendarPage> {
  late int _year;
  late int _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
  }

  void _previousMonth() {
    setState(() {
      if (_month == 1) {
        _month = 12;
        _year--;
      } else {
        _month--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_month == 12) {
        _month = 1;
        _year++;
      } else {
        _month++;
      }
    });
  }

  String _monthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final calendarAsync =
        ref.watch(calendarEventsProvider((year: _year, month: _month)));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.calendarTitle),
      ),
      body: Column(
        children: [
          // Month navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _previousMonth,
                ),
                Text(
                  '${_monthName(_month)} $_year',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _nextMonth,
                ),
              ],
            ),
          ),

          // Calendar grid
          Expanded(
            child: calendarAsync.when(
              data: (calendarData) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: CalendarGrid(
                    year: _year,
                    month: _month,
                    events: calendarData.universalEvents,
                    onDayTap: (day, dayEvents) {
                      _showDayEvents(context, day, dayEvents, l10n);
                    },
                  ),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  void _showDayEvents(
    BuildContext context,
    int day,
    List<AstroCalendarEvent> events,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_monthName(_month)} $day, $_year',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                if (events.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        l10n.calendarNoEvents,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                else
                  ...events.map((event) => ListTile(
                        leading: Icon(
                          _eventIcon(event.eventType),
                          color: _eventColor(event.eventType),
                        ),
                        title: Text(_eventLabel(event, l10n)),
                        subtitle: Text(
                          '${event.planet} in ${event.sign}',
                          style: theme.textTheme.bodySmall,
                        ),
                        contentPadding: EdgeInsets.zero,
                      )),
              ],
            ),
          ),
        );
      },
    );
  }

  String _eventLabel(AstroCalendarEvent event, AppLocalizations l10n) {
    switch (event.eventType.toLowerCase()) {
      case 'full_moon':
        return l10n.calendarFullMoon;
      case 'new_moon':
        return l10n.calendarNewMoon;
      case 'solar_eclipse':
        return l10n.calendarSolarEclipse;
      case 'lunar_eclipse':
        return l10n.calendarLunarEclipse;
      case 'retrograde_start':
        return '${event.planet} ${l10n.calendarRetrogadeStart}';
      case 'retrograde_end':
        return '${event.planet} ${l10n.calendarRetrogadeEnd}';
      case 'sign_ingress':
        return '${event.planet} ${l10n.calendarSignIngress} ${event.sign}';
      default:
        return event.eventType;
    }
  }

  IconData _eventIcon(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'full_moon':
        return Icons.circle;
      case 'new_moon':
        return Icons.circle_outlined;
      case 'solar_eclipse':
        return Icons.wb_sunny;
      case 'lunar_eclipse':
        return Icons.nightlight_round;
      case 'retrograde_start':
      case 'retrograde_end':
        return Icons.replay;
      case 'sign_ingress':
        return Icons.arrow_right_alt;
      default:
        return Icons.star;
    }
  }

  Color _eventColor(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'full_moon':
      case 'new_moon':
        return Colors.blue;
      case 'solar_eclipse':
      case 'lunar_eclipse':
        return Colors.red;
      case 'retrograde_start':
      case 'retrograde_end':
        return Colors.purple;
      case 'sign_ingress':
      default:
        return Colors.orange;
    }
  }
}
