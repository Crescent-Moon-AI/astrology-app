/// Utility for resolving card image asset paths.
class CardAssetPaths {
  CardAssetPaths._();

  /// Returns the asset path for a tarot card given its [imageKey].
  ///
  /// The [imageKey] should match the filename without extension, e.g.
  /// `major_00_fool` → `assets/images/tarot/major_00_fool.png`.
  static String tarotAssetPath(String imageKey) =>
      'assets/images/tarot/$imageKey.webp';

  /// Returns the asset path for a Lenormand card given its [number] (1-36).
  ///
  /// `1` → `assets/images/lenormand/lenormand_01.png`.
  static String lenormandAssetPath(int number) {
    final padded = number.toString().padLeft(2, '0');
    return 'assets/images/lenormand/lenormand_$padded.png';
  }
}
