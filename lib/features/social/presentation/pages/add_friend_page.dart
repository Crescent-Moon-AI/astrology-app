import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../../shared/theme/cosmic_colors.dart';
import '../../domain/models/friend_profile.dart';
import '../providers/social_providers.dart';

class AddFriendPage extends ConsumerStatefulWidget {
  const AddFriendPage({super.key});

  @override
  ConsumerState<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends ConsumerState<AddFriendPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();

  DateTime? _birthDate;
  TimeOfDay? _birthTime;
  String _timezone = 'Asia/Shanghai';
  RelationshipLabel? _selectedRelationship;
  bool _saving = false;

  static const _timezones = [
    'Asia/Shanghai',
    'Asia/Tokyo',
    'America/New_York',
    'America/Los_Angeles',
    'America/Chicago',
    'Europe/London',
    'Europe/Paris',
    'Europe/Berlin',
    'Australia/Sydney',
    'Pacific/Auckland',
    'UTC',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  InputDecoration _cosmicInputDecoration({
    required String labelText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: CosmicColors.textSecondary),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: CosmicColors.primaryLight, size: 20)
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CosmicColors.borderGlow),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CosmicColors.borderGlow),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CosmicColors.primary, width: 1.5),
      ),
      filled: true,
      fillColor: CosmicColors.surfaceElevated,
    );
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: CosmicColors.primary,
              surface: CosmicColors.background,
              onSurface: CosmicColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  Future<void> _pickBirthTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _birthTime ?? const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: CosmicColors.primary,
              surface: CosmicColors.background,
              onSurface: CosmicColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _birthTime = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null) return;

    setState(() => _saving = true);

    try {
      final lat = double.tryParse(_latController.text) ?? 0.0;
      final lon = double.tryParse(_lonController.text) ?? 0.0;

      String? birthTimeStr;
      if (_birthTime != null) {
        birthTimeStr =
            '${_birthTime!.hour.toString().padLeft(2, '0')}:${_birthTime!.minute.toString().padLeft(2, '0')}';
      }

      final repo = ref.read(socialRepositoryProvider);
      await repo.createFriend(
        name: _nameController.text.trim(),
        birthDate: DateFormat('yyyy-MM-dd').format(_birthDate!),
        birthTime: birthTimeStr,
        latitude: lat,
        longitude: lon,
        timezone: _timezone,
        birthLocationName: _locationController.text.trim().isNotEmpty
            ? _locationController.text.trim()
            : null,
        relationshipLabel: _selectedRelationship?.value,
      );

      ref.invalidate(friendsProvider);

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final isZh = locale.startsWith('zh');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.addFriend,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: CosmicColors.textPrimary,
          ),
        ),
        backgroundColor: CosmicColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: CosmicColors.textPrimary),
                decoration: _cosmicInputDecoration(
                  labelText: l10n.friendName,
                  prefixIcon: Icons.person,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.friendName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Birth Date
              InkWell(
                onTap: _pickBirthDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: _cosmicInputDecoration(
                    labelText: l10n.friendBirthDate,
                    prefixIcon: Icons.calendar_today,
                  ),
                  child: Text(
                    _birthDate != null
                        ? DateFormat('yyyy-MM-dd').format(_birthDate!)
                        : '',
                    style: const TextStyle(color: CosmicColors.textPrimary),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Birth Time (optional)
              InkWell(
                onTap: _pickBirthTime,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: _cosmicInputDecoration(
                    labelText: l10n.friendBirthTime,
                    prefixIcon: Icons.access_time,
                  ),
                  child: Text(
                    _birthTime != null ? _birthTime!.format(context) : '',
                    style: const TextStyle(color: CosmicColors.textPrimary),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Location search
              TextFormField(
                controller: _locationController,
                style: const TextStyle(color: CosmicColors.textPrimary),
                decoration: _cosmicInputDecoration(
                  labelText: l10n.friendLocation,
                  prefixIcon: Icons.location_on,
                ),
              ),
              const SizedBox(height: 16),

              // Latitude & Longitude
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latController,
                      style: const TextStyle(color: CosmicColors.textPrimary),
                      decoration: _cosmicInputDecoration(
                        labelText: isZh ? '纬度' : 'Latitude',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _lonController,
                      style: const TextStyle(color: CosmicColors.textPrimary),
                      decoration: _cosmicInputDecoration(
                        labelText: isZh ? '经度' : 'Longitude',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Timezone dropdown
              DropdownButtonFormField<String>(
                initialValue: _timezone,
                dropdownColor: CosmicColors.background,
                style: const TextStyle(color: CosmicColors.textPrimary),
                decoration: _cosmicInputDecoration(
                  labelText: l10n.friendTimezone,
                  prefixIcon: Icons.public,
                ),
                items: _timezones
                    .map((tz) => DropdownMenuItem(
                          value: tz,
                          child: Text(tz),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _timezone = value);
                  }
                },
              ),
              const SizedBox(height: 20),

              // Relationship label chips
              Text(
                l10n.friendRelationship,
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: RelationshipLabel.values.map((rel) {
                  final isSelected = _selectedRelationship == rel;
                  final displayLabel =
                      isZh ? rel.labelZH : rel.labelEN;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRelationship = isSelected ? null : rel;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isSelected
                            ? CosmicColors.primary.withValues(alpha: 0.25)
                            : CosmicColors.surfaceElevated,
                        border: Border.all(
                          color: isSelected
                              ? CosmicColors.primary
                              : CosmicColors.borderGlow,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        displayLabel,
                        style: TextStyle(
                          color: isSelected
                              ? CosmicColors.primaryLight
                              : CosmicColors.textSecondary,
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Save button
              Container(
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
