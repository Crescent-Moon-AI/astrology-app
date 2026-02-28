import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../domain/models/mood_entry.dart';
import '../providers/mood_providers.dart';
import '../widgets/mood_calendar_heatmap.dart';

class MoodHistoryPage extends ConsumerWidget {
  const MoodHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final statsAsync = ref.watch(moodStatsProvider('30d'));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.moodHistoryTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar heatmap
            MoodCalendarHeatmap(
              onDayTapped: (entry) =>
                  _showDayDetail(context, theme, l10n, entry),
            ),

            const SizedBox(height: 24),

            // Month stats summary
            statsAsync.when(
              data: (stats) => _buildStatsSummary(context, theme, stats),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSummary(
    BuildContext context,
    ThemeData theme,
    dynamic stats,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _StatRow(
              label: 'Total Entries',
              value: '${stats.totalEntries}',
              theme: theme,
            ),
            const Divider(),
            _StatRow(
              label: 'Average Score',
              value: stats.averageScore.toStringAsFixed(1),
              theme: theme,
            ),
            const Divider(),
            _StatRow(
              label: 'Current Streak',
              value: '${stats.streak.current} days',
              theme: theme,
            ),
            const Divider(),
            _StatRow(
              label: 'Longest Streak',
              value: '${stats.streak.longest} days',
              theme: theme,
            ),
            if (stats.topTags.isNotEmpty) ...[
              const Divider(),
              _StatRow(
                label: 'Top Tag',
                value:
                    '${stats.topTags.first.tag} (${stats.topTags.first.count})',
                theme: theme,
              ),
            ],
            const Divider(),
            _StatRow(
              label: 'Trend',
              value:
                  '${stats.trend.direction} (${stats.trend.delta >= 0 ? "+" : ""}${stats.trend.delta.toStringAsFixed(2)})',
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  void _showDayDetail(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
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
        title: Text(entry.loggedDate),
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
                    .map((tag) => Chip(
                          label: Text(tag),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
            if (entry.note.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                entry.note,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;

  const _StatRow({
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
