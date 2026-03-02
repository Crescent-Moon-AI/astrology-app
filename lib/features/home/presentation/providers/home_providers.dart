import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/fortune_api.dart';
import '../../data/repositories/fortune_repository_impl.dart';
import '../../domain/models/daily_fortune.dart';

final fortuneApiProvider = Provider<FortuneApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return FortuneApi(dioClient.dio);
});

final fortuneRepositoryProvider = Provider<FortuneRepositoryImpl>((ref) {
  final api = ref.watch(fortuneApiProvider);
  return FortuneRepositoryImpl(api);
});

/// Selected date for fortune view (null = today).
class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void set(DateTime value) => state = value;
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(
  SelectedDateNotifier.new,
);

/// Daily fortune for the selected date.
final dailyFortuneProvider = FutureProvider<DailyFortune>((ref) async {
  final date = ref.watch(selectedDateProvider);
  final dateStr =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  final repo = ref.watch(fortuneRepositoryProvider);
  return repo.getDailyFortune(date: dateStr);
});
