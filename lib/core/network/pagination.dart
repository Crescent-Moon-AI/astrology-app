/// Cursor-based pagination response wrapper.
class PaginatedResponse<T> {
  final List<T> items;
  final String? nextCursor;
  final bool hasMore;

  const PaginatedResponse({
    required this.items,
    this.nextCursor,
    required this.hasMore,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
      hasMore: json['has_more'] as bool? ?? false,
    );
  }
}
