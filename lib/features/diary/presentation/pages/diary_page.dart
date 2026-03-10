import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/character_avatar.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../../../shared/models/expression.dart';
import '../../domain/models/diary_entry.dart';
import '../providers/diary_providers.dart';

class DiaryPage extends ConsumerWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final diaryAsync = ref.watch(diaryListProvider);

    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Text(
                        '✦ ',
                        style: TextStyle(
                          color: CosmicColors.primaryLight,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        l10n.diaryTitle,
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: diaryAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: CosmicColors.primaryLight,
                    ),
                  ),
                  error: (e, _) => Center(
                    child: Text(
                      e.toString(),
                      style: const TextStyle(color: CosmicColors.textTertiary),
                    ),
                  ),
                  data: (entries) => entries.isEmpty
                      ? _EmptyState(l10n: l10n)
                      : _DiaryList(entries: entries, l10n: l10n),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Empty state (full character + tags + button) ────────────────────────

class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;
  const _EmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');
    final moodTags = isZh
        ? [
            '树洞记录',
            '心情记录',
            '焦虑的',
            '快乐的',
            '兴奋的',
            '小秘密',
            '情感记录',
            '新想法',
            '悲伤的',
            '忧郁的',
            '自信的',
            '沮丧的',
            '此刻发生',
          ]
        : [
            'Diary',
            'Mood Log',
            'Anxious',
            'Happy',
            'Excited',
            'Secret',
            'Emotions',
            'New Ideas',
            'Sad',
            'Melancholy',
            'Confident',
            'Frustrated',
            'Right Now',
          ];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: CosmicColors.textTertiary.withAlpha(100),
            strokeWidth: 1.0,
            dashWidth: 6,
            dashSpace: 4,
            radius: 16,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 320,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ..._buildFloatingTags(moodTags),
                      const CharacterAvatar(
                        expression: ExpressionId.caring,
                        size: CharacterAvatarSize.lg,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _AddDiaryButton(label: l10n.diaryAddNew),
                const SizedBox(height: 16),
                Text(
                  l10n.diaryEmptyHint,
                  style: const TextStyle(
                    color: CosmicColors.textTertiary,
                    fontSize: 14,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Diary list (compact header + scrollable entries) ────────────────────

class _DiaryList extends ConsumerWidget {
  final List<DiaryEntry> entries;
  final AppLocalizations l10n;
  const _DiaryList({required this.entries, required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');
    final compactTags = isZh
        ? ['平静的', '新想法', '心情记录', '感恩的', '焦虑的', '此刻发生']
        : ['Calm', 'New Ideas', 'Mood Log', 'Grateful', 'Anxious', 'Right Now'];

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(diaryListProvider);
      },
      color: CosmicColors.primaryLight,
      backgroundColor: CosmicColors.backgroundDeep,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        itemCount: entries.length + 1, // +1 for compact header
        itemBuilder: (context, index) {
          if (index == 0) {
            return _CompactHeader(l10n: l10n, tags: compactTags);
          }
          final entry = entries[index - 1];
          return _DiaryEntryCard(entry: entry, l10n: l10n);
        },
      ),
    );
  }
}

// ─── Compact header (when entries exist) ─────────────────────────────────

class _CompactHeader extends StatelessWidget {
  final AppLocalizations l10n;
  final List<String> tags;
  const _CompactHeader({required this.l10n, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [CosmicColors.surfaceElevated, CosmicColors.surface],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CosmicColors.borderGlow),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Small character avatar
            const CharacterAvatar(
              expression: ExpressionId.caring,
              size: CharacterAvatarSize.md,
            ),
            const SizedBox(width: 12),
            // Text + tags + button
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.diaryEmptyHint,
                    style: const TextStyle(
                      color: CosmicColors.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Floating tags row
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: tags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: CosmicColors.surfaceHighlight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: CosmicColors.textTertiary,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  _AddDiaryButton(label: l10n.diaryAddNew, compact: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Single diary entry card ─────────────────────────────────────────────

class _DiaryEntryCard extends StatelessWidget {
  final DiaryEntry entry;
  final AppLocalizations l10n;
  const _DiaryEntryCard({required this.entry, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time label
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            _formatRelativeTime(entry.createdAt, l10n),
            style: const TextStyle(
              color: CosmicColors.textTertiary,
              fontSize: 13,
            ),
          ),
        ),
        // Entry card
        GestureDetector(
          onTap: () => context.push('/diary/${entry.id}'),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CosmicColors.surfaceElevated,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: CosmicColors.borderGlow),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Content text
                if (entry.content.isNotEmpty)
                  Text(
                    entry.content,
                    style: const TextStyle(
                      color: CosmicColors.textPrimary,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                // Image thumbnails
                if (entry.images.isNotEmpty) ...[
                  if (entry.content.isNotEmpty) const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: entry.images
                        .map(
                          (url) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _resolveImageUrl(context, url),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (_, e, st) => Container(
                                width: 100,
                                height: 100,
                                color: CosmicColors.surface,
                                child: const Icon(
                                  Icons.broken_image,
                                  color: CosmicColors.textTertiary,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Resolve relative image URL to absolute using the API base URL.
  String _resolveImageUrl(BuildContext context, String url) {
    if (url.startsWith('http')) return url;
    return '${ApiConstants.baseUrl}$url';
  }

  String _formatRelativeTime(DateTime dt, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return l10n.timeJustNow;
    if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);
    if (diff.inDays == 1) return l10n.timeYesterday;
    if (diff.inDays < 30) return l10n.timeDaysAgo(diff.inDays);
    return l10n.timeDateFormat(dt.month, dt.day);
  }
}

// ─── Shared "Add Diary" button ───────────────────────────────────────────

class _AddDiaryButton extends StatelessWidget {
  final String label;
  final bool compact;
  const _AddDiaryButton({required this.label, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/diary/edit'),
      child: Container(
        width: compact ? null : double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: compact ? 8 : 16,
          horizontal: compact ? 20 : 0,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              CosmicColors.primary.withAlpha(60),
              CosmicColors.primaryLight.withAlpha(35),
            ],
          ),
          borderRadius: BorderRadius.circular(compact ? 20 : 28),
          border: Border.all(color: CosmicColors.primaryLight.withAlpha(90)),
        ),
        child: Row(
          mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: CosmicColors.textPrimary,
              size: compact ? 16 : 22,
            ),
            SizedBox(width: compact ? 4 : 8),
            Text(
              label,
              style: TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: compact ? 13 : 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared floating tags builder ────────────────────────────────────────

List<Widget> _buildFloatingTags(List<String> tags) {
  const positions = [
    Alignment(-0.55, -0.85),
    Alignment(0.40, -0.75),
    Alignment(0.95, -0.60),
    Alignment(-0.85, -0.40),
    Alignment(-0.40, -0.30),
    Alignment(-0.95, -0.05),
    Alignment(-0.70, 0.15),
    Alignment(0.80, -0.10),
    Alignment(-0.85, 0.50),
    Alignment(-0.45, 0.70),
    Alignment(0.60, 0.30),
    Alignment(0.90, 0.55),
    Alignment(0.70, 0.75),
  ];

  return List.generate(tags.length, (i) {
    final opacity = (i % 3 == 0)
        ? 0.5
        : (i % 3 == 1)
        ? 0.7
        : 0.6;
    return Align(
      alignment: positions[i % positions.length],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: CosmicColors.surfaceElevated.withAlpha(
            (opacity * 255).round(),
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: CosmicColors.borderGlow.withAlpha((opacity * 180).round()),
          ),
        ),
        child: Text(
          tags[i],
          style: TextStyle(
            color: CosmicColors.textSecondary.withAlpha(
              (opacity * 255).round(),
            ),
            fontSize: 12,
          ),
        ),
      ),
    );
  });
}

// ─── Dashed border painter ───────────────────────────────────────────────

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double radius;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = min(distance + dashWidth, metric.length);
        final extracted = metric.extractPath(distance, end);
        canvas.drawPath(extracted, paint);
        distance = end + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      dashWidth != oldDelegate.dashWidth ||
      dashSpace != oldDelegate.dashSpace ||
      radius != oldDelegate.radius;
}
