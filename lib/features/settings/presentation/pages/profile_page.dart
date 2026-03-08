import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/character_avatar.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../../../shared/models/expression.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Top bar with invite code and message icon
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        l10n.profileInviteCode,
                        style: const TextStyle(
                          color: CosmicColors.textTertiary,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        user?.username ?? user?.email ?? '',
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.mail_outline,
                          color: CosmicColors.textSecondary, size: 22),
                    ],
                  ),
                ),

                // Avatar section
                const SizedBox(height: 8),
                const CharacterAvatar(
                  expression: ExpressionId.greeting,
                  size: CharacterAvatarSize.lg,
                ),
                const SizedBox(height: 12),
                Text(
                  user?.username ?? user?.email ?? l10n.profileNotLoggedIn,
                  style: const TextStyle(
                    color: CosmicColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time, color: CosmicColors.textTertiary, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      l10n.profileCompanionDays(23),
                      style: const TextStyle(
                        color: CosmicColors.textTertiary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Wallet button
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: CosmicColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: CosmicColors.borderGlow),
                    ),
                    child: Text(
                      '${l10n.profileMyWallet} >',
                      style: const TextStyle(
                        color: CosmicColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Benefits section
                _buildBenefitsCard(l10n),
                const SizedBox(height: 16),

                // Grid: Archives, History, Reports
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildGridCard(
                          icon: Icons.folder_outlined,
                          label: l10n.profileArchives,
                          subtitle: l10n.profileArchivesSubtitle,
                          onTap: () => context.push('/friends'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          children: [
                            _buildSmallGridCard(
                              icon: Icons.history,
                              label: l10n.profileConsultHistory,
                              onTap: () => context.push('/conversations'),
                            ),
                            const SizedBox(height: 8),
                            _buildSmallGridCard(
                              icon: Icons.description_outlined,
                              label: l10n.profileReports,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Services section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          l10n.profileServicesTools,
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
                        ),
                        child: Column(
                          children: [
                            _buildServiceItem(
                              Icons.style_outlined,
                              l10n.profileTarotGallery,
                              () => context.push('/tarot-gallery'),
                            ),
                            const Divider(height: 1, indent: 48, color: CosmicColors.divider),
                            _buildServiceItem(
                              Icons.auto_awesome_mosaic_outlined,
                              l10n.divinationHubTitle,
                              () => context.push('/divination'),
                            ),
                            const Divider(height: 1, indent: 48, color: CosmicColors.divider),
                            _buildServiceItem(
                              Icons.help_outline,
                              l10n.profileHelpFeedback,
                              () {},
                            ),
                            const Divider(height: 1, indent: 48, color: CosmicColors.divider),
                            _buildServiceItem(
                              Icons.share_outlined,
                              l10n.profileShareApp,
                              () {},
                            ),
                            const Divider(height: 1, indent: 48, color: CosmicColors.divider),
                            _buildServiceItem(
                              Icons.star_outline,
                              l10n.profileRateUs,
                              () {},
                            ),
                            const Divider(height: 1, indent: 48, color: CosmicColors.divider),
                            _buildServiceItem(
                              Icons.settings_outlined,
                              l10n.profileSettingsItem,
                              () => context.push('/settings/appearance'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                    label: Text(l10n.profileLogout),
                    style: TextButton.styleFrom(
                      foregroundColor: CosmicColors.error,
                    ),
                  ),
                ),

                const SizedBox(height: 100), // bottom padding for nav bar
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitsCard(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              CosmicColors.primary.withAlpha(38),
              CosmicColors.surfaceElevated,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CosmicColors.borderGlow),
        ),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome,
                color: CosmicColors.primaryLight, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.profileMyBenefits,
                    style: const TextStyle(
                      color: CosmicColors.primaryLight,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.profileFreeToday,
                    style: const TextStyle(
                      color: CosmicColors.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.profileUnlockMore,
                    style: const TextStyle(
                      color: CosmicColors.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: CosmicColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                l10n.profileUpgrade,
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
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
                Icon(icon, color: CosmicColors.textPrimary, size: 20),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: CosmicColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right,
                    color: CosmicColors.textTertiary, size: 18),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.add_circle_outline,
                    color: CosmicColors.textTertiary, size: 16),
                const SizedBox(width: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: CosmicColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallGridCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: CosmicColors.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CosmicColors.borderGlow),
        ),
        child: Row(
          children: [
            Icon(icon, color: CosmicColors.textPrimary, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right,
                color: CosmicColors.textTertiary, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(IconData icon, String label, VoidCallback onTap) {
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
