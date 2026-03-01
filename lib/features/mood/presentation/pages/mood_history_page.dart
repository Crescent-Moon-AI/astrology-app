import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/breathing_loader.dart';
import '../../domain/models/mood_entry.dart';
import '../providers/mood_providers.dart';
import '../widgets/mood_calendar_heatmap.dart';

class MoodHistoryPage extends ConsumerWidget {
  const MoodHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final isZh = locale.startsWith('zh');
    final statsAsync = ref.watch(moodStatsProvider('30d'));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.moodHistoryTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: CosmicColors.textPrimary,
          ),
        ),
        backgroundColor: CosmicColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar heatmap
            MoodCalendarHeatmap(
              onDayTapped: (entry) =>
                  _showDayDetail(context, l10n, isZh, entry),
            ),

            const SizedBox(height: 24),

            // Month stats summary
            statsAsync.when(
              data: (stats) => _buildStatsSummary(context, isZh, stats),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: BreathingLoader()),
              ),
              error: (error, _) => Center(
                child: Column(
                  children: [
                    const Icon(Icons.cloud_off,
                        size: 36, color: CosmicColors.textTertiary),
                    const SizedBox(height: 8),
                    Text(
                      'Error: $error',
                      style: const TextStyle(
                        color: CosmicColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSummary(
    BuildContext context,
    bool isZh,
    dynamic stats,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: CosmicColors.surfaceElevated,
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights, size: 18, color: CosmicColors.secondary),
              const SizedBox(width: 8),
              Text(
                isZh ? '月度总结' : 'Summary',
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _StatRow(
            icon: Icons.edit_note,
            label: isZh ? '记录总数' : 'Total Entries',
            value: '${stats.totalEntries}',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Divider(color: CosmicColors.divider),
          ),
          _StatRow(
            icon: Icons.sentiment_satisfied,
            label: isZh ? '平均分数' : 'Average Score',
            value: stats.averageScore.toStringAsFixed(1),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Divider(color: CosmicColors.divider),
          ),
          _StatRow(
            icon: Icons.local_fire_department,
            label: isZh ? '当前连续' : 'Current Streak',
            value:
                '${stats.streak.current} ${isZh ? "天" : "days"}',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Divider(color: CosmicColors.divider),
          ),
          _StatRow(
            icon: Icons.emoji_events,
            label: isZh ? '最长连续' : 'Longest Streak',
            value:
                '${stats.streak.longest} ${isZh ? "天" : "days"}',
          ),
          if (stats.topTags.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Divider(color: CosmicColors.divider),
            ),
            _StatRow(
              icon: Icons.tag,
              label: isZh ? '热门标签' : 'Top Tag',
              value:
                  '${stats.topTags.first.tag} (${stats.topTags.first.count})',
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Divider(color: CosmicColors.divider),
          ),
          _StatRow(
            icon: Icons.trending_up,
            label: isZh ? '趋势' : 'Trend',
            value:
                '${stats.trend.direction} (${stats.trend.delta >= 0 ? "+" : ""}${stats.trend.delta.toStringAsFixed(2)})',
          ),
        ],
      ),
    );
  }

  void _showDayDetail(
    BuildContext context,
    AppLocalizations l10n,
    bool isZh,
    MoodEntry entry,
  ) {
    const scoreEmojis = [
      '\u{1F622}',
      '\u{1F61E}',
      '\u{1F610}',
      '\u{1F60A}',
      '\u{1F604}',
    ];
    final emoji =
        entry.score >= 1 && entry.score <= 5
            ? scoreEmojis[entry.score - 1]
            : '\u{1F610}';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CosmicColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: CosmicColors.borderGlow),
        ),
        title: Text(
          entry.loggedDate,
          style: const TextStyle(color: CosmicColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(emoji, style: const TextStyle(fontSize: 48)),
            ),
            const SizedBox(height: 12),
            if (entry.tags.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: entry.tags
                    .map((tag) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: CosmicColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  CosmicColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: CosmicColors.primaryLight,
                              fontSize: 12,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            if (entry.note.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                entry.note,
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(isZh ? '好的' : 'OK'),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: CosmicColors.primaryLight),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
