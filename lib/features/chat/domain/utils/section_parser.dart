import '../models/message.dart';

class ParsedSection {
  final String title;
  final String content;

  ParsedSection({required this.title, required this.content});
}

/// Check if text contains 2+ section markers.
bool hasSectionMarkers(String text) {
  final regex = RegExp(r'(?:^|\n)---section:.+?---\n', multiLine: true);
  return regex.allMatches(text).length >= 2;
}

/// Parse section markers from text.
/// Uses metadata if available (length >= 2), otherwise falls back to regex parsing.
/// Returns empty list if fewer than 2 sections found.
List<ParsedSection> parseSections(String text, {List<SectionMeta>? metadata}) {
  // Use metadata if provided with 2+ entries
  if (metadata != null && metadata.length >= 2) {
    return metadata.map((m) {
      final content = text
          .substring(
            m.startOffset.clamp(0, text.length),
            m.endOffset.clamp(0, text.length),
          )
          .trim();
      return ParsedSection(title: m.title, content: content);
    }).toList();
  }

  // Regex parsing fallback
  final regex = RegExp(r'(?:^|\n)---section:(.+?)---\n', multiLine: true);
  final matches = regex.allMatches(text).toList();

  if (matches.length < 2) return [];

  final sections = <ParsedSection>[];
  for (var i = 0; i < matches.length; i++) {
    final title = matches[i].group(1)!.trim();
    final startOffset = matches[i].end;
    final endOffset =
        (i + 1 < matches.length) ? matches[i + 1].start : text.length;
    final content = text.substring(startOffset, endOffset).trim();
    sections.add(ParsedSection(title: title, content: content));
  }

  return sections;
}
