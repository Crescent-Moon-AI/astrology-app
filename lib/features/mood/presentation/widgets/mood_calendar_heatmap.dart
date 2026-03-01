import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/mood_entry.dart';
import '../providers/mood_providers.dart';

class MoodCalendarHeatmap extends ConsumerStatefulWidget {
  final void Function(MoodEntry entry)? onDayTapped;

  const MoodCalendarHeatmap({super.key, this.onDayTapped});

  @override
  ConsumerState<MoodCalendarHeatmap> createState() =>
      _MoodCalendarHeatmapState();
}

class _MoodCalendarHeatmapState extends ConsumerState<MoodCalendarHeatmap> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
  }

  String get _monthKey =>
      '${_currentMonth.year}-${_currentMonth.month.toString().padLeft(2, '0')}';

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    final now = DateTime.now();
    final next = DateTime(_currentMonth.year, _currentMonth.month + 1);
    if (next.isBefore(DateTime(now.year, now.month + 1))) {
      setState(() {
        _currentMonth = next;
      });
    }
  }

  static const _scoreColors = {
    1: CosmicColors.error,
    2: Color(0xFFED8936),
    3: CosmicColors.warning,
    4: Color(0xFF48BB78),
    5: CosmicColors.success,
  };

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isZh = locale.startsWith('zh');
    final weekDayLabels = isZh
        ? ['日', '一', '二', '三', '四', '五', '六']
        : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final historyAsync = ref.watch(moodHistoryProvider(_monthKey));

    return Column(
      children: [
        // Month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left,
                  color: CosmicColors.textSecondary),
              onPressed: _previousMonth,
            ),
            Text(
              isZh
                  ? _formatMonthYearZh(_currentMonth)
                  : _formatMonthYear(_currentMonth),
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right,
                  color: CosmicColors.textSecondary),
              onPressed: _nextMonth,
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Weekday headers
        Row(
          children: weekDayLabels
              .map((label) => Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: CosmicColors.textTertiary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 4),

        // Calendar grid
        historyAsync.when(
          data: (entries) => _buildGrid(context, entries),
          loading: () => const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(color: CosmicColors.primary),
            ),
          ),
          error: (error, _) => SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'Error: $error',
                style: const TextStyle(color: CosmicColors.error, fontSize: 13),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, List<MoodEntry> entries) {
    // Build lookup: date string -> entry
    final entryMap = <String, MoodEntry>{};
    for (final entry in entries) {
      entryMap[entry.loggedDate] = entry;
    }

    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstWeekday =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday % 7;

    final cells = <Widget>[];

    // Leading empty cells
    for (var i = 0; i < firstWeekday; i++) {
      cells.add(const SizedBox.shrink());
    }

    // Day cells
    for (var day = 1; day <= daysInMonth; day++) {
      final dateStr =
          '${_currentMonth.year}-${_currentMonth.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
      final entry = entryMap[dateStr];

      cells.add(
        GestureDetector(
          onTap: entry != null && widget.onDayTapped != null
              ? () => widget.onDayTapped!(entry)
              : null,
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: entry != null
                  ? _scoreColors[entry.score]?.withValues(alpha: 0.8)
                  : CosmicColors.surfaceElevated,
              borderRadius: BorderRadius.circular(6),
              border: entry != null
                  ? null
                  : Border.all(
                      color: CosmicColors.primary.withValues(alpha: 0.1)),
            ),
            alignment: Alignment.center,
            child: Text(
              '$day',
              style: TextStyle(
                color: entry != null
                    ? Colors.white
                    : CosmicColors.textTertiary,
                fontSize: 12,
                fontWeight:
                    entry != null ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      children: cells,
    );
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatMonthYearZh(DateTime date) {
    return '${date.year}年${date.month}月';
  }
}
