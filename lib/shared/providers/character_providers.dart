import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the character system is enabled (reads from system settings).
/// For now, default to true. When settings API is integrated, this will
/// fetch from the backend.
final characterEnabledProvider = Provider<bool>((ref) => true);
