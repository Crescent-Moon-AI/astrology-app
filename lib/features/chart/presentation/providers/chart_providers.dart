import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/core/providers/core_providers.dart';
import 'package:astrology_app/features/chart/domain/models/birth_data.dart';
import 'package:astrology_app/features/chart/domain/services/chart_calculation_service.dart';
import 'package:astrology_app/features/settings/presentation/providers/profile_providers.dart';

final chartCalculationServiceProvider = Provider<ChartCalculationService>((
  ref,
) {
  final engine = ref.watch(astroEngineProvider);
  return ChartCalculationService(engine);
});

final currentBirthDataProvider = Provider<AsyncValue<BirthData?>>((ref) {
  final profileAsync = ref.watch(userProfileProvider);
  return profileAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
    data: (profile) {
      final core = profile.core;
      final place = profile.currentBirthPlace;

      if (core.birthDate == null ||
          core.birthTime == null ||
          place?.latitude == null ||
          place?.longitude == null) {
        return const AsyncValue.data(null);
      }

      return AsyncValue.data(
        BirthData(
          name: '',
          birthDate: core.birthDate!,
          birthTime: core.birthTime!,
          latitude: place!.latitude!,
          longitude: place.longitude!,
          timezone: 8.0, // fallback for legacy positional FFI calls
          timezoneId: place.timezone,
          location: place.normalizedName ?? '',
        ),
      );
    },
  );
});
