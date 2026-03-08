import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../../../shared/widgets/character_avatar.dart';
import '../../../../shared/models/expression.dart';
import '../../../settings/presentation/widgets/china_region_picker.dart';
import '../../../settings/presentation/providers/profile_providers.dart';
import '../../../settings/domain/models/location_candidate.dart';
import '../../domain/models/friend_profile.dart';
import '../providers/social_providers.dart';

class AddFriendPage extends ConsumerStatefulWidget {
  const AddFriendPage({super.key});

  @override
  ConsumerState<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends ConsumerState<AddFriendPage> {
  final _nicknameController = TextEditingController();

  // Basic info
  bool _isMale = false; // false = female, true = male
  RelationshipLabel? _selectedRelationship;

  // Birth info
  DateTime? _birthDate;
  TimeOfDay? _birthTime;
  bool _timeUnknown = false;
  String? _selectedRegionDisplay;
  LocationCandidate? _selectedLocation;
  String? _initialProvince;
  String? _initialCity;
  String? _initialDistrict;

  bool _saving = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: CosmicColors.primary,
            surface: CosmicColors.background,
            onSurface: CosmicColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _birthTime ?? const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: CosmicColors.primary,
            surface: CosmicColors.background,
            onSurface: CosmicColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _birthTime = picked;
        _timeUnknown = false;
      });
    }
  }

  Future<void> _pickRegion() async {
    final result = await showChinaRegionPicker(
      context,
      initialProvince: _initialProvince,
      initialCity: _initialCity,
      initialDistrict: _initialDistrict,
    );
    if (result == null || !mounted) return;

    setState(() {
      _selectedRegionDisplay = result.displayName;
      _initialProvince = result.province;
      _initialCity = result.city;
      _initialDistrict = result.district;
    });

    // Geocode
    try {
      final repo = ref.read(profileRepositoryProvider);
      final geocode = await repo.resolveLocation(result.displayName);
      if (geocode.candidates.isNotEmpty) {
        setState(() => _selectedLocation = geocode.candidates.first);
      } else {
        setState(() => _selectedLocation = LocationCandidate(
              name: result.displayName,
              latitude: 0,
              longitude: 0,
            ));
      }
    } catch (_) {
      setState(() => _selectedLocation = LocationCandidate(
            name: result.displayName,
            latitude: 0,
            longitude: 0,
          ));
    }
  }

  void _showRelationshipPicker() {
    final l10n = AppLocalizations.of(context)!;
    final isZh =
        Localizations.localeOf(context).languageCode.startsWith('zh');

    showModalBottomSheet(
      context: context,
      backgroundColor: CosmicColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.friendTaRelationship,
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(height: 1, color: CosmicColors.borderGlow),
            ...RelationshipLabel.values.map((rel) {
              final label = isZh ? rel.labelZH : rel.labelEN;
              final selected = _selectedRelationship == rel;
              return ListTile(
                title: Text(
                  label,
                  style: TextStyle(
                    color: selected
                        ? CosmicColors.primaryLight
                        : CosmicColors.textPrimary,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                trailing: selected
                    ? const Icon(Icons.check, color: CosmicColors.primary, size: 20)
                    : null,
                onTap: () {
                  setState(() => _selectedRelationship = rel);
                  Navigator.pop(ctx);
                },
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nicknameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.friendNicknamePlaceholder)),
      );
      return;
    }
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.birthDataRequired)),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      String? birthTimeStr;
      if (_birthTime != null && !_timeUnknown) {
        birthTimeStr =
            '${_birthTime!.hour.toString().padLeft(2, '0')}:${_birthTime!.minute.toString().padLeft(2, '0')}';
      }

      final repo = ref.read(socialRepositoryProvider);
      await repo.createFriend(
        name: name,
        birthDate: DateFormat('yyyy-MM-dd').format(_birthDate!),
        birthTime: birthTimeStr,
        latitude: _selectedLocation?.latitude ?? 0.0,
        longitude: _selectedLocation?.longitude ?? 0.0,
        timezone: _selectedLocation?.timezone ?? 'Asia/Shanghai',
        birthLocationName: _selectedRegionDisplay,
        relationshipLabel: _selectedRelationship?.value,
      );

      ref.invalidate(friendsProvider);

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isZh =
        Localizations.localeOf(context).languageCode.startsWith('zh');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: CosmicColors.textPrimary),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.person_add_alt_1,
                color: CosmicColors.primaryLight, size: 18),
            label: Text(
              l10n.friendInvite,
              style: const TextStyle(
                color: CosmicColors.primaryLight,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
      body: StarfieldBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Avatar illustration ---
              Center(
                child: SizedBox(
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        child: CharacterAvatar(
                          expression: ExpressionId.happy,
                          size: CharacterAvatarSize.md,
                        ),
                      ),
                      const Icon(Icons.add,
                          color: CosmicColors.textTertiary, size: 20),
                      Positioned(
                        right: 0,
                        child: CharacterAvatar(
                          expression: ExpressionId.mysterious,
                          size: CharacterAvatarSize.md,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // --- Title & subtitle ---
              Text(
                l10n.friendFillBirthInfo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: CosmicColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.friendFillBirthInfoSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: CosmicColors.textTertiary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),

              // ====== Basic Info Section ======
              _SectionHeader(title: l10n.friendBasicInfo),
              const SizedBox(height: 12),

              // Gender selector
              Row(
                children: [
                  Expanded(
                    child: _GenderButton(
                      label: l10n.friendGenderFemale,
                      icon: Icons.female,
                      selected: !_isMale,
                      onTap: () => setState(() => _isMale = false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _GenderButton(
                      label: l10n.friendGenderMale,
                      icon: Icons.male,
                      selected: _isMale,
                      onTap: () => setState(() => _isMale = true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Nickname
              _FieldRow(
                label: l10n.friendNickname,
                child: Expanded(
                  child: TextField(
                    controller: _nicknameController,
                    style: const TextStyle(
                        color: CosmicColors.textPrimary, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: l10n.friendNicknamePlaceholder,
                      hintStyle:
                          const TextStyle(color: CosmicColors.textTertiary),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Relationship
              _FieldRow(
                label: l10n.friendTaRelationship,
                onTap: _showRelationshipPicker,
                child: Expanded(
                  child: Row(
                    children: [
                      Text(
                        _selectedRelationship != null
                            ? (isZh
                                ? _selectedRelationship!.labelZH
                                : _selectedRelationship!.labelEN)
                            : '',
                        style: TextStyle(
                          color: _selectedRelationship != null
                              ? CosmicColors.textPrimary
                              : CosmicColors.textTertiary,
                          fontSize: 15,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right,
                          color: CosmicColors.textTertiary, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ====== Birth Info Section ======
              _SectionHeader(title: l10n.friendBirthInfo),
              const SizedBox(height: 12),

              // Calendar type toggle (solar/lunar)
              Row(
                children: [
                  _ToggleChip(
                    label: l10n.friendCalendarSolar,
                    selected: true,
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                  _ToggleChip(
                    label: l10n.friendCalendarLunar,
                    selected: false,
                    onTap: () {},
                  ),
                  const Spacer(),
                  // Date display
                  InkWell(
                    onTap: _pickDate,
                    child: Row(
                      children: [
                        _DatePart(
                          text: _birthDate != null
                              ? '${_birthDate!.year}'
                              : isZh ? '年' : 'Year',
                          hasValue: _birthDate != null,
                        ),
                        _DatePart(
                          text: _birthDate != null
                              ? '${_birthDate!.month}'
                              : isZh ? '月' : 'Mon',
                          hasValue: _birthDate != null,
                        ),
                        _DatePart(
                          text: _birthDate != null
                              ? '${_birthDate!.day}'
                              : isZh ? '日' : 'Day',
                          hasValue: _birthDate != null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Birth time
              _FieldRow(
                label: l10n.birthTime,
                onTap: _timeUnknown ? null : _pickTime,
                child: Expanded(
                  child: Text(
                    _birthTime != null && !_timeUnknown
                        ? _birthTime!.format(context)
                        : l10n.friendSelectBirthTime,
                    style: TextStyle(
                      color: _birthTime != null && !_timeUnknown
                          ? CosmicColors.textPrimary
                          : CosmicColors.textTertiary,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Unknown time checkbox
              Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: _timeUnknown,
                      onChanged: (v) {
                        setState(() {
                          _timeUnknown = v ?? false;
                          if (_timeUnknown) _birthTime = null;
                        });
                      },
                      activeColor: CosmicColors.primary,
                      checkColor: CosmicColors.textPrimary,
                      side: const BorderSide(color: CosmicColors.textTertiary),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.friendUnknownExactTime,
                    style: const TextStyle(
                      color: CosmicColors.textTertiary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Birth place
              _FieldRow(
                label: l10n.birthPlace,
                onTap: _pickRegion,
                child: Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedRegionDisplay ?? l10n.friendSelectBirthCity,
                          style: TextStyle(
                            color: _selectedRegionDisplay != null
                                ? CosmicColors.textPrimary
                                : CosmicColors.textTertiary,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.chevron_right,
                          color: CosmicColors.textTertiary, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // ====== Save Button ======
              Container(
                height: 48,
                decoration: BoxDecoration(
                  gradient: CosmicColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: CosmicColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _saving ? null : _save,
                    borderRadius: BorderRadius.circular(24),
                    child: Center(
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: CosmicColors.textPrimary,
                              ),
                            )
                          : Text(
                              l10n.friendSave,
                              style: const TextStyle(
                                color: CosmicColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable widgets ────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: CosmicColors.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? CosmicColors.primary.withValues(alpha: 0.15)
              : CosmicColors.surfaceElevated,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? CosmicColors.primary : CosmicColors.borderGlow,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: selected
                    ? CosmicColors.primaryLight
                    : CosmicColors.textTertiary,
                size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? CosmicColors.primaryLight
                    : CosmicColors.textSecondary,
                fontSize: 15,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final Widget child;
  final VoidCallback? onTap;

  const _FieldRow({
    required this.label,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: CosmicColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CosmicColors.borderGlow),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? CosmicColors.primary.withValues(alpha: 0.2)
              : CosmicColors.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? CosmicColors.primary : CosmicColors.borderGlow,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? CosmicColors.primaryLight
                : CosmicColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _DatePart extends StatelessWidget {
  final String text;
  final bool hasValue;

  const _DatePart({required this.text, required this.hasValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: hasValue
              ? CosmicColors.textPrimary
              : CosmicColors.textTertiary,
          fontSize: 14,
        ),
      ),
    );
  }
}
