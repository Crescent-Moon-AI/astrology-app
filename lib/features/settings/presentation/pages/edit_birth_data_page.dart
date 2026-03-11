import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:astrology_app/src/rust/api/api/astro.dart' as astro_ffi;

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/breathing_loader.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../domain/models/location_candidate.dart';
import '../../domain/models/user_profile.dart';
import '../providers/profile_providers.dart';
import '../widgets/china_region_picker.dart';

class EditBirthDataPage extends ConsumerStatefulWidget {
  const EditBirthDataPage({super.key});

  @override
  ConsumerState<EditBirthDataPage> createState() => _EditBirthDataPageState();
}

class _EditBirthDataPageState extends ConsumerState<EditBirthDataPage> {
  final _locationController = TextEditingController();
  bool _initialized = false;
  String? _selectedRegionDisplay;
  String? _initialProvince;
  String? _initialCity;
  String? _initialDistrict;

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _initFromProfile(UserProfile p) {
    if (_initialized) return;
    _initialized = true;

    ref.read(birthDataFormProvider.notifier).initFromProfile(p);
    if (p.currentBirthPlace?.normalizedName != null) {
      final name = p.currentBirthPlace!.normalizedName!;
      _locationController.text = name;
      _selectedRegionDisplay = name;
      // Try to parse "省 - 市 - 区" format for initial picker position
      final parts = name.split(' - ');
      if (parts.length >= 3) {
        _initialProvince = parts[0].trim();
        _initialCity = parts[1].trim();
        _initialDistrict = parts[2].trim();
      }

      // If coordinates are missing/invalid, re-geocode from name
      final place = p.currentBirthPlace!;
      final hasValidCoords =
          place.latitude != null &&
          place.longitude != null &&
          (place.latitude != 0 || place.longitude != 0) &&
          place.timezone != null;
      if (!hasValidCoords) {
        _resolveLocation(name);
      }
    }
  }

