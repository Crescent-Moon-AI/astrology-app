import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/breathing_loader.dart';
import '../providers/mood_providers.dart';
import '../widgets/mood_insight_card.dart';
import '../widgets/mood_trend_chart.dart';

class MoodInsightsPage extends ConsumerWidget {
  const MoodInsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final isZh = locale.startsWith('zh');
    final insightsAsync = ref.watch(moodInsightsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.moodInsightsTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: CosmicColors.textPrimary,
          ),
        ),
        backgroundColor: CosmicColors.background,
        elevation: 0,
      ),
      body: RefreshIndicator(
        color: CosmicColors.primary,
        backgroundColor: CosmicColors.surfaceElevated,
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
                  _buildProgressCard(context, isZh, l10n, response),
                  const SizedBox(height: 16),
                ],

                // Trend chart
                Container(
                  padding: const EdgeInsets.all(16),
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
                          const Icon(Icons.show_chart,
                              size: 18, color: CosmicColors.secondary),
                          const SizedBox(width: 8),
                          Text(
                            isZh ? '心情趋势' : 'Mood Trend',
                            style: const TextStyle(
                              color: CosmicColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const MoodTrendChart(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Overall stats header
                if (response.insights.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome,
                          size: 18, color: CosmicColors.primaryLight),
                      const SizedBox(width: 8),
                      Text(
                        l10n.moodInsightsTitle,
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isZh
                        ? '平均分 ${response.overallAverage.toStringAsFixed(1)} · ${response.totalEntries} 条记录'
                        : 'Average: ${response.overallAverage.toStringAsFixed(1)} from ${response.totalEntries} entries',
                    style: const TextStyle(
                      color: CosmicColors.textTertiary,
                      fontSize: 13,
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
                          const Text('\uD83D\uDD2E',
                              style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 12),
                          Text(
                            isZh ? '暂无相关性数据' : 'No correlations found yet',
                            style: const TextStyle(
                              color: CosmicColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
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
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    bool isZh,
    AppLocalizations l10n,
    dynamic response,
  ) {
    final progress = response.progress;
    final remaining = progress.entriesRequired - progress.entriesLogged;
    final fraction = progress.percentage / 100.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            CosmicColors.primary.withValues(alpha: 0.15),
            CosmicColors.surfaceElevated,
          ],
        ),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lock_outline,
                size: 18,
                color: CosmicColors.secondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.moodInsightsProgress(remaining > 0 ? remaining : 0),
                  style: const TextStyle(
                    color: CosmicColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: CosmicColors.surface,
                ),
              ),
              FractionallySizedBox(
                widthFactor: (fraction as double).clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: CosmicColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: CosmicColors.primary.withValues(alpha: 0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${progress.entriesLogged} / ${progress.entriesRequired} ${isZh ? "天" : "days"}',
            style: const TextStyle(
              color: CosmicColors.textTertiary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
