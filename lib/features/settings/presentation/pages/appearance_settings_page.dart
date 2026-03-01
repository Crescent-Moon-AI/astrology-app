import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/theme/theme_provider.dart';

class AppearanceSettingsPage extends ConsumerWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final isZh = locale.startsWith('zh');
    final currentMode = ref.watch(themeModeProvider);
    final currentLocaleMode = ref.watch(localeModeProvider);
    final reducedMotion = ref.watch(reducedMotionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n?.appearanceSettings ?? '外观',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: CosmicColors.textPrimary,
          ),
        ),
        backgroundColor: CosmicColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section: Theme
          Text(
            l10n?.themeSelection ?? (isZh ? '主题' : 'Theme'),
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: CosmicColors.surfaceElevated,
              border: Border.all(color: CosmicColors.borderGlow),
            ),
            child: Column(
              children: [
                _ThemeOptionTile(
                  icon: Icons.dark_mode,
                  iconColor: CosmicColors.primary,
                  label: l10n?.cosmicTheme ?? (isZh ? '宇宙主题' : 'Cosmic'),
                  isSelected: currentMode == AppThemeMode.cosmic,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .set(AppThemeMode.cosmic),
                ),
                const Divider(
                  height: 1,
                  indent: 48,
                  color: CosmicColors.divider,
                ),
                _ThemeOptionTile(
                  icon: Icons.light_mode,
                  iconColor: CosmicColors.secondary,
                  label: l10n?.classicTheme ?? (isZh ? '经典主题' : 'Classic'),
                  isSelected: currentMode == AppThemeMode.classic,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .set(AppThemeMode.classic),
                ),
                const Divider(
                  height: 1,
                  indent: 48,
                  color: CosmicColors.divider,
                ),
                _ThemeOptionTile(
                  icon: Icons.brightness_auto,
                  iconColor: CosmicColors.textSecondary,
                  label: l10n?.systemTheme ?? (isZh ? '跟随系统' : 'System'),
                  isSelected: currentMode == AppThemeMode.system,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .set(AppThemeMode.system),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Section: Language
          Text(
            l10n?.languageSelection ?? (isZh ? '语言' : 'Language'),
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: CosmicColors.surfaceElevated,
              border: Border.all(color: CosmicColors.borderGlow),
            ),
            child: Column(
              children: [
                _ThemeOptionTile(
                  icon: Icons.translate,
                  iconColor: CosmicColors.primary,
                  label: l10n?.languageChinese ?? '中文',
                  isSelected: currentLocaleMode == AppLocaleMode.zh,
                  onTap: () => ref
                      .read(localeModeProvider.notifier)
                      .setMode(AppLocaleMode.zh),
                ),
                const Divider(
                  height: 1,
                  indent: 48,
                  color: CosmicColors.divider,
                ),
                _ThemeOptionTile(
                  icon: Icons.translate,
                  iconColor: CosmicColors.secondary,
                  label: l10n?.languageEnglish ?? 'English',
                  isSelected: currentLocaleMode == AppLocaleMode.en,
                  onTap: () => ref
                      .read(localeModeProvider.notifier)
                      .setMode(AppLocaleMode.en),
                ),
                const Divider(
                  height: 1,
                  indent: 48,
                  color: CosmicColors.divider,
                ),
                _ThemeOptionTile(
                  icon: Icons.smartphone,
                  iconColor: CosmicColors.textSecondary,
                  label:
                      l10n?.languageSystem ?? (isZh ? '跟随系统' : 'Follow System'),
                  isSelected: currentLocaleMode == AppLocaleMode.system,
                  onTap: () => ref
                      .read(localeModeProvider.notifier)
                      .setMode(AppLocaleMode.system),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Section: Accessibility
          Text(
            isZh ? '辅助功能' : 'Accessibility',
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: CosmicColors.surfaceElevated,
              border: Border.all(color: CosmicColors.borderGlow),
            ),
            child: SwitchListTile(
              title: Text(
                l10n?.reducedMotion ?? (isZh ? '减少动效' : 'Reduced Motion'),
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 15,
                ),
              ),
              subtitle: Text(
                l10n?.reducedMotionDesc ??
                    (isZh
                        ? '关闭动画以提高可访问性'
                        : 'Disable animations for accessibility'),
                style: const TextStyle(
                  color: CosmicColors.textTertiary,
                  fontSize: 13,
                ),
              ),
              value: reducedMotion,
              activeColor: CosmicColors.primary,
              onChanged: (value) =>
                  ref.read(reducedMotionProvider.notifier).set(value),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.isSelected,
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
            Icon(icon, color: iconColor, size: 22),
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
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected
                  ? CosmicColors.primary
                  : CosmicColors.textTertiary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
