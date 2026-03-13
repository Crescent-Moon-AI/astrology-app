import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/theme/cosmic_colors.dart';

/// Structured display for web_search tool results.
///
/// Shows search results as a list of clickable link cards with
/// title, source domain, and snippet — matching the frontend
/// WebSearchFormatter layout.
class WebSearchResultCard extends StatelessWidget {
  final String payloadJson;

  const WebSearchResultCard({super.key, required this.payloadJson});

  @override
  Widget build(BuildContext context) {
    final payload = _parse();
    if (payload == null) return const SizedBox.shrink();

    final results = payload.results;
    final isZh =
        Localizations.localeOf(context).languageCode.startsWith('zh');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        // Header: query + result count
        Row(
          children: [
            Expanded(
              child: Text(
                '${isZh ? "搜索" : "Search"}: ${payload.query}',
                style: const TextStyle(
                  color: CosmicColors.textSecondary,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: CosmicColors.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${results.length} ${isZh ? "条结果" : "results"}',
                style: const TextStyle(
                  color: CosmicColors.primaryLight,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        if (results.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              isZh ? '未找到相关结果' : 'No results found',
              style: const TextStyle(
                color: CosmicColors.textTertiary,
                fontSize: 12,
              ),
            ),
          )
        else
          ...results.take(5).map((r) => _ResultItem(result: r)),
      ],
    );
  }

  _WebSearchData? _parse() {
    try {
      final json = jsonDecode(payloadJson) as Map<String, dynamic>;
      // The envelope wraps data inside "data" when ok:true
      final data = (json['data'] ?? json) as Map<String, dynamic>;
      return _WebSearchData.fromJson(data);
    } catch (_) {
      return null;
    }
  }
}

class _ResultItem extends StatelessWidget {
  final _SearchResult result;

  const _ResultItem({required this.result});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: InkWell(
        onTap: () => _openUrl(result.url, context),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: CosmicColors.background,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: CosmicColors.primary.withAlpha(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                result.title,
                style: const TextStyle(
                  color: CosmicColors.primaryLight,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Source domain
              Text(
                result.source,
                style: TextStyle(
                  color: Colors.green.shade400,
                  fontSize: 11,
                ),
              ),
              // Snippet
              if (result.snippet.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  result.snippet,
                  style: const TextStyle(
                    color: CosmicColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openUrl(String url, BuildContext context) async {
    // Copy URL to clipboard as a simple fallback (no url_launcher dependency)
    await Clipboard.setData(ClipboardData(text: url));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Localizations.localeOf(context).languageCode.startsWith('zh')
                ? '链接已复制'
                : 'Link copied',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

class _WebSearchData {
  final String query;
  final List<_SearchResult> results;

  _WebSearchData({required this.query, required this.results});

  factory _WebSearchData.fromJson(Map<String, dynamic> json) {
    final resultsList = (json['results'] as List<dynamic>?)
            ?.map((r) =>
                _SearchResult.fromJson(r as Map<String, dynamic>))
            .toList() ??
        [];
    return _WebSearchData(
      query: json['query'] as String? ?? '',
      results: resultsList,
    );
  }
}

class _SearchResult {
  final String title;
  final String url;
  final String snippet;
  final String source;

  _SearchResult({
    required this.title,
    required this.url,
    required this.snippet,
    required this.source,
  });

  factory _SearchResult.fromJson(Map<String, dynamic> json) {
    return _SearchResult(
      title: json['title'] as String? ?? '',
      url: json['url'] as String? ?? '',
      snippet: json['snippet'] as String? ?? '',
      source: json['source'] as String? ?? '',
    );
  }
}
