import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/character_avatar.dart';
import '../../../../shared/models/expression.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final isZh = locale.startsWith('zh');
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(isZh ? '我的' : 'Profile'),
        backgroundColor: CosmicColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User info card
          Container(
            padding: const EdgeInsets.all(20),
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
            child: Row(
              children: [
                const CharacterAvatar(
                  expression: ExpressionId.greeting,
                  size: CharacterAvatarSize.md,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.username ??
                            user?.email ??
                            (isZh ? '未登录' : 'Not logged in'),
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(
                          color: CosmicColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Menu items
          _MenuSection(
            title: isZh ? '功能' : 'Features',
            items: [
              _MenuItem(
                icon: Icons.people_outline,
                label: l10n.friendsTitle,
                onTap: () => context.push('/friends'),
              ),
              _MenuItem(
                icon: Icons.mood_outlined,
                label: l10n.moodHistoryTitle,
                onTap: () => context.push('/mood/history'),
              ),
              _MenuItem(
                icon: Icons.insights_outlined,
                label: l10n.moodInsightsTitle,
                onTap: () => context.push('/mood/insights'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _MenuSection(
            title: isZh ? '设置' : 'Settings',
            items: [
              _MenuItem(
                icon: Icons.palette_outlined,
                label: l10n.appearanceSettings,
                onTap: () => context.push('/settings/appearance'),
              ),
              _MenuItem(
                icon: Icons.auto_awesome_outlined,
                label: l10n.characterAboutTitle,
                onTap: () => context.push('/character'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Logout button
          Center(
            child: TextButton.icon(
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              icon: const Icon(Icons.logout, size: 18),
              label: Text(isZh ? '退出登录' : 'Logout'),
              style: TextButton.styleFrom(
                foregroundColor: CosmicColors.error,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Version
          Center(
            child: Text(
              'v0.1.0',
              style: TextStyle(
                color: CosmicColors.textTertiary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: CosmicColors.surfaceElevated,
            border: Border.all(color: CosmicColors.borderGlow),
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                items[i],
                if (i < items.length - 1)
                  const Divider(
                    height: 1,
                    indent: 48,
                    color: CosmicColors.divider,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: CosmicColors.textSecondary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 15,
                ),
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
    );
  }
}
