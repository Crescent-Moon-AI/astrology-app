import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../providers/home_providers.dart';

class DateScroller extends ConsumerWidget {
  const DateScroller({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final today = DateTime.now();
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');

    // Generate 7 days centered on today
    final days = List.generate(7, (i) => today.add(Duration(days: i - 3)));

    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected =
              day.year == selectedDate.year &&
              day.month == selectedDate.month &&
              day.day == selectedDate.day;
          final isToday =
              day.year == today.year &&
              day.month == today.month &&
              day.day == today.day;

          return GestureDetector(
            onTap: () => ref.read(selectedDateProvider.notifier).set(day),
            child: Container(
              width: 48,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? CosmicColors.primary.withAlpha(51)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: CosmicColors.primary.withAlpha(128))
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isToday
                        ? (isZh ? '今' : 'Now')
                        : _weekday(day.weekday, isZh),
                    style: TextStyle(
                      color: isSelected
                          ? CosmicColors.primaryLight
                          : CosmicColors.textTertiary,
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isSelected
                          ? CosmicColors.textPrimary
                          : CosmicColors.textSecondary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _weekday(int weekday, bool isZh) {
    const zh = ['一', '二', '三', '四', '五', '六', '日'];
    const en = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return isZh ? '周${zh[weekday - 1]}' : en[weekday - 1];
  }
}
