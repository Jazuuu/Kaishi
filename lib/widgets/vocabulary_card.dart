import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_spacing.dart';

/// VocabularyCard (ListItemCard) — a single row inside the
/// "VOCABULARY EXAMPLES" section of a LessonCard.
class VocabularyCard extends StatelessWidget {
  final String word;
  final String pronunciation;
  final String meaning;

  const VocabularyCard({
    super.key,
    required this.word,
    required this.pronunciation,
    required this.meaning,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Appspacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: textTheme.bodyMedium,
                children: [
                  TextSpan(text: word),
                  TextSpan(
                    text: ' ($pronunciation)',
                    style: textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ),
          Text(
            meaning,
            style: textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