  /// Unified geocoding: local FFI first, then backend API fallback.
  Future<void> _resolveLocation(String displayName) async {
    // Try local FFI geocoding first (embedded Chinese city data)
    try {
      final jsonStr = await astro_ffi.geocodeChina(query: displayName);
      final List<dynamic> locations = json.decode(jsonStr) as List<dynamic>;
      if (locations.isNotEmpty) {
        final loc = locations[0] as Map<String, dynamic>;
        ref
            .read(birthDataFormProvider.notifier)
            .setLocation(
              LocationCandidate(
                name: loc['formatted_address'] as String? ?? displayName,
                latitude: (loc['latitude'] as num?)?.toDouble() ?? 0,
                longitude: (loc['longitude'] as num?)?.toDouble() ?? 0,
                timezone: loc['timezone'] as String?,
                countryCode: loc['country_code'] as String?,
                adminArea: loc['admin_area'] as String?,
                confidence: (loc['confidence'] as num?)?.toDouble(),
              ),
            );
        return;
      }
    } catch (_) {
      // FFI failed, fall through to backend API
    }

    // Fallback: backend geocoding API
    try {
      final repo = ref.read(profileRepositoryProvider);
      final geocode = await repo.resolveLocation(displayName);
      if (geocode.candidates.isNotEmpty) {
        ref
            .read(birthDataFormProvider.notifier)
            .setLocation(geocode.candidates.first);
      }
    } catch (_) {
      // Both failed, keep existing location data
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(userProfileProvider);
    final formState = ref.watch(birthDataFormProvider);

    // Listen for loading → data transitions (e.g. provider was still
    // loading on the first build and resolves on a later frame).
    ref.listen<AsyncValue<UserProfile>>(userProfileProvider, (_, next) {
      next.whenData((p) {
        if (!_initialized) {
          setState(() => _initFromProfile(p));
        }
      });
    });

    // If data is already available on first build, init synchronously
    // (local state is set before the rest of build() reads it).
    if (!_initialized) {
      profile.whenData((p) => _initFromProfile(p));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.profileEditBirthData,
          style: const TextStyle(
            color: CosmicColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: CosmicColors.textPrimary),
      ),
      body: StarfieldBackground(
        child: profile.when(
          loading: () => const Center(child: BreathingLoader()),
          error: (_, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: CosmicColors.textTertiary,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.errorLoadFailed,
                    style: const TextStyle(
                      color: CosmicColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => ref.invalidate(userProfileProvider),
                    child: Text(
                      l10n.retry,
                      style: const TextStyle(
                        color: CosmicColors.primaryLight,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          data: (_) => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Birth date
                _SectionCard(
                  title: l10n.birthDate,
                  child: InkWell(
                    onTap: () => _pickDate(context),
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: _inputDecoration(l10n.birthDate),
                      child: Text(
                        formState.birthDate != null
                            ? _formatDate(formState.birthDate!)
                            : l10n.birthDate,
                        style: TextStyle(
                          color: formState.birthDate != null
                              ? CosmicColors.textPrimary
                              : CosmicColors.textTertiary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Birth time
                _SectionCard(
                  title: l10n.birthTime,
                  child: Column(
                    children: [
                      // Time unknown toggle
                      Row(
                        children: [
                          Checkbox(
                            value:
                                formState.birthTimeAccuracy ==
                                BirthTimeAccuracy.unknown,
                            onChanged: (checked) {
                              final notifier = ref.read(
                                birthDataFormProvider.notifier,
                              );
                              if (checked == true) {
                                notifier.setBirthTimeAccuracy(
                                  BirthTimeAccuracy.unknown,
                                );
                              } else {
                                notifier.setBirthTimeAccuracy(
                                  BirthTimeAccuracy.exact,
                                );
                              }
                            },
                            activeColor: CosmicColors.primary,
                            checkColor: CosmicColors.textPrimary,
                            side: const BorderSide(
                              color: CosmicColors.textTertiary,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              l10n.birthTimeUnknown,
                              style: const TextStyle(
                                color: CosmicColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (formState.birthTimeAccuracy !=
                          BirthTimeAccuracy.unknown) ...[
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _pickTime(context),
                          borderRadius: BorderRadius.circular(12),
                          child: InputDecorator(
                            decoration: _inputDecoration(l10n.birthTime),
                            child: Text(
                              formState.birthTime != null
                                  ? _formatTime(formState.birthTime!)
                                  : l10n.birthTime,
                              style: TextStyle(
                                color: formState.birthTime != null
                                    ? CosmicColors.textPrimary
                                    : CosmicColors.textTertiary,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Accuracy selector
                        Row(
                          children: [
                            _AccuracyChip(
                              label: l10n.birthTimeExact,
                              selected:
                                  formState.birthTimeAccuracy ==
                                  BirthTimeAccuracy.exact,
                              onTap: () => ref
                                  .read(birthDataFormProvider.notifier)
                                  .setBirthTimeAccuracy(
                                    BirthTimeAccuracy.exact,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            _AccuracyChip(
                              label: l10n.birthTimeApproximate,
                              selected:
                                  formState.birthTimeAccuracy ==
                                  BirthTimeAccuracy.approximate,
                              onTap: () => ref
                                  .read(birthDataFormProvider.notifier)
                                  .setBirthTimeAccuracy(
                                    BirthTimeAccuracy.approximate,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Birth place — tap to open region picker
                _SectionCard(
                  title: l10n.birthPlace,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => _pickRegion(context),
                        borderRadius: BorderRadius.circular(12),
                        child: InputDecorator(
                          decoration: _inputDecoration(l10n.birthPlaceSearch),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedRegionDisplay ??
                                      l10n.birthPlaceSearch,
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
                              const Icon(
                                Icons.chevron_right,
                                color: CosmicColors.textTertiary,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (formState.selectedLocation != null &&
                          formState.selectedLocation!.timezone != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule,
                              size: 14,
                              color: CosmicColors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.birthPlaceTimezone(
                                formState.selectedLocation!.timezone!,
                              ),
                              style: const TextStyle(
                                color: CosmicColors.textTertiary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Error
                if (formState.error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CosmicColors.error.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      formState.error!,
                      style: const TextStyle(
                        color: CosmicColors.error,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Save button
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: CosmicColors.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: formState.isSaving ? null : () => _save(context),
                      borderRadius: BorderRadius.circular(24),
                      child: Center(
                        child: formState.isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: CosmicColors.textPrimary,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                l10n.birthDataSave,
                                style: const TextStyle(
                                  color: CosmicColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
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
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: CosmicColors.textTertiary),
      filled: true,
      fillColor: CosmicColors.surfaceElevated,
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
        borderSide: const BorderSide(color: CosmicColors.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final formState = ref.read(birthDataFormProvider);
    final date = await showDatePicker(
      context: context,
      initialDate: formState.birthDate ?? DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: CosmicColors.primary,
            surface: CosmicColors.background,
          ),
        ),
        child: child!,
      ),
    );
    if (date != null) {
      ref.read(birthDataFormProvider.notifier).setBirthDate(date);
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final formState = ref.read(birthDataFormProvider);
    final time = await showTimePicker(
      context: context,
      initialTime: formState.birthTime ?? const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: CosmicColors.primary,
            surface: CosmicColors.background,
          ),
        ),
        child: child!,
      ),
    );
    if (time != null) {
      ref.read(birthDataFormProvider.notifier).setBirthTime(time);
    }
  }

  Future<void> _pickRegion(BuildContext context) async {
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

    await _resolveLocation(result.displayName);
  }

  Future<void> _save(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final formState = ref.read(birthDataFormProvider);

    if (formState.birthDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.birthDataRequired)));
      return;
    }

    final success = await ref.read(birthDataFormProvider.notifier).save();
    if (success && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.birthDataSaved)));
      context.pop();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _AccuracyChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AccuracyChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? CosmicColors.primary.withValues(alpha: 0.2)
              : CosmicColors.surface,
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
