import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../shared/theme/cosmic_colors.dart';
import '../../../../shared/utils/card_asset_paths.dart';

/// Minor Arcana name-to-number mapping for image key derivation.
const _minorNumbers = <String, String>{
  'ace': '01',
  'two': '02',
  'three': '03',
  'four': '04',
  'five': '05',
  'six': '06',
  'seven': '07',
  'eight': '08',
  'nine': '09',
  'ten': '10',
  'page': '11',
  'knight': '12',
  'queen': '13',
  'king': '14',
};

/// Derives image key from `name_en` when `image_key` is not provided by backend.
/// Major: "The Fool" → "major_00_fool"
/// Minor: "Nine of Pentacles" → "minor_pentacles_09"
String? _deriveImageKey(String nameEn) {
  if (nameEn.isEmpty) return null;

  // Major Arcana static map (small, fast lookup)
  const majorMap = <String, String>{
    'The Fool': 'major_00_fool',
    'The Magician': 'major_01_magician',
    'The High Priestess': 'major_02_high_priestess',
    'The Empress': 'major_03_empress',
    'The Emperor': 'major_04_emperor',
    'The Hierophant': 'major_05_hierophant',
    'The Lovers': 'major_06_lovers',
    'The Chariot': 'major_07_chariot',
    'Strength': 'major_08_strength',
    'The Hermit': 'major_09_hermit',
    'Wheel of Fortune': 'major_10_wheel_of_fortune',
    'Justice': 'major_11_justice',
    'The Hanged Man': 'major_12_hanged_man',
    'Death': 'major_13_death',
    'Temperance': 'major_14_temperance',
    'The Devil': 'major_15_devil',
    'The Tower': 'major_16_tower',
    'The Star': 'major_17_star',
    'The Moon': 'major_18_moon',
    'The Sun': 'major_19_sun',
    'Judgement': 'major_20_judgement',
    'The World': 'major_21_world',
  };

  if (majorMap.containsKey(nameEn)) return majorMap[nameEn];

  // Minor Arcana: "X of Suit" pattern
  final match = RegExp(r'^(\w+) of (\w+)$', caseSensitive: false).firstMatch(nameEn);
  if (match != null) {
    final rank = match.group(1)!.toLowerCase();
    final suit = match.group(2)!.toLowerCase();
    final number = _minorNumbers[rank];
    if (number != null) {
      return 'minor_${suit}_$number';
    }
  }

  return null;
}

/// Displays tarot reading results as a horizontal row of card images
/// with position labels and orientation indicators.
class TarotReadingCard extends StatelessWidget {
  final String payloadJson;

  const TarotReadingCard({super.key, required this.payloadJson});

  List<Map<String, dynamic>>? _parseCards() {
    try {
      final payload = jsonDecode(payloadJson) as Map<String, dynamic>;
      final data = payload['data'] as Map<String, dynamic>?;
      if (data == null) return null;
      final cards = data['cards'] as List<dynamic>?;
      if (cards == null || cards.isEmpty) return null;
      return cards.cast<Map<String, dynamic>>();
    } catch (_) {
      return null;
    }
  }

  String? _spreadLabel() {
    try {
      final payload = jsonDecode(payloadJson) as Map<String, dynamic>;
      final data = payload['data'] as Map<String, dynamic>?;
      return data?['spread_type_cn'] as String? ??
          data?['spread_type'] as String?;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cards = _parseCards();
    if (cards == null) return const SizedBox.shrink();

    final spread = _spreadLabel();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        if (spread != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              spread,
              style: const TextStyle(
                color: CosmicColors.tarotGoldLight,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cards.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) =>
                _TarotCardTile(card: cards[index]),
          ),
        ),
      ],
    );
  }
}

class _TarotCardTile extends StatelessWidget {
  final Map<String, dynamic> card;

  const _TarotCardTile({required this.card});

  @override
  Widget build(BuildContext context) {
    final nameEn = card['name_en'] as String? ?? '';
    final name = card['name'] as String? ?? nameEn;
    final position = card['position'] as String? ??
        card['position_en'] as String? ??
        '';
    final isReversed = card['is_reversed'] as bool? ?? false;

    // Prefer backend-provided image_key, fall back to name-based derivation
    final imageKey = card['image_key'] as String? ?? _deriveImageKey(nameEn);

    return SizedBox(
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Card image
          Container(
            width: 80,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: CosmicColors.tarotGold.withAlpha(102), // 40%
                width: 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: imageKey != null
                ? Transform.rotate(
                    angle: isReversed ? math.pi : 0,
                    child: Image.asset(
                      CardAssetPaths.tarotAssetPath(imageKey),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _fallbackCard(name),
                    ),
                  )
                : _fallbackCard(name),
          ),
          const SizedBox(height: 4),
          // Card name
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CosmicColors.textPrimary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Position + orientation
          Text(
            '$position ${isReversed ? '\u9006\u4F4D' : '\u6B63\u4F4D'}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isReversed
                  ? CosmicColors.error.withAlpha(179) // 70%
                  : CosmicColors.tarotGoldLight.withAlpha(179),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackCard(String name) {
    return Container(
      color: CosmicColors.nebulaStart,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: CosmicColors.tarotGoldLight,
          fontSize: 10,
        ),
      ),
    );
  }
}
