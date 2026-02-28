import 'package:flutter/material.dart';
import '../../domain/models/friend_profile.dart';

class RelationshipLabelBadge extends StatelessWidget {
  final String label;

  const RelationshipLabelBadge({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final rel = RelationshipLabel.fromValue(label);
    final (color, displayText) = _labelStyle(context, rel);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (Color, String) _labelStyle(BuildContext context, RelationshipLabel? rel) {
    final locale = Localizations.localeOf(context).languageCode;
    if (rel == null) {
      return (Colors.grey, label.isEmpty ? '?' : label);
    }

    final displayText = locale == 'zh' ? rel.labelZH : rel.labelEN;

    switch (rel) {
      case RelationshipLabel.partner:
        return (Colors.pink, displayText);
      case RelationshipLabel.family:
        return (Colors.orange, displayText);
      case RelationshipLabel.friend:
        return (Colors.blue, displayText);
      case RelationshipLabel.colleague:
        return (Colors.teal, displayText);
      case RelationshipLabel.crush:
        return (Colors.purple, displayText);
    }
  }
}
