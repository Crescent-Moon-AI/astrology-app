import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../shared/theme/cosmic_colors.dart';

/// Main shell with bottom navigation bar.
/// Wraps the 4 main tabs: Explore, Chat, Calendar, Profile.
class MainShellPage extends ConsumerStatefulWidget {
  final Widget child;

  const MainShellPage({super.key, required this.child});

  @override
  ConsumerState<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends ConsumerState<MainShellPage> {
  int _currentIndex = 0;

  static const _tabRoutes = [
    '/scenarios',
    '/conversations',
    '/transits',
    '/settings',
  ];

  @override
  void didUpdateWidget(MainShellPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncTabIndex();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncTabIndex();
  }

  void _syncTabIndex() {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _tabRoutes.length; i++) {
      if (location.startsWith(_tabRoutes[i])) {
        if (_currentIndex != i) {
          setState(() => _currentIndex = i);
        }
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _CosmicBottomBar(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          if (index == _currentIndex) return;
          setState(() => _currentIndex = index);
          context.go(_tabRoutes[index]);
        },
        onCenterTap: () => context.push('/divination'),
        labels: [
          l10n.scenarioExploreTitle,
          l10n.chatTitle,
          l10n.calendarTitle,
          isZh ? '\u6211\u7684' : 'Profile',
        ],
      ),
    );
  }
}

class _CosmicBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onCenterTap;
  final List<String> labels;

  const _CosmicBottomBar({
    required this.currentIndex,
    required this.onTabSelected,
    required this.onCenterTap,
    required this.labels,
  });

  static const _unselectedIcons = [
    Icons.explore_outlined,
    Icons.question_answer_outlined,
    Icons.nights_stay_outlined,
    Icons.person_outline,
  ];

  static const _selectedIcons = [
    Icons.explore,
    Icons.question_answer,
    Icons.nights_stay,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: 64 + bottomPadding + 14, // extra 14 for raised button
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Nav bar background
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 64 + bottomPadding,
            child: Container(
              padding: EdgeInsets.only(bottom: bottomPadding),
              decoration: BoxDecoration(
                color: CosmicColors.backgroundDeep.withAlpha(230),
              ),
              child: Row(
                children: [
                  _buildTab(0),
                  _buildTab(1),
                  const Spacer(), // placeholder for center button
                  _buildTab(2),
                  _buildTab(3),
                ],
              ),
            ),
          ),
          // Raised center button — centered horizontally, raised above bar
          Positioned(
            bottom: bottomPadding + (64 - 56) / 2,
            left: 0,
            right: 0,
            child: Center(child: _buildCenterButton()),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTabSelected(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? _selectedIcons[index] : _unselectedIcons[index],
              color: isSelected
                  ? CosmicColors.primaryLight
                  : CosmicColors.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              labels[index],
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? CosmicColors.primaryLight
                    : CosmicColors.textTertiary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onCenterTap,
      child: SizedBox(
        width: 72, // larger tap target
        height: 72,
        child: Center(
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: CosmicColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: CosmicColors.primary.withAlpha(77), // 30%
                  blurRadius: 16,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: CosmicColors.textPrimary,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
