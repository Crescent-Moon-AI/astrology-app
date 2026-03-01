import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/profile_api.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/models/location_candidate.dart';
import '../../domain/models/user_profile.dart';

// Profile API datasource
final profileApiProvider = Provider<ProfileApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ProfileApi(dioClient.dio);
});

// Profile repository
final profileRepositoryProvider = Provider<ProfileRepositoryImpl>((ref) {
  final api = ref.watch(profileApiProvider);
  return ProfileRepositoryImpl(api);
});

// Current user profile
final userProfileProvider = FutureProvider.autoDispose<UserProfile>((
  ref,
) async {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.getProfile();
});

// Location search with debounce
final locationSearchProvider = FutureProvider.autoDispose
    .family<List<LocationCandidate>, String>((ref, query) async {
      if (query.trim().length < 2) return [];

      // Debounce: cancel if query changes within 500ms
      final cancelled = Completer<void>();
      ref.onDispose(cancelled.complete);
      await Future.delayed(const Duration(milliseconds: 500));
      if (cancelled.isCompleted) return [];

      final repo = ref.watch(profileRepositoryProvider);
      final result = await repo.resolveLocation(query);
      return result.candidates;
    });

// Birth data form state
class BirthDataFormState {
  final DateTime? birthDate;
  final TimeOfDay? birthTime;
  final BirthTimeAccuracy birthTimeAccuracy;
  final LocationCandidate? selectedLocation;
  final bool isSaving;
  final String? error;

  const BirthDataFormState({
    this.birthDate,
    this.birthTime,
    this.birthTimeAccuracy = BirthTimeAccuracy.unknown,
    this.selectedLocation,
    this.isSaving = false,
    this.error,
  });

  BirthDataFormState copyWith({
    DateTime? Function()? birthDate,
    TimeOfDay? Function()? birthTime,
    BirthTimeAccuracy? birthTimeAccuracy,
    LocationCandidate? Function()? selectedLocation,
    bool? isSaving,
    String? Function()? error,
  }) {
    return BirthDataFormState(
      birthDate: birthDate != null ? birthDate() : this.birthDate,
      birthTime: birthTime != null ? birthTime() : this.birthTime,
      birthTimeAccuracy: birthTimeAccuracy ?? this.birthTimeAccuracy,
      selectedLocation: selectedLocation != null
          ? selectedLocation()
          : this.selectedLocation,
      isSaving: isSaving ?? this.isSaving,
      error: error != null ? error() : this.error,
    );
  }
}

final birthDataFormProvider =
    NotifierProvider<BirthDataFormNotifier, BirthDataFormState>(
      BirthDataFormNotifier.new,
    );

class BirthDataFormNotifier extends Notifier<BirthDataFormState> {
  @override
  BirthDataFormState build() => const BirthDataFormState();

  void initFromProfile(UserProfile profile) {
    final core = profile.core;
    DateTime? date;
    if (core.birthDate != null) {
      date = DateTime.tryParse(core.birthDate!);
    }

    TimeOfDay? time;
    if (core.birthTime != null) {
      final parts = core.birthTime!.split(':');
      if (parts.length >= 2) {
        time = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 0,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      }
    }

    LocationCandidate? location;
    final place = profile.currentBirthPlace;
    if (place != null && place.normalizedName != null) {
      location = LocationCandidate(
        name: place.normalizedName!,
        latitude: place.latitude ?? 0,
        longitude: place.longitude ?? 0,
        timezone: place.timezone,
        countryCode: place.countryCode,
        adminArea: place.adminArea,
      );
    }

    state = BirthDataFormState(
      birthDate: date,
      birthTime: time,
      birthTimeAccuracy: core.birthTimeAccuracy,
      selectedLocation: location,
    );
  }

  void setBirthDate(DateTime? date) {
    state = state.copyWith(birthDate: () => date);
  }

  void setBirthTime(TimeOfDay? time) {
    state = state.copyWith(
      birthTime: () => time,
      birthTimeAccuracy: time != null
          ? BirthTimeAccuracy.exact
          : BirthTimeAccuracy.unknown,
    );
  }

  void setBirthTimeAccuracy(BirthTimeAccuracy accuracy) {
    state = state.copyWith(birthTimeAccuracy: accuracy);
    if (accuracy == BirthTimeAccuracy.unknown) {
      state = state.copyWith(birthTime: () => null);
    }
  }

  void setLocation(LocationCandidate? location) {
    state = state.copyWith(selectedLocation: () => location);
  }

  Future<bool> save() async {
    state = state.copyWith(isSaving: true, error: () => null);

    try {
      final repo = ref.read(profileRepositoryProvider);

      String? dateStr;
      if (state.birthDate != null) {
        final d = state.birthDate!;
        dateStr =
            '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      }

      String? timeStr;
      if (state.birthTime != null) {
        final t = state.birthTime!;
        timeStr =
            '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
      }

      await repo.upsertCore(
        birthDate: dateStr,
        birthTime: timeStr,
        birthTimeAccuracy: state.birthTimeAccuracy.name,
        birthPlace: state.selectedLocation,
      );

      // Invalidate profile cache
      ref.invalidate(userProfileProvider);

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: () => e.toString());
      return false;
    }
  }
}
