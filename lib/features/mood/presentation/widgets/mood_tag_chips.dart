import 'package:flutter/material.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import '../../domain/models/mood_tag.dart';

class MoodTagChips extends StatelessWidget {
  final Set<String> selectedTags;
  final ValueChanged<Set<String>> onTagsChanged;

  const MoodTagChips({
    super.key,
    required this.selectedTags,
    required this.onTagsChanged,
  });

  String _tagLabel(AppLocalizations l10n, MoodTag tag) {
    switch (tag) {
      case MoodTag.happy:
        return l10n.moodTagHappy;
      case MoodTag.anxious:
        return l10n.moodTagAnxious;
      case MoodTag.creative:
        return l10n.moodTagCreative;
      case MoodTag.tired:
        return l10n.moodTagTired;
      case MoodTag.romantic:
        return l10n.moodTagRomantic;
      case MoodTag.calm:
        return l10n.moodTagCalm;
      case MoodTag.energetic:
        return l10n.moodTagEnergetic;
      case MoodTag.confused:
        return l10n.moodTagConfused;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: MoodTag.values.map((tag) {
        final isSelected = selectedTags.contains(tag.value);
        return FilterChip(
          selected: isSelected,
          label: Text('${tag.emoji} ${_tagLabel(l10n, tag)}'),
          onSelected: (selected) {
            final updated = Set<String>.from(selectedTags);
            if (selected) {
              updated.add(tag.value);
            } else {
              updated.remove(tag.value);
            }
            onTagsChanged(updated);
          },
        );
      }).toList(),
    );
  }
}
