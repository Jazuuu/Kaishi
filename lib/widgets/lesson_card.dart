import 'package:flutter/material.dart';
import '../models/vocabulary.dart';
import '../theme/app_theme.dart';
import '../theme/app_spacing.dart';
import 'vocabulary_card.dart';

/// LessonCard — appears on the Lessons Screen. One reusable
/// layout whose content (title, description, character tiles,
/// vocabulary) changes based on the active category's local JSON
/// data.
class LessonCard extends StatelessWidget {
  final String lessonTitle;
  final String description;
  final List<CharacterTile> characters;
  final List<Vocabulary> vocabulary;

  const LessonCard({
    super.key,
    required this.lessonTitle,
    required this.description,
    required this.characters,
    required this.vocabulary,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Appspacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lessonTitle, style: textTheme.titleMedium),
            const SizedBox(height: Appspacing.sm),
            Text(description, style: textTheme.bodyMedium),
            if (characters.isNotEmpty) ...[
              const SizedBox(height: Appspacing.md),
              Row(
                children: characters
                    .map(
                      (c) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Appspacing.xs / 2,
                          ),
                          child: _CharacterTileView(character: c),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
            if (vocabulary.isNotEmpty) ...[
              const SizedBox(height: Appspacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Appspacing.sm),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VOCABULARY EXAMPLES',
                      style: textTheme.labelSmall?.copyWith(
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    for (final v in vocabulary)
                      VocabularyCard(
                        word: v.word,
                        pronunciation: v.pronunciation,
                        meaning: v.meaning,
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CharacterTileView extends StatelessWidget {
  final CharacterTile character;

  const _CharacterTileView({required this.character});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Appspacing.sm),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            character.char,
            style: textTheme.titleMedium?.copyWith(fontSize: 20),
          ),
          Text(character.romaji, style: textTheme.labelSmall),
        ],
      ),
    );
  }
}
