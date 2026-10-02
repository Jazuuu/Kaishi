import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_spacing.dart';

/// The "Word of the Day" card on the Home Screen
class WordOfTheDayCard extends StatelessWidget {
  final String word;
  final String pronunciation;
  final String meaning;

  const WordOfTheDayCard({
    super.key,
    required this.word,
    required this.pronunciation,
    required this.meaning,
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
            Text(
              'WORD OF THE DAY',
              style: textTheme.labelSmall?.copyWith(
                letterSpacing: 0.5,
                color: AppTheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Appspacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  word,
                  style: textTheme.headlineSmall?.copyWith(fontSize: 26),
                ),
                const SizedBox(width: Appspacing.sm),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    pronunciation,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppTheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Appspacing.xs),
            Text('"$meaning"', style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}