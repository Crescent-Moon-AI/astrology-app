import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:astrology_app/shared/theme/cosmic_colors.dart';
import 'package:astrology_app/shared/widgets/starfield_background.dart';
import '../../domain/models/birth_data.dart';
import '../../domain/models/chart_type.dart';
import '../../domain/models/chart_result.dart';
import '../../domain/models/planet_data.dart';
import '../../domain/models/house_data.dart';
import '../providers/chart_providers.dart';
import '../providers/chart_page_notifier.dart';
import '../widgets/planet_table.dart';
import '../widgets/aspect_table.dart';
import '../widgets/house_cusp_table.dart';
import '../widgets/chart_info_header.dart';
import '../widgets/no_birth_data_prompt.dart';
import '../widgets/planet_keyword_grid.dart';
import '../widgets/personality_tags.dart';
import '../widgets/element_house_summary.dart';
import 'package:astrology_app/shared/widgets/breathing_loader.dart';
import 'package:astrology_app/features/settings/presentation/providers/profile_providers.dart';

class ChartHubPage extends ConsumerStatefulWidget {
  final BirthData? overrideBirthData;

  const ChartHubPage({super.key, this.overrideBirthData});

  @override
  ConsumerState<ChartHubPage> createState() => _ChartHubPageState();
}

class _ChartHubPageState extends ConsumerState<ChartHubPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _hasAutoCalculated = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isZh = Localizations.localeOf(context).languageCode == 'zh';
    final birthAsync = widget.overrideBirthData != null
        ? AsyncValue.data(widget.overrideBirthData)
        : ref.watch(currentBirthDataProvider);

    // Auto-calculate natal chart once birth data becomes available
    final birth = birthAsync.value;
    if (birth != null && !_hasAutoCalculated) {
      _hasAutoCalculated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(chartPageProvider.notifier).setChartType(ChartType.natal);
        ref.read(chartPageProvider.notifier).calculate(birth);
      });
    }

    return Scaffold(
      backgroundColor: CosmicColors.background,
      body: StarfieldBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Custom app bar
              _buildAppBar(context, l10n, isZh),
              // Tab bar row: 合盘 button + 星盘概览 | 出生盘 tabs
              _buildTabRow(context, l10n, isZh),
              const SizedBox(height: 4),
              // Content
              Expanded(
                child: birthAsync.when(
                  loading: () => const Center(child: BreathingLoader()),
                  error: (_, _) => _buildErrorState(l10n, isZh, ref),
                  data: (birthData) => birthData == null
                      ? const NoBirthDataPrompt()
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            _ChartOverviewTab(birth: birthData),
                            _BirthChartTab(birth: birthData),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(AppLocalizations l10n, bool isZh, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: CosmicColors.textTertiary,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.errorLoadFailed,
              style: const TextStyle(
                color: CosmicColors.textSecondary,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => ref.invalidate(userProfileProvider),
              child: Text(
                l10n.retry,
                style: const TextStyle(
                  color: CosmicColors.primaryLight,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations l10n, bool isZh) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: CosmicColors.textPrimary,
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.share_outlined,
              color: CosmicColors.textPrimary,
              size: 20,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTabRow(BuildContext context, AppLocalizations l10n, bool isZh) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // 合盘 button
          GestureDetector(
            onTap: () => context.push('/charts/synastry'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: CosmicColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: CosmicColors.borderGlow),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.compare_arrows,
                    color: CosmicColors.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isZh ? '合盘' : 'Synastry',
                    style: const TextStyle(
                      color: CosmicColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Tabs: 星盘概览 | 出生盘
          Expanded(
            child: TabBar(
              controller: _tabController,
              labelColor: CosmicColors.textPrimary,
              unselectedLabelColor: CosmicColors.textTertiary,
              indicatorColor: CosmicColors.secondary,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.transparent,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              tabs: [
                Tab(text: isZh ? '星盘概览' : 'Overview'),
                Tab(text: isZh ? '出生盘' : 'Birth Chart'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tab 1: Chart Overview — personality tags + description + planet grid
class _ChartOverviewTab extends ConsumerWidget {
  final BirthData birth;
  const _ChartOverviewTab({required this.birth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chartPageProvider);
    final isZh = Localizations.localeOf(context).languageCode == 'zh';

    if (state.isCalculating) {
      return const Center(
        child: CircularProgressIndicator(color: CosmicColors.primary),
      );
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: CosmicColors.textTertiary,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                isZh ? '星盘计算出错' : 'Chart calculation failed',
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () =>
                    ref.read(chartPageProvider.notifier).calculate(birth),
                child: Text(
                  isZh ? '重试' : 'Retry',
                  style: const TextStyle(
                    color: CosmicColors.primaryLight,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final result = state.result;
    if (result is! NatalChartResult) return const SizedBox.shrink();

    final chart = result.chart;
    final description = _buildDescription(
      chart.planets,
      chart.houses.angles,
      isZh,
    );

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        // Personality tags
        PersonalityTags(planets: chart.planets, angles: chart.houses.angles),
        const SizedBox(height: 16),

        // Element & House identity (火象人, X宫人)
        ElementHouseSummary(
          planets: chart.planets,
          angles: chart.houses.angles,
        ),
        const SizedBox(height: 20),

        // Personality description
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CosmicColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: CosmicColors.borderGlow),
          ),
          child: Text(
            description,
            style: const TextStyle(
              color: CosmicColors.textSecondary,
              fontSize: 14,
              height: 1.7,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Planet keyword grid (3x3)
        PlanetKeywordGrid(
          planets: chart.planets,
          asteroids: chart.asteroids,
          angles: chart.houses.angles,
        ),
        const SizedBox(height: 16),

        // Deep reading link
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: CosmicColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CosmicColors.borderGlow),
            ),
            child: Row(
              children: [
                Text(
                  isZh
                      ? '查看深度解读：天赋·性格·爱情'
                      : 'Deep reading: Gifts, Personality, Love',
                  style: const TextStyle(
                    color: CosmicColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right,
                  color: CosmicColors.textTertiary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  String _buildDescription(
    List<PlanetData> planets,
    AnglesData angles,
    bool isZh,
  ) {
    String? sunSign, moonSign, ascSign;
    for (final p in planets) {
      if (p.name == 'Sun') sunSign = isZh ? p.signCn : p.sign;
      if (p.name == 'Moon') moonSign = isZh ? p.signCn : p.sign;
    }
    ascSign = isZh ? angles.ascSignCn : angles.ascSign;

    if (isZh) {
      return '你的太阳星座是$sunSign，赋予你核心的个性特质。'
          '月亮落在$moonSign，影响着你的内在情感和本能反应。'
          '上升$ascSign则塑造了你给人的第一印象和外在形象。'
          '这三者的组合，构成了你独特的星象蓝图。';
    }
    return 'Your Sun in $sunSign shapes your core identity. '
        'Moon in $moonSign influences your emotional nature. '
        'With $ascSign rising, you project a distinctive first impression. '
        'Together, these form your unique astrological blueprint.';
  }
}

/// Tab 2: Birth Chart — technical planet/aspect/house tables
class _BirthChartTab extends ConsumerWidget {
  final BirthData birth;
  const _BirthChartTab({required this.birth});

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
        child: Text(
          state.error!,
          style: const TextStyle(color: CosmicColors.error),
        ),
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
        const SizedBox(height: 40),
      ],
    );
  }
}
