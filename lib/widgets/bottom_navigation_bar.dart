import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_spacing.dart';

/// BottomNavigationBar — appears on all screens (Home,Lessons, Sensei).
/// the top-right icon on each screen is decorative only.
class KaishiBottomNavigationBar extends StatelessWidget {
  final int activeTab;
  final ValueChanged<int> onTap;

  const KaishiBottomNavigationBar({
    super.key,
    required this.activeTab,
    required this.onTap,
  });

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.menu_book_rounded, label: 'Lessons'),
    _NavItem(icon: Icons.emoji_people_rounded, label: 'Sensei'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Appspacing.md,
          vertical: Appspacing.sm,
        ),
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(top: BorderSide(color: Color(0xFFEFEFEF))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final selected = index == activeTab;
            return GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Appspacing.md,
                  vertical: Appspacing.xs,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? AppTheme.primary.withValues(alpha: 0.35)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      size: 22,
                      color: selected
                          ? AppTheme.onPrimary
                          : AppTheme.secondary,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: selected
                            ? AppTheme.onPrimary
                            : AppTheme.secondary,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
