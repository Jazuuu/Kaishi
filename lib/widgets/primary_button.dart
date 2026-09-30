import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_spacing.dart';

/// Primary Button — appears on the Home Screen ("Continue
/// Learning") and the Lessons Screen.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const PrimaryButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: AppTheme.onPrimary,
          disabledBackgroundColor: AppTheme.primary.withValues(alpha: 0.5),
          disabledForegroundColor: AppTheme.onPrimary.withValues(alpha: 0.6),
          padding: const EdgeInsets.symmetric(vertical: Appspacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppTheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: Appspacing.xs),
            const Icon(Icons.play_arrow_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}