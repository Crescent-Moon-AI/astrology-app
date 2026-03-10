/// Local astrology calculation engine via Rust FFI (flutter_rust_bridge).
///
/// Provides offline-capable chart calculations by calling the Rust
/// astro-core library directly via FFI, without needing the backend API.
library;

import 'dart:convert';

import 'package:astrology_app/src/rust/api/api/astro.dart' as rust_astro;
import 'package:astrology_app/src/rust/api/frb_generated.dart';

/// Astrology calculation engine backed by native Rust FFI.
///
/// Falls back gracefully if the native library is not available.
class AstroEngine {
  bool _initialized = false;

  /// Whether the native engine is available.
  bool get isAvailable => _initialized;

  /// Initialize the native Rust bridge.
  ///
  /// Call this once at app startup. If initialization fails (e.g., on web
  /// or if the native library is missing), [isAvailable] will be false
  /// and callers should fall back to the API.
  Future<void> init() async {
    try {
      await RustLib.init();
      _initialized = true;
    } catch (_) {
      _initialized = false;
    }
  }

  /// Calculate a natal chart locally.
  ///
  /// Returns the parsed JSON result, or null if the engine is unavailable.
  Future<Map<String, dynamic>?> calculateNatalChart({
    required String birthDate,
    required String birthTime,
    required double latitude,
    required double longitude,
    required double timezone,
    String houseSystem = 'Placidus',
    String name = '',
    String location = '',
  }) async {
    if (!_initialized) return null;
    try {
      final json = await rust_astro.calculateNatalChart(
        birthDate: birthDate,
        birthTime: birthTime,
        latitude: latitude,
        longitude: longitude,
        timezone: timezone,
        houseSystem: houseSystem,
        name: name,
        location: location,
      );
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Calculate all chart types (natal, transit, progressions, returns).
  ///
  /// Returns the parsed JSON result, or null if the engine is unavailable.
  Future<Map<String, dynamic>?> calculateMulti({
    required Map<String, dynamic> input,
  }) async {
    if (!_initialized) return null;
    try {
      final inputJson = jsonEncode(input);
      final json = await rust_astro.calculateMulti(inputJson: inputJson);
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Calculate synastry between two people.
  ///
  /// Returns the parsed JSON result, or null if the engine is unavailable.
  Future<Map<String, dynamic>?> calculateSynastry({
    required Map<String, dynamic> input,
  }) async {
    if (!_initialized) return null;
    try {
      final inputJson = jsonEncode(input);
      final json = await rust_astro.calculateSynastryChart(
        inputJson: inputJson,
      );
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Calculate progressions (secondary progressions or solar arc).
  Future<Map<String, dynamic>?> calculateProgressions({
    required String birthDate,
    required String birthTime,
    required double latitude,
    required double longitude,
    required double timezone,
    String houseSystem = 'Placidus',
    required String progressionDate,
    String method = 'secondary',
  }) async {
    if (!_initialized) return null;
    try {
      final json = await rust_astro.calculateProgressions(
        birthDate: birthDate,
        birthTime: birthTime,
        latitude: latitude,
        longitude: longitude,
        timezone: timezone,
        houseSystem: houseSystem,
        progressionDate: progressionDate,
        method: method,
      );
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Find solar return chart for a given year.
  Future<Map<String, dynamic>?> findSolarReturn({
    required String birthDate,
    required String birthTime,
    required double latitude,
    required double longitude,
    required double timezone,
    String houseSystem = 'Placidus',
    required int year,
  }) async {
    if (!_initialized) return null;
    try {
      final json = await rust_astro.findSolarReturn(
        birthDate: birthDate,
        birthTime: birthTime,
        latitude: latitude,
        longitude: longitude,
        timezone: timezone,
        houseSystem: houseSystem,
        year: year,
      );
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Find lunar return chart closest to target date.
  Future<Map<String, dynamic>?> findLunarReturn({
    required String birthDate,
    required String birthTime,
    required double latitude,
    required double longitude,
    required double timezone,
    String houseSystem = 'Placidus',
    required String targetDate,
  }) async {
    if (!_initialized) return null;
    try {
      final json = await rust_astro.findLunarReturn(
        birthDate: birthDate,
        birthTime: birthTime,
        latitude: latitude,
        longitude: longitude,
        timezone: timezone,
        houseSystem: houseSystem,
        targetDate: targetDate,
      );
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}
