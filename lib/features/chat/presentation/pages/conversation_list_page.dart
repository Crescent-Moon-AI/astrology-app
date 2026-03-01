import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/character_avatar.dart';
import '../../../../shared/models/expression.dart';
import '../../../scenario/domain/models/scenario.dart';
import '../../../scenario/l10n/scenario_strings.dart';
import '../../../scenario/presentation/providers/scenario_providers.dart';
import '../../../scenario/presentation/widgets/scenario_icon_data.dart';
import '../providers/chat_providers.dart';

class ConversationListPage extends ConsumerWidget {
  const ConversationListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final isZh = locale.startsWith('zh');
    final conversationsAsync = ref.watch(conversationListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chatTitle),
        backgroundColor: CosmicColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: conversationsAsync.when(
        data: (conversations) {
          if (conversations.isEmpty) {
            return _buildEmptyState(context, ref, isZh, locale);
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conv = conversations[index];
              return _ConversationCard(
                title: conv.title ??
                    (isZh ? '新的对话' : 'New Conversation'),
                subtitle: conv.lastMessageAt != null
                    ? _formatDate(conv.lastMessageAt!, isZh)
                    : null,
                onTap: () => context.push('/chat/${conv.id}'),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: CosmicColors.primary,
          ),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48, color: CosmicColors.textTertiary),
              const SizedBox(height: 12),
              Text(
                isZh ? '加载失败' : 'Failed to load',
                style: const TextStyle(color: CosmicColors.textSecondary),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(conversationListProvider),
                child: Text(isZh ? '重试' : 'Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: CosmicColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: CosmicColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => context.push('/chat'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(
            Icons.add,
            color: CosmicColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, WidgetRef ref, bool isZh, String locale) {
    final hotScenariosAsync = ref.watch(hotScenariosProvider);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CharacterAvatar(
              expression: ExpressionId.greeting,
              size: CharacterAvatarSize.lg,
            ),
            const SizedBox(height: 20),
            Text(
              isZh ? '还没有对话' : 'No conversations yet',
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isZh
                  ? '开始一段新的对话，让星象为你指引方向'
                  : 'Start a new conversation and let the stars guide you',
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                gradient: CosmicColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.push('/chat'),
                  borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    child: Text(
                      isZh ? '开始咨询' : 'Start Consultation',
                      style: const TextStyle(
                        color: CosmicColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Hot scenarios section
            hotScenariosAsync.when(
              data: (scenarios) {
                if (scenarios.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Column(
                    children: [
                      Text(
                        isZh ? '热门话题' : 'Popular Topics',
                        style: const TextStyle(
                          color: CosmicColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: scenarios.map((s) {
                          final visual = getScenarioVisual(s.slug);
                          final title = resolveScenarioKey(
                            s.title,
                            locale,
                          );
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => context.push(
                                '/chat?scenario_id=${s.id}',
                              ),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: CosmicColors.surfaceElevated,
                                  border: Border.all(
                                    color: CosmicColors.borderGlow,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      visual.emoji,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        color: CosmicColors.textPrimary,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date, bool isZh) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return isZh ? '刚刚' : 'Just now';
    if (diff.inHours < 1) return isZh ? '${diff.inMinutes}分钟前' : '${diff.inMinutes}m ago';
    if (diff.inDays == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    if (diff.inDays == 1) return isZh ? '昨天' : 'Yesterday';
    if (diff.inDays < 7) return isZh ? '${diff.inDays}天前' : '${diff.inDays}d ago';
    return '${date.month}/${date.day}';
  }
}

class _ConversationCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _ConversationCard({
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: CosmicColors.surfaceElevated,
              border: Border.all(color: CosmicColors.borderGlow),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        CosmicColors.primary.withValues(alpha: 0.3),
                        CosmicColors.primaryLight.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    color: CosmicColors.primaryLight,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            color: CosmicColors.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: CosmicColors.textTertiary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
