import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/birth_data.dart';
import '../../domain/models/chart_type.dart';
import '../../domain/models/chart_request.dart';
import '../../domain/models/chart_result.dart';
import 'chart_providers.dart';

class ChartPageState {
  final ChartType chartType;
  final ChartResult? result;
  final bool isCalculating;
  final String? error;
  final DateTime selectedDate;
  final int selectedYear;

  ChartPageState({
    this.chartType = ChartType.natal,
    this.result,
    this.isCalculating = false,
    this.error,
    DateTime? selectedDate,
    int? selectedYear,
  }) : selectedDate = selectedDate ?? DateTime.now(),
       selectedYear = selectedYear ?? DateTime.now().year;

  ChartPageState copyWith({
    ChartType? chartType,
    ChartResult? Function()? result,
    bool? isCalculating,
    String? Function()? error,
    DateTime? selectedDate,
    int? selectedYear,
  }) {
    return ChartPageState(
      chartType: chartType ?? this.chartType,
      result: result != null ? result() : this.result,
      isCalculating: isCalculating ?? this.isCalculating,
      error: error != null ? error() : this.error,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }
}

class ChartPageNotifier extends Notifier<ChartPageState> {
  @override
  ChartPageState build() => ChartPageState();

  void setChartType(ChartType type) {
    state = state.copyWith(
      chartType: type,
      result: () => null,
      error: () => null,
    );
  }

  void setDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void setYear(int year) {
    state = state.copyWith(selectedYear: year);
  }

  Future<void> calculate(BirthData birth) async {
    state = state.copyWith(isCalculating: true, error: () => null);

    try {
      final service = ref.read(chartCalculationServiceProvider);
      final request = _buildRequest(birth);
      final result = await service.calculate(request);

      if (result == null) {
        state = state.copyWith(
          isCalculating: false,
          error: () => 'engine_unavailable',
        );
      } else {
        state = state.copyWith(isCalculating: false, result: () => result);
      }
    } catch (e) {
      state = state.copyWith(isCalculating: false, error: () => e.toString());
    }
  }

  ChartRequest _buildRequest(BirthData birth) {
    return switch (state.chartType) {
      ChartType.natal => NatalChartRequest(birth: birth),
      ChartType.transit => TransitChartRequest(
        birth: birth,
        transitDate: state.selectedDate,
      ),
      ChartType.secondaryProgression => SecondaryProgressionRequest(
        birth: birth,
        progressionDate: state.selectedDate,
      ),
      ChartType.solarArc => SolarArcRequest(
        birth: birth,
        progressionDate: state.selectedDate,
      ),
      ChartType.solarReturn => SolarReturnRequest(
        birth: birth,
        year: state.selectedYear,
      ),
      ChartType.lunarReturn => LunarReturnRequest(
        birth: birth,
        targetDate: state.selectedDate,
      ),
      ChartType.synastry => throw StateError('Use SynastryPage for synastry'),
    };
  }
}

final chartPageProvider = NotifierProvider<ChartPageNotifier, ChartPageState>(
  ChartPageNotifier.new,
);
