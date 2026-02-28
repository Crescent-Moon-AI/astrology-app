enum MoodTag {
  happy('happy', '\u{1F60A}', 'Happy'),
  anxious('anxious', '\u{1F630}', 'Anxious'),
  creative('creative', '\u{1F3A8}', 'Creative'),
  tired('tired', '\u{1F634}', 'Tired'),
  romantic('romantic', '\u{1F495}', 'Romantic'),
  calm('calm', '\u{1F60C}', 'Calm'),
  energetic('energetic', '\u{26A1}', 'Energetic'),
  confused('confused', '\u{1F914}', 'Confused');

  const MoodTag(this.value, this.emoji, this.label);
  final String value;
  final String emoji;
  final String label;
}
