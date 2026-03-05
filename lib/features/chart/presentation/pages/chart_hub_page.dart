import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:astrology_app/shared/theme/cosmic_colors.dart';
import '../../domain/models/birth_data.dart';
import '../../domain/models/chart_type.dart';
import '../../domain/models/chart_result.dart';
import '../providers/chart_providers.dart';
import '../providers/chart_page_notifier.dart';
import '../widgets/planet_table.dart';
import '../widgets/aspect_table.dart';
import '../widgets/cross_aspect_table.dart';
import '../widgets/house_cusp_table.dart';
import '../widgets/chart_info_header.dart';
import '../widgets/date_parameter_picker.dart';
import '../widgets/chart_type_selector.dart';
import '../widgets/no_birth_data_prompt.dart';

class ChartHubPage extends ConsumerStatefulWidget {
  const ChartHubPage({super.key});

  @override
  ConsumerState<ChartHubPage> createState() => _ChartHubPageState();
}

class _ChartHubPageState extends ConsumerState<ChartHubPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabTypes = [
    ChartType.natal,
    ChartType.transit,
    ChartType.secondaryProgression,
    ChartType.solarReturn,
  ];

  bool _hasAutoCalculated = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTypes.length, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    final type = _tabTypes[_tabController.index];
    ref.read(chartPageProvider.notifier).setChartType(type);
    final birth = ref.read(currentBirthDataProvider);
    if (birth != null) {
      ref.read(chartPageProvider.notifier).calculate(birth);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final birth = ref.watch(currentBirthDataProvider);

    // Auto-calculate natal chart once birth data becomes available
    if (birth != null && !_hasAutoCalculated) {
      _hasAutoCalculated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(chartPageProvider.notifier).calculate(birth);
      });
    }

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: AppBar(
        backgroundColor: CosmicColors.background,
        title: Text(l10n.chartMyChart,
            style: const TextStyle(color: CosmicColors.textPrimary)),
        iconTheme: const IconThemeData(color: CosmicColors.textPrimary),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: CosmicColors.secondary,
          unselectedLabelColor: CosmicColors.textSecondary,
          indicatorColor: CosmicColors.secondary,
          dividerColor: Colors.transparent,
          tabs: [
            Tab(text: l10n.chartNatal),
            Tab(text: l10n.chartTransit),
            Tab(text: l10n.chartProgression),
            Tab(text: l10n.chartReturn),
          ],
        ),
      ),
      body: birth == null
          ? const NoBirthDataPrompt()
          : TabBarView(
              controller: _tabController,
              children: [
                _NatalTab(birth: birth),
                _TransitTab(birth: birth),
                _ProgressionTab(birth: birth),
                _ReturnTab(birth: birth),
              ],
            ),
    );
  }
}

class _NatalTab extends ConsumerWidget {
  final BirthData birth;
  const _NatalTab({required this.birth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chartPageProvider);

    if (state.isCalculating) {
      return const Center(
        child: CircularProgressIndicator(color: CosmicColors.primary),
      );
    }

    if (state.error != null) {
      return Center(
        child: Text(state.error!,
            style: const TextStyle(color: CosmicColors.error)),
      );
    }

    final result = state.result;
    if (result is! NatalChartResult) return const SizedBox.shrink();

    final chart = result.chart;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ChartInfoHeader(info: chart.info),
        const SizedBox(height: 12),
        PlanetTable(planets: chart.planets),
        const SizedBox(height: 12),
        AspectTable(aspects: chart.aspects),
        const SizedBox(height: 12),
        HouseCuspTable(houses: chart.houses),
      ],
    );
  }
}

class _TransitTab extends ConsumerWidget {
  final BirthData birth;
  const _TransitTab({required this.birth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chartPageProvider);
    final l10n = AppLocalizations.of(context)!;
    final result = state.result;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DateParameterPicker(
          date: state.selectedDate,
          label: l10n.chartTransitDate,
          onDateChanged: (date) {
            ref.read(chartPageProvider.notifier).setDate(date);
            ref.read(chartPageProvider.notifier).calculate(birth);
          },
        ),
        const SizedBox(height: 16),
        if (state.isCalculating)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(color: CosmicColors.primary),
            ),
          )
        else if (result is TransitChartResult) ...[
          PlanetTable(planets: result.transit.planets),
          const SizedBox(height: 12),
          CrossAspectTable(
            aspects: result.crossAspects,
            label1: l10n.chartNatal,
            label2: l10n.chartTransit,
          ),
        ],
      ],
    );
  }
}

