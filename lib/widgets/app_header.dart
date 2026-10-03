import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_spacing.dart';

// Colored banner at the top of every screen
// wordmark plus an icon showing which screen you're on. Decoration only 
class AppHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const AppHeader({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        Appspacing.lg,
        Appspacing.lg,
        Appspacing.lg,
        Appspacing.md,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: AppTheme.onPrimary),
          ),
          Icon(icon, color: AppTheme.onPrimary),
        ],
      ),
    );
  }
}
