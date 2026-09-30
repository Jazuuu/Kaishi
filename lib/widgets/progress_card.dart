import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_spacing.dart';
import 'primary_button.dart';

/// ProgressCard — appears on the Home Screen. Display only,
/// except for the embedded "Continue Learning" button.
class ProgressCard extends StatelessWidget {
  final double progressValue;
  final String lessonTitle;
  final VoidCallback? onContinuePressed;

  const ProgressCard({
    super.key,
    required this.progressValue,
    required this.lessonTitle,
    this.onContinuePressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final percentLabel = '${(progressValue * 100).round()}%';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Appspacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CURRENTLY LEARNING',
              style: textTheme.labelSmall?.copyWith(
                letterSpacing: 0.5,
                color: AppTheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Appspacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(lessonTitle, style: textTheme.titleMedium),
                Text(
                  percentLabel,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppTheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Appspacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progressValue.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: AppTheme.primary.withValues(alpha: 0.25),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppTheme.primary,
                ),
              ),
            ),
            const SizedBox(height: Appspacing.md),
            PrimaryButton(
              label: 'Continue Learning',
              onPressed: onContinuePressed,
            ),
          ],
        ),
      ),
    );
  }
}
