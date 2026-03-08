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
import '../../domain/models/diary_comment.dart';
import '../providers/diary_providers.dart';

class DiaryDetailPage extends ConsumerStatefulWidget {
  final String diaryId;
  const DiaryDetailPage({super.key, required this.diaryId});

  @override
  ConsumerState<DiaryDetailPage> createState() => _DiaryDetailPageState();
}

class _DiaryDetailPageState extends ConsumerState<DiaryDetailPage> {
  final _replyController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final detailAsync = ref.watch(diaryDetailProvider(widget.diaryId));

    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          bottom: false,
          child: detailAsync.when(
            loading: () => const Center(
                child: CircularProgressIndicator(
                    color: CosmicColors.primaryLight)),
            error: (e, _) => Center(
              child: Text(e.toString(),
                  style: const TextStyle(color: CosmicColors.textTertiary)),
            ),
            data: (data) {
              final entry = DiaryEntry.fromJson(data);
              final commentsRaw =
                  data['comments'] as List<dynamic>? ?? [];
              final comments = commentsRaw
                  .map((e) =>
                      DiaryComment.fromJson(e as Map<String, dynamic>))
                  .toList();
              return _buildContent(context, l10n, entry, comments);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n,
      DiaryEntry entry, List<DiaryComment> comments) {
    return Column(
      children: [
        // Top bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: CosmicColors.textPrimary),
                onPressed: () => context.pop(),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: CosmicColors.textTertiary),
                onPressed: () => _confirmDelete(context, l10n, entry.id),
              ),
            ],
          ),
        ),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date header
                _buildDateHeader(entry.createdAt, l10n),
                const SizedBox(height: 16),

                // Diary content card
                _buildContentCard(context, entry),
                const SizedBox(height: 24),

                // AI comments section
                ...comments.map((c) => _buildCommentItem(c, l10n)),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),

        // Reply input bar
        _buildReplyBar(l10n),
      ],
    );
  }

  Widget _buildDateHeader(DateTime dt, AppLocalizations l10n) {
    final isZh =
        Localizations.localeOf(context).languageCode.startsWith('zh');
    final weekdays = isZh
        ? ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
        : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekday = weekdays[dt.weekday - 1];

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: isZh
                ? '${dt.month}月${dt.day}日'
                : '${_monthName(dt.month)} ${dt.day}',
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          TextSpan(
            text: isZh
                ? ' $weekday 记录于${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}'
                : ' $weekday at ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: CosmicColors.textTertiary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(BuildContext context, DiaryEntry entry) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (entry.content.isNotEmpty)
            Text(
              entry.content,
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 15,
                height: 1.6,
              ),
            ),
          if (entry.images.isNotEmpty) ...[
            if (entry.content.isNotEmpty) const SizedBox(height: 12),
            _buildImageCarousel(context, entry.images),
          ],
        ],
      ),
    );
  }

  Widget _buildImageCarousel(BuildContext context, List<String> images) {
    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          _resolveImageUrl(images[0]),
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, e, st) => Container(
            height: 200,
            color: CosmicColors.surface,
            child: const Icon(Icons.broken_image,
                color: CosmicColors.textTertiary),
          ),
        ),
      );
    }

    return SizedBox(
      height: 280,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _resolveImageUrl(images[index]),
                fit: BoxFit.cover,
                errorBuilder: (_, e, st) => Container(
                  color: CosmicColors.surface,
                  child: const Icon(Icons.broken_image,
                      color: CosmicColors.textTertiary),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommentItem(DiaryComment comment, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + name + time
          Row(
            children: [
              if (comment.isAI)
                const CharacterAvatar(
                  expression: ExpressionId.caring,
                  size: CharacterAvatarSize.sm,
                )
              else
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: CosmicColors.surfaceHighlight,
                  ),
                  child: const Icon(Icons.person,
                      size: 16, color: CosmicColors.textTertiary),
                ),
              const SizedBox(width: 8),
              Text(
                comment.isAI ? l10n.diaryAIName : l10n.diaryYou,
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                _formatRelativeTime(comment.createdAt, l10n),
                style: const TextStyle(
                  color: CosmicColors.textTertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Comment content
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Text(
              comment.content,
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: CosmicColors.divider, height: 1),
        ],
      ),
    );
  }

  Widget _buildReplyBar(AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: CosmicColors.backgroundDeep,
        border: Border(
          top: BorderSide(color: CosmicColors.borderGlow),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: CosmicColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: CosmicColors.borderGlow),
              ),
              child: TextField(
                controller: _replyController,
                style: const TextStyle(
                    color: CosmicColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: l10n.diaryReplyHint,
                  hintStyle:
                      const TextStyle(color: CosmicColors.textTertiary),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10),
                ),
                maxLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendReply(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sending ? null : _sendReply,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CosmicColors.primary,
                    CosmicColors.primaryLight,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: _sending
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: CosmicColors.textPrimary,
                      ),
                    )
                  : const Icon(Icons.send,
                      color: CosmicColors.textPrimary, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendReply() async {
    final content = _replyController.text.trim();
    if (content.isEmpty) return;

    setState(() => _sending = true);
    try {
      await ref.read(diaryApiProvider).createComment(widget.diaryId, content);
      _replyController.clear();
      // Refresh the detail to show new comments
      ref.invalidate(diaryDetailProvider(widget.diaryId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _confirmDelete(
      BuildContext context, AppLocalizations l10n, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CosmicColors.backgroundDeep,
        title: Text(l10n.diaryDeleteTitle,
            style: const TextStyle(color: CosmicColors.textPrimary)),
        content: Text(l10n.diaryDeleteConfirm,
            style: const TextStyle(color: CosmicColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel,
                style: const TextStyle(color: CosmicColors.textTertiary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirm,
                style: const TextStyle(color: CosmicColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(diaryApiProvider).delete(id);
        ref.invalidate(diaryListProvider);
        if (mounted) {
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }

  String _resolveImageUrl(String url) {
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

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