class _ProgressionTab extends ConsumerWidget {
  final BirthData birth;
  const _ProgressionTab({required this.birth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chartPageProvider);
    final l10n = AppLocalizations.of(context)!;
    final result = state.result;
    final isSecondary = state.chartType == ChartType.secondaryProgression;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ChartTypeSelector(
          options: [
            (label: l10n.chartSecondaryProgression, selected: isSecondary),
            (label: l10n.chartSolarArc, selected: !isSecondary),
          ],
          onSelected: (index) {
            final type = index == 0
                ? ChartType.secondaryProgression
                : ChartType.solarArc;
            ref.read(chartPageProvider.notifier).setChartType(type);
          },
        ),
        const SizedBox(height: 12),
        DateParameterPicker(
          date: state.selectedDate,
          label: l10n.chartProgressionDate,
          onDateChanged: (date) {
            ref.read(chartPageProvider.notifier).setDate(date);
            ref.read(chartPageProvider.notifier).calculate(birth);
          },
        ),
        const SizedBox(height: 16),
        if (state.isCalculating)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(color: CosmicColors.primary),
            ),
          )
        else if (result is ProgressionChartResult) ...[
          PlanetTable(planets: result.progressedPlanets, showHouse: false),
          const SizedBox(height: 12),
          CrossAspectTable(
            aspects: result.crossAspects,
            label1: l10n.chartNatal,
            label2: l10n.chartProgression,
          ),
        ],
      ],
    );
  }
}

class _ReturnTab extends ConsumerWidget {
  final BirthData birth;
  const _ReturnTab({required this.birth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chartPageProvider);
    final l10n = AppLocalizations.of(context)!;
    final result = state.result;

    final isSolar = state.chartType == ChartType.solarReturn ||
        state.chartType == ChartType.natal;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ChartTypeSelector(
          options: [
            (label: l10n.chartSolarReturn, selected: isSolar),
            (label: l10n.chartLunarReturn, selected: !isSolar),
          ],
          onSelected: (index) {
            final type =
                index == 0 ? ChartType.solarReturn : ChartType.lunarReturn;
            ref.read(chartPageProvider.notifier).setChartType(type);
          },
        ),
        const SizedBox(height: 12),
        if (isSolar)
          _YearPicker(
            year: state.selectedYear,
            onChanged: (year) {
              ref.read(chartPageProvider.notifier).setYear(year);
              ref.read(chartPageProvider.notifier).calculate(birth);
            },
          )
        else
          DateParameterPicker(
            date: state.selectedDate,
            label: l10n.chartLunarReturnDate,
            onDateChanged: (date) {
              ref.read(chartPageProvider.notifier).setDate(date);
              ref.read(chartPageProvider.notifier).calculate(birth);
            },
          ),
        const SizedBox(height: 16),
        if (state.isCalculating)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(color: CosmicColors.primary),
            ),
          )
        else if (result is ReturnChartResult) ...[
          ChartInfoHeader(info: result.returnChart.info),
          const SizedBox(height: 12),
          PlanetTable(planets: result.returnChart.planets),
          const SizedBox(height: 12),
          HouseCuspTable(houses: result.returnChart.houses),
        ],
      ],
    );
  }
}

class _YearPicker extends StatelessWidget {
  final int year;
  final ValueChanged<int> onChanged;

  const _YearPicker({required this.year, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left,
              color: CosmicColors.textSecondary),
          onPressed: () => onChanged(year - 1),
        ),
        Expanded(
          child: Text(
            '$year',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CosmicColors.secondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right,
              color: CosmicColors.textSecondary),
          onPressed: () => onChanged(year + 1),
        ),
      ],
    );
  }
}
