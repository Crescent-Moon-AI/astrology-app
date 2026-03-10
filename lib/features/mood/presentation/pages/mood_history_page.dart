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
              onDayTapped: (entry) => _showDayDetail(context, l10n, entry),
            ),

            const SizedBox(height: 24),

            // Month stats summary
            statsAsync.when(
              data: (stats) => _buildStatsSummary(context, l10n, stats),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: BreathingLoader()),
              ),
              error: (error, _) => Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.cloud_off,
                      size: 36,
                      color: CosmicColors.textTertiary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.errorLoadFailed,
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
    AppLocalizations l10n,
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
              const Icon(
                Icons.insights,
                size: 18,
                color: CosmicColors.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.moodMonthlySummary,
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
            label: l10n.moodTotalEntries,
            value: '${stats.totalEntries}',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Divider(color: CosmicColors.divider),
          ),
          _StatRow(
            icon: Icons.sentiment_satisfied,
            label: l10n.moodAverageScore,
            value: stats.averageScore.toStringAsFixed(1),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Divider(color: CosmicColors.divider),
          ),
          _StatRow(
            icon: Icons.local_fire_department,
            label: l10n.moodCurrentStreak,
            value: '${stats.streak.current} ${l10n.moodDaysUnit}',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Divider(color: CosmicColors.divider),
          ),
          _StatRow(
            icon: Icons.emoji_events,
            label: l10n.moodLongestStreak,
            value: '${stats.streak.longest} ${l10n.moodDaysUnit}',
          ),
          if (stats.topTags.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Divider(color: CosmicColors.divider),
            ),
            _StatRow(
              icon: Icons.tag,
              label: l10n.moodTopTag,
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
            label: l10n.moodTrendLabel,
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
    MoodEntry entry,
  ) {
    const scoreEmojis = [
      '\u{1F622}',
      '\u{1F61E}',
      '\u{1F610}',
      '\u{1F60A}',
      '\u{1F604}',
    ];
    final emoji = entry.score >= 1 && entry.score <= 5
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
            Center(child: Text(emoji, style: const TextStyle(fontSize: 48))),
            const SizedBox(height: 12),
            if (entry.tags.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: entry.tags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: CosmicColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: CosmicColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: CosmicColors.primaryLight,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
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
            child: Text(l10n.moodOk),
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
