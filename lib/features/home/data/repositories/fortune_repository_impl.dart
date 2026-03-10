import '../../domain/models/daily_fortune.dart';
import '../datasources/fortune_api.dart';

class FortuneRepositoryImpl {
  final FortuneApi _api;

  FortuneRepositoryImpl(this._api);

  Future<DailyFortune> getDailyFortune({String? date}) async {
    final json = await _api.getDailyFortune(date: date);
    final data = json['data'] as Map<String, dynamic>;
    return DailyFortune.fromJson(data);
  }

  Future<WeeklyFortune> getWeeklyFortune({String? date}) async {
    final json = await _api.getWeeklyFortune(date: date);
    final data = json['data'] as Map<String, dynamic>;
    return WeeklyFortune.fromJson(data);
  }
}
