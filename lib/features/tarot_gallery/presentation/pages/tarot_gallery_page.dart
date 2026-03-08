import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/utils/card_asset_paths.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../../tarot_ritual/domain/models/tarot_card.dart';
import '../../data/tarot_card_data.dart';

class TarotGalleryPage extends StatefulWidget {
  const TarotGalleryPage({super.key});

  @override
  State<TarotGalleryPage> createState() => _TarotGalleryPageState();
}

class _TarotGalleryPageState extends State<TarotGalleryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _categories = TarotCardData.categories;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode == 'zh';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isZh ? '塔罗牌图鉴' : 'Tarot Gallery',
          style: const TextStyle(
            color: CosmicColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: CosmicColors.textPrimary),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          indicatorColor: CosmicColors.tarotGold,
          indicatorWeight: 2,
          labelColor: CosmicColors.tarotGold,
          unselectedLabelColor: CosmicColors.textTertiary,
          tabs: _categories.map((cat) {
            return Tab(
              icon: Icon(IconData(cat.icon, fontFamily: 'MaterialIcons'), size: 24),
            );
          }).toList(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: StarfieldBackground(
        child: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: _categories.map((cat) {
              return _CategoryGrid(
                categoryId: cat.id,
                categoryName: isZh ? cat.nameZh : cat.nameEn,
                isZh: isZh,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final bool isZh;

  const _CategoryGrid({
    required this.categoryId,
    required this.categoryName,
    required this.isZh,
  });

  @override
  Widget build(BuildContext context) {
    final cards = TarotCardData.cardsByCategory(categoryId);

    return CustomScrollView(
      slivers: [
        // Section header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                categoryName,
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        // Card grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.58,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final card = cards[index];
                return _GalleryCardItem(
                  card: card,
                  allCards: cards,
                  index: index,
                  isZh: isZh,
                );
              },
              childCount: cards.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _GalleryCardItem extends StatelessWidget {
  final TarotCard card;
  final List<TarotCard> allCards;
  final int index;
  final bool isZh;

  const _GalleryCardItem({
    required this.card,
    required this.allCards,
    required this.index,
    required this.isZh,
  });

  @override
  Widget build(BuildContext context) {
    final assetPath = CardAssetPaths.tarotAssetPath(card.imageKey);

    return GestureDetector(
      onTap: () {
        context.push(
          '/tarot-gallery/detail',
          extra: _TarotDetailArgs(cards: allCards, initialIndex: index),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: CosmicColors.surfaceElevated,
          border: Border.all(color: CosmicColors.borderGlow),
        ),
        child: Column(
          children: [
            // Card image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  cacheWidth: 300,
                  errorBuilder: (_, e, st) => Container(
                    color: CosmicColors.surfaceHighlight,
                    child: Center(
                      child: Text(
                        card.nameZH.isNotEmpty ? card.nameZH : card.name,
                        style: const TextStyle(
                          color: CosmicColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Card name
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
              child: Column(
                children: [
                  Text(
                    card.name.toUpperCase(),
                    style: const TextStyle(
                      color: CosmicColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    card.nameZH,
                    style: const TextStyle(
                      color: CosmicColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Arguments for navigating to detail page.
class TarotDetailArgs {
  final List<TarotCard> cards;
  final int initialIndex;

  const TarotDetailArgs({required this.cards, required this.initialIndex});
}

// Private alias used internally for routing extra
typedef _TarotDetailArgs = TarotDetailArgs;
