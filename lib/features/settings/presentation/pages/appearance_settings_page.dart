import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/theme/theme_provider.dart';

class AppearanceSettingsPage extends ConsumerWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentMode = ref.watch(themeModeProvider);
    final reducedMotion = ref.watch(reducedMotionProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.appearanceSettings ?? 'Appearance'),
      ),
      body: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              l10n?.themeSelection ?? 'Theme',
              style: theme.textTheme.titleMedium,
            ),
          ),
          _ThemeOptionTile(
            icon: Icons.dark_mode,
            iconColor: CosmicColors.primary,
            label: l10n?.cosmicTheme ?? 'Cosmic',
            isSelected: currentMode == AppThemeMode.cosmic,
            onTap: () =>
                ref.read(themeModeProvider.notifier).state =
                    AppThemeMode.cosmic,
          ),
          _ThemeOptionTile(
            icon: Icons.light_mode,
            iconColor: CosmicColors.secondary,
            label: l10n?.classicTheme ?? 'Classic',
            isSelected: currentMode == AppThemeMode.classic,
            onTap: () =>
                ref.read(themeModeProvider.notifier).state =
                    AppThemeMode.classic,
          ),
          _ThemeOptionTile(
            icon: Icons.brightness_auto,
            iconColor: CosmicColors.textSecondary,
            label: l10n?.systemTheme ?? 'System',
            isSelected: currentMode == AppThemeMode.system,
            onTap: () =>
                ref.read(themeModeProvider.notifier).state =
                    AppThemeMode.system,
          ),
          const Divider(height: 32),
          SwitchListTile(
            title: Text(l10n?.reducedMotion ?? 'Reduced Motion'),
            subtitle: Text(
              l10n?.reducedMotionDesc ??
                  'Disable animations for accessibility',
            ),
            value: reducedMotion,
            onChanged: (value) =>
                ref.read(reducedMotionProvider.notifier).state = value,
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
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(label),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: CosmicColors.primary)
          : const Icon(Icons.radio_button_unchecked),
      onTap: onTap,
    );
  }
}
