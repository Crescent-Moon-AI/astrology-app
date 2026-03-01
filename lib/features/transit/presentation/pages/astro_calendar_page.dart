import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/breathing_loader.dart';
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

  String _monthNameZh(int month) {
    const months = [
      '', '一月', '二月', '三月', '四月', '五月', '六月',
      '七月', '八月', '九月', '十月', '十一月', '十二月',
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final isZh = locale.startsWith('zh');
    final calendarAsync =
        ref.watch(calendarEventsProvider((year: _year, month: _month)));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.calendarTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: CosmicColors.textPrimary,
          ),
        ),
        backgroundColor: CosmicColors.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Month navigation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left,
                      color: CosmicColors.primaryLight),
                  onPressed: _previousMonth,
                ),
                Text(
                  isZh
                      ? '$_year年${_monthNameZh(_month)}'
                      : '${_monthName(_month)} $_year',
                  style: const TextStyle(
                    color: CosmicColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right,
                      color: CosmicColors.primaryLight),
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
                      _showDayEvents(context, day, dayEvents, l10n, isZh);
                    },
                  ),
                );
              },
              loading: () => const Center(child: BreathingLoader()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off,
                        size: 48, color: CosmicColors.textTertiary),
                    const SizedBox(height: 12),
                    Text(
                      'Error: $error',
                      style: const TextStyle(color: CosmicColors.textSecondary),
                    ),
                  ],
                ),
              ),
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
    bool isZh,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CosmicColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle indicator
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: CosmicColors.surfaceHighlight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isZh
                      ? '$_year年${_month}月$day日'
                      : '${_monthName(_month)} $day, $_year',
                  style: const TextStyle(
                    color: CosmicColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (events.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Column(
                        children: [
                          const Text('\u2728',
                              style: TextStyle(fontSize: 32)),
                          const SizedBox(height: 8),
                          Text(
                            l10n.calendarNoEvents,
                            style: const TextStyle(
                              color: CosmicColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...events.map((event) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: CosmicColors.surfaceElevated,
                          border: Border.all(color: CosmicColors.borderGlow),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _eventColor(event.eventType)
                                    .withValues(alpha: 0.2),
                              ),
                              child: Icon(
                                _eventIcon(event.eventType),
                                size: 18,
                                color: _eventColor(event.eventType),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _eventLabel(event, l10n),
                                    style: const TextStyle(
                                      color: CosmicColors.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${event.planet} in ${event.sign}',
                                    style: const TextStyle(
                                      color: CosmicColors.textTertiary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
