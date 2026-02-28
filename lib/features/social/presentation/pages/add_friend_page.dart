import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
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

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  Future<void> _pickBirthTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _birthTime ?? const TimeOfDay(hour: 12, minute: 0),
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
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addFriend),
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
                decoration: InputDecoration(
                  labelText: l10n.friendName,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
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
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.friendBirthDate,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _birthDate != null
                        ? DateFormat('yyyy-MM-dd').format(_birthDate!)
                        : '',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Birth Time (optional)
              InkWell(
                onTap: _pickBirthTime,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.friendBirthTime,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.access_time),
                  ),
                  child: Text(
                    _birthTime != null ? _birthTime!.format(context) : '',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Location search
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: l10n.friendLocation,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),

              // Latitude & Longitude
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latController,
                      decoration: const InputDecoration(
                        labelText: 'Latitude',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _lonController,
                      decoration: const InputDecoration(
                        labelText: 'Longitude',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Timezone dropdown
              DropdownButtonFormField<String>(
                initialValue: _timezone,
                decoration: InputDecoration(
                  labelText: l10n.friendTimezone,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.public),
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
              const SizedBox(height: 16),

              // Relationship label chips
              Text(
                l10n.friendRelationship,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: RelationshipLabel.values.map((rel) {
                  final isSelected = _selectedRelationship == rel;
                  final displayLabel =
                      locale == 'zh' ? rel.labelZH : rel.labelEN;
                  return ChoiceChip(
                    label: Text(displayLabel),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedRelationship = selected ? rel : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Save button
              FilledButton(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.friendSave),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
