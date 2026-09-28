import 'vocabulary.dart';

class Lesson {
  final String id;
  final String title;
  final String description;
  final List<CharacterTile> characters;
  final List<Vocabulary> vocabulary;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.characters,
    required this.vocabulary,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      characters: (json['characters'] as List<dynamic>? ?? [])
          .map((e) => CharacterTile.fromJson(e as Map<String, dynamic>))
          .toList(),
      vocabulary: (json['vocabulary'] as List<dynamic>? ?? [])
          .map((e) => Vocabulary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// One of the three lesson categories shown as tabs on the
/// Lessons Screen: Hiragana, Katakana, Grammar.
enum LessonCategory { hiragana, katakana, grammar }

extension LessonCategoryLabel on LessonCategory {
  String get label {
    switch (this) {
      case LessonCategory.hiragana:
        return 'Hiragana';
      case LessonCategory.katakana:
        return 'Katakana';
      case LessonCategory.grammar:
        return 'Grammar';
    }
  }

  String get jsonKey {
    switch (this) {
      case LessonCategory.hiragana:
        return 'hiragana';
      case LessonCategory.katakana:
        return 'katakana';
      case LessonCategory.grammar:
        return 'grammar';
    }
  }
}
