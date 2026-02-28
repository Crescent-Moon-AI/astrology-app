class SharedCard {
  final String id;
  final String cardType; // chart, horoscope, tarot, synastry
  final Map<String, dynamic> sourceData;
  final String shareToken;
  final String? imageUrl;
  final String shareUrl;
  final DateTime expiresAt;
  final int viewCount;
  final DateTime createdAt;

  const SharedCard({
    required this.id,
    required this.cardType,
    required this.sourceData,
    required this.shareToken,
    this.imageUrl,
    required this.shareUrl,
    required this.expiresAt,
    required this.viewCount,
    required this.createdAt,
  });

  factory SharedCard.fromJson(Map<String, dynamic> json) {
    return SharedCard(
      id: json['id'] as String,
      cardType: json['card_type'] as String,
      sourceData: json['source_data'] as Map<String, dynamic>? ?? {},
      shareToken: json['share_token'] as String,
      imageUrl: json['image_url'] as String?,
      shareUrl: json['share_url'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      viewCount: json['view_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
