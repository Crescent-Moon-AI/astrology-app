import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../domain/models/user_profile.dart';
import '../providers/profile_providers.dart';

class EditBirthDataPage extends ConsumerStatefulWidget {
  const EditBirthDataPage({super.key});

  @override
  ConsumerState<EditBirthDataPage> createState() => _EditBirthDataPageState();
}

class _EditBirthDataPageState extends ConsumerState<EditBirthDataPage> {
  final _locationController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(userProfileProvider);
    final formState = ref.watch(birthDataFormProvider);

    // Initialize form from profile data once
    if (!_initialized) {
      profile.whenData((p) {
        ref.read(birthDataFormProvider.notifier).initFromProfile(p);
        if (p.currentBirthPlace?.normalizedName != null) {
          _locationController.text = p.currentBirthPlace!.normalizedName!;
        }
        _initialized = true;
      });
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
        child: SingleChildScrollView(
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
                                .setBirthTimeAccuracy(BirthTimeAccuracy.exact),
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

              // Birth place
              _SectionCard(
                title: l10n.birthPlace,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _locationController,
                      style: const TextStyle(
                        color: CosmicColors.textPrimary,
                        fontSize: 15,
                      ),
                      decoration: _inputDecoration(l10n.birthPlaceSearch),
                      onChanged: (_) => setState(() {}),
                    ),
                    if (_locationController.text.trim().length >= 2)
                      _LocationResults(
                        query: _locationController.text.trim(),
                        onSelect: (candidate) {
                          ref
                              .read(birthDataFormProvider.notifier)
                              .setLocation(candidate);
                          _locationController.text = candidate.name;
                          // Dismiss keyboard
                          FocusScope.of(context).unfocus();
                        },
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

class _LocationResults extends ConsumerWidget {
  final String query;
  final ValueChanged<dynamic> onSelect;

  const _LocationResults({required this.query, required this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(locationSearchProvider(query));

    return results.when(
      data: (candidates) {
        if (candidates.isEmpty) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.only(top: 4),
          constraints: const BoxConstraints(maxHeight: 200),
          decoration: BoxDecoration(
            color: CosmicColors.surfaceHighlight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: candidates.length,
            itemBuilder: (context, index) {
              final c = candidates[index];
              return InkWell(
                onTap: () => onSelect(c),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.name,
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                      if (c.formattedAddress != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          c.formattedAddress!,
                          style: const TextStyle(
                            color: CosmicColors.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              color: CosmicColors.primary,
              strokeWidth: 2,
            ),
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
