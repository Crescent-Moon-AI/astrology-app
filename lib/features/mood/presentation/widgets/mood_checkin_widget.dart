import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../providers/mood_providers.dart';
import 'mood_score_selector.dart';
import 'mood_tag_chips.dart';

class MoodCheckinWidget extends ConsumerStatefulWidget {
  const MoodCheckinWidget({super.key});

  @override
  ConsumerState<MoodCheckinWidget> createState() => _MoodCheckinWidgetState();
}

class _MoodCheckinWidgetState extends ConsumerState<MoodCheckinWidget> {
  int? _selectedScore;
  Set<String> _selectedTags = {};
  final _noteController = TextEditingController();
  bool _isExpanded = false;
  bool _isEditing = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitMood() async {
    if (_selectedScore == null) return;

    setState(() => _isSubmitting = true);
    try {
      final api = ref.read(moodApiProvider);
      await api.submitMood(
        score: _selectedScore!,
        tags: _selectedTags.toList(),
        note: _noteController.text.trim(),
      );
      ref.invalidate(todayMoodProvider);
      if (mounted) {
        setState(() {
          _isExpanded = false;
          _isEditing = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final todayMoodAsync = ref.watch(todayMoodProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: todayMoodAsync.when(
        data: (todayMood) {
          // Already logged today and not editing
          if (todayMood != null && !_isEditing) {
            return _buildReadOnlyView(context, l10n, todayMood);
          }

          // Logging or editing
          return _buildCheckinForm(context, l10n);
        },
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(color: CosmicColors.primary),
          ),
        ),
        error: (_, __) => _buildCheckinForm(context, l10n),
      ),
    );
  }

  Widget _buildReadOnlyView(
    BuildContext context,
    AppLocalizations l10n,
    dynamic todayMood,
  ) {
    const scoreEmojis = [
      '\u{1F622}',
      '\u{1F61E}',
      '\u{1F610}',
      '\u{1F60A}',
      '\u{1F604}',
    ];
    final emoji =
        todayMood.score >= 1 && todayMood.score <= 5
            ? scoreEmojis[todayMood.score - 1]
            : '\u{1F610}';

    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 36)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.moodCheckinTitle,
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (todayMood.tags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    (todayMood.tags as List<String>).join(', '),
                    style: const TextStyle(
                      color: CosmicColors.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isEditing = true;
              _selectedScore = todayMood.score as int;
              _selectedTags = Set<String>.from(todayMood.tags as List<String>);
              _noteController.text = todayMood.note as String;
              _isExpanded = true;
            });
          },
          child: Text(
            l10n.moodEdit,
            style: const TextStyle(color: CosmicColors.primaryLight),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckinForm(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row with optional streak
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.moodCheckinTitle,
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Show streak from stats if available
            _buildStreakBadge(context, l10n),
          ],
        ),
        const SizedBox(height: 16),

        // Score selector
        MoodScoreSelector(
          selectedScore: _selectedScore,
          onScoreSelected: (score) {
            setState(() {
              _selectedScore = score;
              if (!_isExpanded) {
                _isExpanded = true;
              }
            });
          },
        ),

        // Expanded section: tags + note + done button
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState:
              _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              MoodTagChips(
                selectedTags: _selectedTags,
                onTagsChanged: (tags) => setState(() => _selectedTags = tags),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: l10n.moodNoteHint,
                  hintStyle: const TextStyle(color: CosmicColors.textTertiary),
                  filled: true,
                  fillColor: CosmicColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: CosmicColors.borderGlow),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: CosmicColors.borderGlow),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: CosmicColors.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                style: const TextStyle(color: CosmicColors.textPrimary),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: _selectedScore != null && !_isSubmitting
                        ? CosmicColors.primaryGradient
                        : null,
                    color: _selectedScore == null || _isSubmitting
                        ? CosmicColors.surfaceElevated
                        : null,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _selectedScore != null && !_isSubmitting
                          ? _submitMood
                          : null,
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  l10n.moodDone,
                                  style: TextStyle(
                                    color: _selectedScore != null
                                        ? CosmicColors.textPrimary
                                        : CosmicColors.textTertiary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStreakBadge(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final statsAsync = ref.watch(moodStatsProvider('30d'));
    return statsAsync.when(
      data: (stats) {
        if (stats.streak.current <= 0) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: CosmicColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: CosmicColors.primary.withValues(alpha: 0.4),
            ),
          ),
          child: Text(
            l10n.moodStreak(stats.streak.current),
            style: const TextStyle(
              color: CosmicColors.primaryLight,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
