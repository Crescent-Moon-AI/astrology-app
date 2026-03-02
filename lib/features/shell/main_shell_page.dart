import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../shared/theme/cosmic_colors.dart';

/// Main shell with bottom navigation bar.
/// Wraps the 5 main tabs: Home, Insight, Consult, Diary, Profile.
class MainShellPage extends ConsumerStatefulWidget {
  final Widget child;

  const MainShellPage({super.key, required this.child});

  @override
  ConsumerState<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends ConsumerState<MainShellPage> {
  int _currentIndex = 0;

  static const _tabRoutes = [
    '/home',
    '/insight',
    '/consult',
    '/diary',
    '/profile',
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

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _CosmicBottomBar(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          if (index == _currentIndex) return;
          setState(() => _currentIndex = index);
          context.go(_tabRoutes[index]);
        },
        labels: [
          l10n.tabHome,
          l10n.tabInsight,
          l10n.tabConsult,
          l10n.tabDiary,
          l10n.tabProfile,
        ],
      ),
    );
  }
}

class _CosmicBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final List<String> labels;

  const _CosmicBottomBar({
    required this.currentIndex,
    required this.onTabSelected,
    required this.labels,
  });

  static const _unselectedIcons = [
    Icons.home_outlined, // Tab 0: Home
    Icons.auto_graph_outlined, // Tab 1: Insight
    Icons.auto_awesome, // Tab 2: Consult (center)
    Icons.menu_book_outlined, // Tab 3: Diary
    Icons.person_outline, // Tab 4: Profile
  ];

  static const _selectedIcons = [
    Icons.home,
    Icons.auto_graph,
    Icons.auto_awesome,
    Icons.menu_book,
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
                  _buildTab(3),
                  _buildTab(4),
                ],
              ),
            ),
          ),
          // Raised center button (Tab 2: Consult)
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
    final isSelected = currentIndex == 2;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTabSelected(2),
      child: SizedBox(
        width: 72,
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
                  color: CosmicColors.primary.withAlpha(isSelected ? 128 : 77),
                  blurRadius: isSelected ? 20 : 16,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? _selectedIcons[2] : _unselectedIcons[2],
                  color: CosmicColors.textPrimary,
                  size: 24,
                ),
                Text(
                  labels[2],
                  style: const TextStyle(
                    color: CosmicColors.textPrimary,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
