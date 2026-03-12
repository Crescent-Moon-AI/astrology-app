import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/src/rust/api/api/astro.dart' as astro_ffi;
import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../../settings/domain/models/location_candidate.dart';
import '../../../settings/presentation/providers/profile_providers.dart';
import '../../../settings/presentation/widgets/china_region_picker.dart';
import '../providers/auth_providers.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _pageController = PageController();
  final _nicknameCtrl = TextEditingController();
  int _currentStep = 0;
  DateTime? _birthDate;
  TimeOfDay? _birthTime;
  bool _saving = false;
  bool _prefilled = false;

  // Birth place (from ChinaRegionPicker)
  String? _birthPlaceDisplay;
  double? _birthPlaceLat;
  double? _birthPlaceLng;
  String? _birthPlaceTimezone;

  @override
  void dispose() {
    _pageController.dispose();
    _nicknameCtrl.dispose();
    super.dispose();
  }

  void _prefillFromUser() {
    if (_prefilled) return;
    _prefilled = true;
    final user = ref.read(authProvider).user;
    if (user == null) return;
    if (user.username != null) _nicknameCtrl.text = user.username!;
  }

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      _finish();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  String _extractError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        return error['message'] as String? ?? '未知错误';
      }
      if (error is String) return error;
    }
    return e.message ?? '网络错误';
  }

  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        return _nicknameCtrl.text.trim().isNotEmpty;
      case 1:
        return _birthDate != null;
      case 2:
        return true; // birth place is optional
      default:
        return false;
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: CosmicColors.primary,
              surface: CosmicColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null && mounted) {
      setState(() => _birthDate = date);
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _birthTime ?? const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: CosmicColors.primary,
              surface: CosmicColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null && mounted) {
      setState(() => _birthTime = time);
    }
  }

  Future<void> _pickBirthPlace() async {
    final result = await showChinaRegionPicker(context);
    if (result == null || !mounted) return;

    setState(() => _birthPlaceDisplay = result.displayName);

    // Geocode via local FFI
    try {
      final jsonStr = await astro_ffi.geocodeChina(query: result.displayName);
      final List<dynamic> locations = json.decode(jsonStr) as List<dynamic>;
      if (locations.isNotEmpty) {
        final loc = locations[0] as Map<String, dynamic>;
        setState(() {
          _birthPlaceLat = (loc['latitude'] as num?)?.toDouble();
          _birthPlaceLng = (loc['longitude'] as num?)?.toDouble();
          _birthPlaceTimezone = loc['timezone'] as String?;
        });
      }
    } catch (_) {
      // Geocoding failed — we still have the display name
    }
  }

  Future<void> _finish() async {
    setState(() => _saving = true);

    final nickname = _nicknameCtrl.text.trim();

    // Format date/time strings
    String? dateStr;
    if (_birthDate != null) {
      dateStr =
          '${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}';
    }
    String? timeStr;
    String timeAccuracy = 'unknown';
    if (_birthTime != null) {
      timeStr =
          '${_birthTime!.hour.toString().padLeft(2, '0')}:${_birthTime!.minute.toString().padLeft(2, '0')}';
      timeAccuracy = 'exact';
    }

    // Build LocationCandidate for birth place
    LocationCandidate? birthPlace;
    if (_birthPlaceDisplay != null &&
        _birthPlaceLat != null &&
        _birthPlaceLng != null) {
      birthPlace = LocationCandidate(
        name: _birthPlaceDisplay!,
        latitude: _birthPlaceLat!,
        longitude: _birthPlaceLng!,
        timezone: _birthPlaceTimezone,
      );
    }

    try {
      // Update username first (may fail on conflict)
      if (nickname.isNotEmpty) {
        final datasource = ref.read(authDatasourceProvider);
        await datasource.updateProfile({'username': nickname});
      }

      // Save birth data to structured profile (single source of truth)
      final repo = ref.read(profileRepositoryProvider);
      await repo.upsertCore(
        birthDate: dateStr,
        birthTime: timeStr ?? (dateStr != null ? '12:00' : null),
        birthTimeAccuracy: timeAccuracy,
        birthPlace: birthPlace,
      );

      // Refresh auth state (picks up needs_onboarding = false)
      ref.invalidate(userProfileProvider);
      await ref.read(authProvider.notifier).refreshUser();

      if (mounted) context.go('/home');
    } on DioException catch (e) {
      if (mounted) {
        final msg = _extractError(e);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
        // 409 = username conflict → go back to nickname step
        if (e.response?.statusCode == 409) {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          setState(() => _currentStep = 0);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('保存失败，请重试')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _prefillFromUser();
    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: Row(
                  children: List.generate(3, (i) {
                    return Expanded(
                      child: Container(
                        height: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: i <= _currentStep
                              ? CosmicColors.primary
                              : CosmicColors.surfaceElevated,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Back button
              if (_currentStep > 0)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: CosmicColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: _previousStep,
                    ),
                  ),
                ),

              // Pages
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildNicknameStep(),
                    _buildBirthDateStep(),
                    _buildBirthPlaceStep(),
                  ],
                ),
              ),

              // Next button
              Padding(
                padding: const EdgeInsets.all(32),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: _canProceed && !_saving
                          ? CosmicColors.primaryGradient
                          : null,
                      color: !_canProceed || _saving
                          ? CosmicColors.surfaceElevated
                          : null,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _canProceed && !_saving ? _nextStep : null,
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
                                  _currentStep < 2
                                      ? '\u4E0B\u4E00\u6B65'
                                      : '\u5B8C\u6210',
                                  style: TextStyle(
                                    color: _canProceed
                                        ? CosmicColors.textPrimary
                                        : CosmicColors.textTertiary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
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

  Widget _buildNicknameStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '\u4F60\u597D\uFF0C\u661F\u8FB0\u65C5\u4EBA',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CosmicColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '\u7ED9\u81EA\u5DF1\u53D6\u4E00\u4E2A\u540D\u5B57\u5427',
            style: TextStyle(color: CosmicColors.textSecondary),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _nicknameCtrl,
            style: const TextStyle(color: CosmicColors.textPrimary),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: '\u8F93\u5165\u6635\u79F0',
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
                borderSide: const BorderSide(
                  color: CosmicColors.primary,
                  width: 1.5,
                ),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildBirthDateStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '\u4F60\u7684\u51FA\u751F\u65F6\u95F4',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CosmicColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '\u7528\u4E8E\u8BA1\u7B97\u4F60\u7684\u661F\u76D8',
            style: TextStyle(color: CosmicColors.textSecondary),
          ),
          const SizedBox(height: 32),

          // Date picker
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: CosmicColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CosmicColors.borderGlow),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: CosmicColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _birthDate != null
                        ? '${_birthDate!.year}\u5E74${_birthDate!.month}\u6708${_birthDate!.day}\u65E5'
                        : '\u9009\u62E9\u51FA\u751F\u65E5\u671F',
                    style: TextStyle(
                      color: _birthDate != null
                          ? CosmicColors.textPrimary
                          : CosmicColors.textTertiary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Time picker
          GestureDetector(
            onTap: _pickTime,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: CosmicColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CosmicColors.borderGlow),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: CosmicColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _birthTime != null
                        ? '${_birthTime!.hour.toString().padLeft(2, '0')}:${_birthTime!.minute.toString().padLeft(2, '0')}'
                        : '\u9009\u62E9\u51FA\u751F\u65F6\u95F4\uFF08\u53EF\u9009\uFF09',
                    style: TextStyle(
                      color: _birthTime != null
                          ? CosmicColors.textPrimary
                          : CosmicColors.textTertiary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '\u51FA\u751F\u65F6\u95F4\u5F71\u54CD\u4E0A\u5347\u661F\u5EA7\u7684\u8BA1\u7B97\uFF0C\u4E0D\u786E\u5B9A\u53EF\u4EE5\u8DF3\u8FC7',
            style: TextStyle(color: CosmicColors.textTertiary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBirthPlaceStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '\u4F60\u7684\u51FA\u751F\u5730\u70B9',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CosmicColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '\u7528\u4E8E\u8BA1\u7B97\u7CBE\u786E\u7684\u5BAB\u4F4D',
            style: TextStyle(color: CosmicColors.textSecondary),
          ),
          const SizedBox(height: 32),

          // Region picker trigger
          GestureDetector(
            onTap: _pickBirthPlace,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: CosmicColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CosmicColors.borderGlow),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: CosmicColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _birthPlaceDisplay ??
                          '\u70B9\u51FB\u9009\u62E9\u51FA\u751F\u5730\u70B9',
                      style: TextStyle(
                        color: _birthPlaceDisplay != null
                            ? CosmicColors.textPrimary
                            : CosmicColors.textTertiary,
                        fontSize: 16,
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

          if (_birthPlaceTimezone != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.schedule,
                  size: 14,
                  color: CosmicColors.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  '\u65F6\u533A: $_birthPlaceTimezone',
                  style: const TextStyle(
                    color: CosmicColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 12),
          const Text(
            '\u53EF\u4EE5\u7A0D\u540E\u5728\u8BBE\u7F6E\u4E2D\u5B8C\u5584',
            style: TextStyle(color: CosmicColors.textTertiary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
