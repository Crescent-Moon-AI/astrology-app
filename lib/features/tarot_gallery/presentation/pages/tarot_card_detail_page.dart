import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/utils/card_asset_paths.dart';
import '../../../../shared/widgets/starfield_background.dart';
import '../../../tarot_ritual/domain/models/tarot_card.dart';
import '../pages/tarot_gallery_page.dart';

class TarotCardDetailPage extends StatefulWidget {
  final TarotDetailArgs args;

  const TarotCardDetailPage({super.key, required this.args});

  @override
  State<TarotCardDetailPage> createState() => _TarotCardDetailPageState();
}

class _TarotCardDetailPageState extends State<TarotCardDetailPage> {
  late int _currentIndex;
  bool _showReversed = false;
  late PageController _pageController;

  List<TarotCard> get _cards => widget.args.cards;

  TarotCard get _currentCard => _cards[_currentIndex];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.args.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    if (_currentIndex < _cards.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode == 'zh';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_currentCard.nameZH} \u00B7 ${_formatName(_currentCard.name)}',
          style: const TextStyle(
            color: CosmicColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: CosmicColors.textPrimary),
      ),
      extendBodyBehindAppBar: true,
      body: StarfieldBackground(
        child: SafeArea(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _cards.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _showReversed = false;
              });
            },
            itemBuilder: (context, index) {
              final card = _cards[index];
              return _CardDetailContent(
                card: card,
                showReversed: index == _currentIndex ? _showReversed : false,
                onToggleOrientation: index == _currentIndex
                    ? (reversed) => setState(() => _showReversed = reversed)
                    : null,
                isZh: isZh,
                canGoPrevious: index > 0,
                canGoNext: index < _cards.length - 1,
                onPrevious: _goToPrevious,
                onNext: _goToNext,
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatName(String name) {
    if (!name.contains('_')) return name;
    return name
        .split('_')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}

class _CardDetailContent extends StatelessWidget {
  final TarotCard card;
  final bool showReversed;
  final ValueChanged<bool>? onToggleOrientation;
  final bool isZh;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _CardDetailContent({
    required this.card,
    required this.showReversed,
    required this.onToggleOrientation,
    required this.isZh,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final assetPath = CardAssetPaths.tarotAssetPath(card.imageKey);
    final keywords = showReversed
        ? (card.reversedKeywordsZH.isNotEmpty
              ? card.reversedKeywordsZH
              : card.reversedKeywords)
        : (card.uprightKeywordsZH.isNotEmpty
              ? card.uprightKeywordsZH
              : card.uprightKeywords);

    // Quotes for cards
    final quote = _getCardQuote(card);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Upright/Reversed toggle
          _OrientationToggle(
            showReversed: showReversed,
            onChanged: onToggleOrientation,
          ),
          const SizedBox(height: 16),

          // Card image
          SizedBox(
            height: 360,
            child: Transform.rotate(
              angle: showReversed ? 3.14159 : 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                  cacheWidth: 600,
                  errorBuilder: (_, e, st) => Container(
                    width: 240,
                    height: 360,
                    decoration: BoxDecoration(
                      color: CosmicColors.surfaceHighlight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        card.nameZH,
                        style: const TextStyle(
                          color: CosmicColors.textPrimary,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Card title
          Text(
            '${card.nameZH} \u00B7 ${_formatName(card.name)}',
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Orientation label
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              showReversed
                  ? (isZh ? '逆位' : 'Reversed')
                  : (isZh ? '正位' : 'Upright'),
              style: TextStyle(
                color: showReversed
                    ? CosmicColors.error
                    : CosmicColors.tarotGold,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Keywords chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: keywords.map((kw) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: _chipColor(keywords.indexOf(kw)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  kw,
                  style: const TextStyle(
                    color: CosmicColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Quote
          if (quote.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: CosmicColors.tarotGold, width: 3),
                ),
              ),
              child: Text(
                '"$quote"',
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ),
          const SizedBox(height: 16),

          // Card meaning section
          _buildMeaningSection(isZh),
          const SizedBox(height: 16),

          // Navigation arrows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavButton(
                onTap: canGoPrevious ? onPrevious : null,
                icon: Icons.chevron_left,
              ),
              Text(
                isZh ? '牌意解读' : 'Card Meaning',
                style: const TextStyle(
                  color: CosmicColors.tarotGold,
                  fontSize: 13,
                ),
              ),
              _NavButton(
                onTap: canGoNext ? onNext : null,
                icon: Icons.chevron_right,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMeaningSection(bool isZh) {
    final element = card.element;
    String elementDisplay = element;
    if (isZh) {
      final zhMap = {'fire': '火', 'water': '水', 'air': '风', 'earth': '土'};
      elementDisplay = zhMap[element.toLowerCase()] ?? element;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CosmicColors.borderGlow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(isZh ? '元素' : 'Element', elementDisplay),
          if (card.arcana == 'major')
            _infoRow(isZh ? '编号' : 'Number', '${card.number}'),
          if (card.suit != null && card.suit!.isNotEmpty)
            _infoRow(isZh ? '花色' : 'Suit', _suitName(card.suit!, isZh)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: CosmicColors.textTertiary,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _suitName(String suit, bool isZh) {
    if (!isZh) return suit[0].toUpperCase() + suit.substring(1);
    return switch (suit) {
      'wands' => '权杖',
      'cups' => '圣杯',
      'swords' => '宝剑',
      'pentacles' => '星币',
      _ => suit,
    };
  }

  Color _chipColor(int index) {
    const colors = [
      Color(0xFF4A3728),
      Color(0xFF3A2848),
      Color(0xFF28403A),
      Color(0xFF3A3028),
      Color(0xFF283848),
      Color(0xFF48282E),
      Color(0xFF2E4828),
      Color(0xFF382838),
      Color(0xFF284038),
      Color(0xFF483828),
    ];
    return colors[index % colors.length];
  }

  String _formatName(String name) {
    if (!name.contains('_')) return name;
    return name
        .split('_')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  String _getCardQuote(TarotCard card) {
    const quotes = {
      0: '当生活变得太过熟悉，灵魂就会渴望一场冒险。',
      1: '你所需要的力量，早已在你手中。',
      2: '安静下来，答案就在内心深处。',
      3: '万物生长，源于爱的滋养。',
      4: '秩序是自由的基石。',
      5: '传统中蕴含着永恒的智慧。',
      6: '选择即命运，爱即是道路。',
      7: '坚定的意志可以征服一切障碍。',
      8: '真正的力量来自于温柔。',
      9: '在独处中，我们找到真正的自己。',
      10: '命运之轮永不停歇，唯一不变的是变化本身。',
      11: '真理终将浮出水面。',
      12: '换个角度，世界截然不同。',
      13: '每一个结束都是新的开始。',
      14: '平衡是通往和谐的钥匙。',
      15: '认识阴暗面，才能真正自由。',
      16: '旧的不去，新的不来。',
      17: '即使在最黑暗的夜晚，星星依然闪耀。',
      18: '穿越迷雾，月光会指引方向。',
      19: '阳光照耀之处，万物皆美好。',
      20: '觉醒的号角已经吹响。',
      21: '旅程的终点，亦是新旅程的起点。',
    };
    return quotes[card.number] ?? '';
  }
}

class _OrientationToggle extends StatelessWidget {
  final bool showReversed;
  final ValueChanged<bool>? onChanged;

  const _OrientationToggle({
    required this.showReversed,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isZh = Localizations.localeOf(context).languageCode == 'zh';

    return Container(
      decoration: BoxDecoration(
        color: CosmicColors.surfaceElevated,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleTab(
            label: isZh ? '正位' : 'Upright',
            selected: !showReversed,
            onTap: () => onChanged?.call(false),
          ),
          _toggleTab(
            label: isZh ? '逆位' : 'Reversed',
            selected: showReversed,
            onTap: () => onChanged?.call(true),
          ),
        ],
      ),
    );
  }

  Widget _toggleTab({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? CosmicColors.primary.withAlpha(180)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? CosmicColors.textPrimary
                : CosmicColors.textTertiary,
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;

  const _NavButton({required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onTap != null
              ? CosmicColors.surfaceHighlight
              : CosmicColors.surfaceElevated,
        ),
        child: Icon(
          icon,
          color: onTap != null
              ? CosmicColors.textPrimary
              : CosmicColors.textTertiary,
          size: 28,
        ),
      ),
    );
  }
}
