# Design system

[Design system (PDF)](assets/Angeles-Final-Project-Design-System-(Revised).pdf)

## Step A: The palette, as a ColorScheme

### Color Token Table

| Role | Hex | Used For |
|------|-----|----------|
| `primary` | `#FFD1DC` | Main buttons, selected states, pastel pink accent |
| `onPrimary` | `#4A3F45` | Text/icons on primary surfaces (also used as onSecondary) |
| `secondary` | `#8FA7B3` | Secondary accents, muted blue-gray |
| `onSecondary` | `#4A3F45` | Text/icons on secondary surfaces (same value as onPrimary) |
| `background (scaffold)` | `#FAF7F8` | Main screen background and App Bar background |
| `surface` | `#FFFFFF` | Resolved status text/icons |
| `background` | `#F8F9FF` | Main screen background |
| `onSurface` | `#2C2C2C` | Cards and content surfaces |
| `surfaceTint` | `#DBE1FF` | Body text, headings, labels, App Bar foreground |
| `error` | `#E5484D` |Validation errors, failed actions |
| `onError` | `#FFFFFF` | Text/icons on error surfaces |
| Caption text | `#6B6B6B` | Caption color, set on the labelSmall text style |

## Type scale

| Your Style | Flutter slot | Size | Weight | Used For |
|------------|--------------|------|--------|----------|
| Heading | `headlineSmall` | 22sp | Bold | Screen titles (Home, Lessons) |
| Subheading | `titleMedium` | 16sp |	SemiBold (w600) | Lesson titles, section headings |
| Body | `bodyMedium` (weight override) | 14sp | Regular | Lesson explanations, AI responses, vocabulary |
| Label | `labelMedium` | 13sp | 	Medium (w500) | Buttons, navigation labels, tabs |
| Caption | `labelSmall` | 12sp | Regular | Progress text, helper text, vocabulary labels|

## Spacing

```dart
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;   // 4px
  static const double sm = 8;   // 8px  - base unit / gap between list items
  static const double md = 16;  // 16px - gap between sections
  static const double lg = 24;  // 24px - screen edge padding
}
```

## Components

| Component | Level | File | Constructor Parameter | Appears On |
|-----------|-------|------|-----------------------|------------|
| Primary Button | Atom | `lib/widgets/primary_button.dart` | `String label, VoidCallback? onPressed` | Home (inside Progress Card, "Continue Learning") | Lessons |
| Lesson Tab | Atom | `lib/widgets/lesson_tab.dart` | `SString label, bool selected, VoidCallback onTap` | Lessons |
| Vocabulary Card | Atom | `lib/widgets/vocabulary_card.dart` | `String word, String pronunciation, String meaning` | Lessons (inside Lesson Card)|
| Progress Card | Molecule | `lib/widgets/progress_card.dart` | `double progressValue, String lessonTitle, VoidCallback? onContinuePressed` | Home |
| Word of the Day Card | Molecule | `lib/widgets/word_of_the_day_card.dart` | `String word, String pronunciation, String meaning` | Home |
| AI Chat Bubble | Molecule | `lib/widgets/ai_chat_bubble.dart` | `String message, String sender, bool isError` | Sensei (AI Assistant) |
| Chat Input | Molecule | `lib/widgets/chat_input.dart` | `String hintText, ValueChanged<String> onSend, bool enabled` | Sensei (AI Assistant) |
| Lesson Card | Organism | `lib/widgets/lesson_card.dart` | `String lessonTitle, String description, List<CharacterTile> characters, List<Vocabulary> vocabulary` | Lessons |
| Bottom Navigation Bar | Organism | `lib/widgets/bottom_navigation_bar.dart` | `int activeTab, ValueChanged<int> onTap` |Home, Lessons, Sensei (all screens) |
