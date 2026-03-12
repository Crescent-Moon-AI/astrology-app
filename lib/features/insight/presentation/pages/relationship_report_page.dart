import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../../shared/theme/cosmic_colors.dart';
import '../../../../../shared/widgets/starfield_background.dart';
import '../../domain/models/relationship_report.dart';
import '../providers/report_providers.dart';

class RelationshipReportArgs {
  final String reportProductId;
  final String? friendId;
  final String? friendName;

  const RelationshipReportArgs({
    required this.reportProductId,
    this.friendId,
    this.friendName,
  });
}

class RelationshipReportPage extends ConsumerStatefulWidget {
  final RelationshipReportArgs args;

  const RelationshipReportPage({super.key, required this.args});

  @override
  ConsumerState<RelationshipReportPage> createState() =>
      _RelationshipReportPageState();
}

class _RelationshipReportPageState
    extends ConsumerState<RelationshipReportPage> {
  bool _generating = false;
  RelationshipReport? _report;
  Object? _error;

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  Future<void> _generate() async {
    setState(() {
      _generating = true;
      _error = null;
    });
    try {
      final api = ref.read(reportApiProvider);
      final data = await api.createReport(
        reportProductId: widget.args.reportProductId,
        friendId: widget.args.friendId,
      );
      final payload = data['data'] as Map<String, dynamic>? ?? data;
      final report = RelationshipReport.fromJson(payload);
      if (mounted) setState(() => _report = report);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _AppBar(
                title: _report != null
                    ? (_report!.title.isNotEmpty
                          ? _report!.title
                          : l10n.reportRelationshipTitle)
                    : (widget.args.friendName != null
                          ? l10n.reportRelationshipTitle
                          : l10n.reportInsightTitle),
              ),
              Expanded(
                child: _generating
                    ? const _LoadingView()
                    : _error != null
                    ? _ErrorView(error: _error!, onRetry: _generate)
                    : _report != null
                    ? _ReportContent(report: _report!)
                    : _ProductPreview(args: widget.args, onGenerate: _generate),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── App Bar ─────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  final String title;
  const _AppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: CosmicColors.textPrimary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Product Preview (pre-generate) ──────────────────────────────────────────

class _ProductPreview extends ConsumerWidget {
  final RelationshipReportArgs args;
  final VoidCallback onGenerate;

  const _ProductPreview({required this.args, required this.onGenerate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final productAsync = ref.watch(reportProductProvider(args.reportProductId));

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ── Cover banner ──────────────────────────────────────────
                _CoverBanner(
                  title: productAsync.maybeWhen(
                    data: (p) => p.title,
                    orElse: () {
                      if (args.reportProductId == 'report_self_exploration') {
                        return l10n.insightKnowYourself;
                      }
                      if (args.reportProductId == 'report_other_exploration') {
                        return l10n.insightExploreTarget;
                      }
                      return l10n.insightUnderstandRelationship;
                    },
                  ),
                  subtitle: productAsync.maybeWhen(
                    data: (p) => p.subtitle,
                    orElse: () {
                      if (args.reportProductId == 'report_self_exploration') {
                        return l10n.insightKnowYourselfSub;
                      }
                      if (args.reportProductId == 'report_other_exploration') {
                        return l10n.insightReadMindSub;
                      }
                      return l10n.insightDeepAnalysisSub;
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // ── What you'll get ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.reportIncludes,
                        style: const TextStyle(
                          color: CosmicColors.textTertiary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._previewSections(
                        l10n,
                        args.reportProductId,
                      ).map(_PreviewSectionTile.new),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // ── Bottom bar with friend card + button ──────────────────────────
        _BottomBar(args: args, onGenerate: onGenerate),
      ],
    );
  }

  static List<String> _previewSections(
    AppLocalizations l10n,
    String productId,
  ) {
    final isZh = l10n.localeName.startsWith('zh');
    if (productId == 'report_self_exploration') {
      return isZh
          ? ['个性深度分析', '天赋与优势', '情感模式', '事业方向', '成长路径']
          : [
              'Personality Analysis',
              'Talents & Strengths',
              'Emotional Patterns',
              'Career Direction',
              'Growth Path',
            ];
    }
    if (productId == 'report_other_exploration') {
      return isZh
          ? ['性格特点解读', '内心世界探索', '情感需求', '优势与盲点', '相处建议']
          : [
              'Personality Insights',
              'Inner World',
              'Emotional Needs',
              'Strengths & Blind Spots',
              'Relationship Tips',
            ];
    }
    return isZh
        ? ['关系能量概览', '情感连结', '沟通模式', '挑战与成长', '相处之道']
        : [
            'Relationship Energy',
            'Emotional Connection',
            'Communication Style',
            'Challenges & Growth',
            'Tips for Harmony',
          ];
  }
}

class _CoverBanner extends StatelessWidget {
  final String title;
  final String subtitle;

  const _CoverBanner({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 375 / 211,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2D1B69), Color(0xFF4C2B8A), Color(0xFF1A0E3D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Decorative stars
            Positioned(
              top: 20,
              right: 30,
              child: Icon(
                Icons.star_rounded,
                color: Colors.white.withAlpha(60),
                size: 14,
              ),
            ),
            Positioned(
              top: 50,
              right: 80,
              child: Icon(
                Icons.star_rounded,
                color: Colors.white.withAlpha(40),
                size: 8,
              ),
            ),
            Positioned(
              bottom: 40,
              left: 40,
              child: Icon(
                Icons.star_rounded,
                color: Colors.white.withAlpha(50),
                size: 10,
              ),
            ),
            // Bottom fade
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 60,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Color(0xFF000109)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // Text
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withAlpha(200),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewSectionTile extends StatelessWidget {
  final String title;
  const _PreviewSectionTile(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: CosmicColors.primaryLight,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final RelationshipReportArgs args;
  final VoidCallback onGenerate;

  const _BottomBar({required this.args, required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Color(0xFF08090D)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (args.friendName != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0x1A1E153B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: CosmicColors.borderGlow),
              ),
              child: Row(
                children: [
                  if (args.reportProductId != 'report_other_exploration')
                    _AvatarCircle(label: l10n.reportMeLabel),
                  if (args.reportProductId != 'report_other_exploration')
                    const SizedBox(width: 4),
                  _AvatarCircle(
                    label: args.friendName![0].toUpperCase(),
                    color: const Color(0xFF4C2B8A),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      args.reportProductId == 'report_other_exploration'
                          ? l10n.reportFriendProfileSelected(args.friendName!)
                          : l10n.reportFriendRelationship(args.friendName!),
                      style: const TextStyle(
                        color: CosmicColors.textPrimary,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ] else if (args.reportProductId == 'report_self_exploration') ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0x1A1E153B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: CosmicColors.borderGlow),
              ),
              child: Row(
                children: [
                  _AvatarCircle(label: l10n.reportMeLabel),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.reportMyProfile,
                      style: const TextStyle(
                        color: CosmicColors.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onGenerate,
              style: ElevatedButton.styleFrom(
                backgroundColor: CosmicColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                l10n.reportGenerate,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final String label;
  final Color? color;
  const _AvatarCircle({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFF2D1B69),
        shape: BoxShape.circle,
        border: Border.all(color: CosmicColors.borderGlow, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ── Loading ──────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: CosmicColors.primary),
          const SizedBox(height: 20),
          Text(
            l10n.reportGenerating,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: CosmicColors.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.reportFailed,
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onRetry,
              child: Text(
                l10n.reportRetry,
                style: const TextStyle(color: CosmicColors.primaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportContent extends StatelessWidget {
  final RelationshipReport report;

  const _ReportContent({required this.report});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C5CE7), Color(0xFF4834d4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (report.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    report.subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Sections
          ...report.sections.asMap().entries.map((entry) {
            return _SectionCard(section: entry.value, index: entry.key);
          }),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final ReportSection section;
  final int index;

  const _SectionCard({required this.section, required this.index});

  static const _iconList = [
    Icons.auto_awesome,
    Icons.favorite_outline,
    Icons.chat_bubble_outline,
    Icons.trending_up,
    Icons.spa_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final icon = _iconList[index % _iconList.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CosmicColors.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CosmicColors.borderGlow),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: CosmicColors.primaryLight, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    section.title,
                    style: const TextStyle(
                      color: CosmicColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              section.content,
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 14,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
