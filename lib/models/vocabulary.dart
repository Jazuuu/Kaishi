/// A single vocabulary example shown inside a LessonCard,
class Vocabulary {
  final String word;
  final String pronunciation;
  final String meaning;

  const Vocabulary({
    required this.word,
    required this.pronunciation,
    required this.meaning,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      word: json['word'] as String,
      pronunciation: json['pronunciation'] as String,
      meaning: json['meaning'] as String,
    );
  }
}

/// A single character tile
class CharacterTile {
  final String char;
  final String romaji;

  const CharacterTile({required this.char, required this.romaji});

  factory CharacterTile.fromJson(Map<String, dynamic> json) {
    return CharacterTile(
      char: json['char'] as String,
      romaji: json['romaji'] as String,
    );
  }
}
