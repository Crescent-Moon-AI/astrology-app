import 'birth_data.dart';

sealed class ChartRequest {
  const ChartRequest();
}

class NatalChartRequest extends ChartRequest {
  final BirthData birth;
  const NatalChartRequest({required this.birth});
}

class TransitChartRequest extends ChartRequest {
  final BirthData birth;
  final DateTime transitDate;
  const TransitChartRequest({required this.birth, required this.transitDate});
}

class SecondaryProgressionRequest extends ChartRequest {
  final BirthData birth;
  final DateTime progressionDate;
  const SecondaryProgressionRequest({
    required this.birth,
    required this.progressionDate,
  });
}

class SolarArcRequest extends ChartRequest {
  final BirthData birth;
  final DateTime progressionDate;
  const SolarArcRequest({
    required this.birth,
    required this.progressionDate,
  });
}

class SolarReturnRequest extends ChartRequest {
  final BirthData birth;
  final int year;
  const SolarReturnRequest({required this.birth, required this.year});
}

class LunarReturnRequest extends ChartRequest {
  final BirthData birth;
  final DateTime targetDate;
  const LunarReturnRequest({required this.birth, required this.targetDate});
}

class SynastryRequest extends ChartRequest {
  final BirthData person1;
  final BirthData person2;
  const SynastryRequest({required this.person1, required this.person2});
}
