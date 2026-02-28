import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../providers/mood_providers.dart';
import '../widgets/mood_insight_card.dart';
import '../widgets/mood_trend_chart.dart';

class MoodInsightsPage extends ConsumerWidget {
  const MoodInsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final insightsAsync = ref.watch(moodInsightsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.moodInsightsTitle),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(moodInsightsProvider);
        },
        child: insightsAsync.when(
          data: (response) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Progress indicator if not enough data
                if (!response.minimumEntriesMet) ...[
                  _buildProgressCard(context, theme, l10n, response),
                  const SizedBox(height: 16),
                ],

                // Trend chart
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mood Trend',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const MoodTrendChart(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Overall stats header
                if (response.insights.isNotEmpty) ...[
                  Text(
                    l10n.moodInsightsTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Overall average: ${response.overallAverage.toStringAsFixed(1)} from ${response.totalEntries} entries',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Insight cards
                ...response.insights.map(
                  (insight) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: MoodInsightCard(insight: insight),
                  ),
                ),

                // Empty state if minimum met but no insights
                if (response.minimumEntriesMet && response.insights.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.insights,
                            size: 48,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No correlations found yet',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    dynamic response,
  ) {
    final progress = response.progress;
    final remaining = progress.entriesRequired - progress.entriesLogged;
    final fraction = progress.percentage / 100.0;

    return Card(
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.moodInsightsProgress(remaining > 0 ? remaining : 0),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction.clamp(0.0, 1.0) as double,
                minHeight: 8,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${progress.entriesLogged} / ${progress.entriesRequired} days',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
