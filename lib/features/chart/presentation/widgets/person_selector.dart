import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:astrology_app/shared/theme/cosmic_colors.dart';
import '../../domain/models/birth_data.dart';
import '../../../social/domain/models/friend_profile.dart';
import '../../../social/presentation/providers/social_providers.dart';

class PersonSelector extends ConsumerStatefulWidget {
  final String label;
  final BirthData? person;
  final ValueChanged<BirthData?> onPersonChanged;

  const PersonSelector({
    super.key,
    required this.label,
    this.person,
    required this.onPersonChanged,
  });

  @override
  ConsumerState<PersonSelector> createState() => _PersonSelectorState();
}

class _PersonSelectorState extends ConsumerState<PersonSelector> {
  FriendProfile? _selected;

  void _openArchivePicker(BuildContext context, AppLocalizations l10n) {
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');
    showModalBottomSheet<FriendProfile>(
      context: context,
      backgroundColor: CosmicColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _FriendPickerSheet(isZh: isZh, l10n: l10n),
    ).then((friend) {
      if (friend != null) {
        setState(() => _selected = friend);
        widget.onPersonChanged(_toBirthData(friend));
      }
    });
  }

  static BirthData _toBirthData(FriendProfile f) {
    return BirthData(
      name: f.name,
      birthDate: f.birthDate,
      birthTime: f.birthTime ?? '12:00',
      latitude: f.latitude,
      longitude: f.longitude,
      timezone: _parseTimezone(f.timezone),
    );
  }

  static double _parseTimezone(String tz) {
    // Handle IANA names we know
    if (tz.contains('Shanghai') ||
        tz.contains('Beijing') ||
        tz.contains('Chongqing') ||
        tz.contains('Hong_Kong') ||
        tz.contains('Taipei') ||
        tz.contains('Singapore')) {
      return 8.0;
    }
    // Handle UTC±N or GMT±N patterns
    final match = RegExp(r'[+-](\d+)(?::(\d+))?$').firstMatch(tz);
    if (match != null) {
      final hours = double.parse(match.group(1)!);
      final minutes = double.parse(match.group(2) ?? '0');
      final sign = tz.contains('-') ? -1.0 : 1.0;
      return sign * (hours + minutes / 60.0);
    }
    // Default for Chinese users
    return 8.0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CosmicColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CosmicColors.borderGlow, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          if (_selected != null) ...[
            // Show selected friend info
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: CosmicColors.primaryGradient,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 22,
                    color: CosmicColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selected!.name,
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_selected!.birthDate}'
                        '${_selected!.birthTime != null ? "  ${_selected!.birthTime}" : ""}',
                        style: const TextStyle(
                          color: CosmicColors.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                      if (_selected!.birthLocationName.isNotEmpty)
                        Text(
                          _selected!.birthLocationName,
                          style: const TextStyle(
                            color: CosmicColors.textTertiary,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _openArchivePicker(context, l10n),
                  child: Text(
                    isZh ? '更换' : 'Change',
                    style: const TextStyle(
                      color: CosmicColors.primaryLight,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Empty state — pick from archive
            GestureDetector(
              onTap: () => _openArchivePicker(context, l10n),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: CosmicColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CosmicColors.borderGlow,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.people_outline,
                      size: 32,
                      color: CosmicColors.textTertiary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isZh ? '从档案中选择' : 'Select from Archive',
                      style: const TextStyle(
                        color: CosmicColors.primaryLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isZh ? '选择已保存的好友信息' : 'Choose a saved friend profile',
                      style: const TextStyle(
                        color: CosmicColors.textTertiary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FriendPickerSheet extends ConsumerWidget {
  final bool isZh;
  final AppLocalizations l10n;

  const _FriendPickerSheet({required this.isZh, required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              isZh ? '选择档案' : 'Select Archive',
              style: const TextStyle(
                color: CosmicColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(color: CosmicColors.borderGlow, height: 1),
          Flexible(
            child: friendsAsync.when(
              data: (friends) {
                if (friends.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 48,
                          color: CosmicColors.textTertiary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isZh ? '还没有添加好友' : 'No friends added yet',
                          style: const TextStyle(
                            color: CosmicColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final f = friends[index];
                    final rel = RelationshipLabel.fromValue(f.relationshipLabel);
                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: CosmicColors.primaryGradient,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 22,
                          color: CosmicColors.textPrimary,
                        ),
                      ),
                      title: Text(
                        f.name,
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        [
                          f.birthDate,
                          if (f.birthTime != null) f.birthTime!,
                          if (rel != null)
                            (isZh ? rel.labelZH : rel.labelEN),
                        ].join('  ·  '),
                        style: const TextStyle(
                          color: CosmicColors.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                      onTap: () => Navigator.of(context).pop(f),
                    );
                  },
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: CircularProgressIndicator(
                    color: CosmicColors.primary,
                  ),
                ),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  isZh ? '加载失败，请重试' : 'Failed to load, please retry',
                  style: const TextStyle(color: CosmicColors.error),
                ),
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }
}

