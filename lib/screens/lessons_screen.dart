import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/user_progress.dart';
import '../services/lesson_service.dart';
import '../services/progress_service.dart';
import '../theme/app_theme.dart';
import '../theme/app_spacing.dart';
import '../widgets/lesson_card.dart';
import '../widgets/lesson_tab.dart';
import '../widgets/primary_button.dart';

/// Lessons Screen — study Hiragana, Katakana, or basic grammar
/// in one place. The three tabs share one lesson layout, and the
/// content changes dynamically based on the local JSON data.
class LessonsScreen extends StatefulWidget {
  /// The lesson to open first, Screen's "Continue Learning" button.
  final String? initialLessonId;

  /// Notified whenever the active lesson changes, so the AI Assistant Screen can stay lesson-aware.
  final ValueChanged<Lesson>? onActiveLessonChanged;

  const LessonsScreen({
    super.key,
    this.initialLessonId,
    this.onActiveLessonChanged,
  });

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  Map<LessonCategory, List<Lesson>> _lessons = {};
  UserProgress _progress = const UserProgress();
  LessonCategory _activeCategory = LessonCategory.hiragana;
  int _activeLessonIndex = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant LessonsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialLessonId != null &&
        widget.initialLessonId != oldWidget.initialLessonId) {
      _openLesson(widget.initialLessonId);
    }
  }

  Future<void> _load() async {
    final lessons = await LessonService.loadLessons();
    final progress = await ProgressService.load();
    if (!mounted) return;
    setState(() {
      _lessons = lessons;
      _progress = progress;
      _loading = false;
    });
    if (widget.initialLessonId != null) {
      _openLesson(widget.initialLessonId);
    } else {
      _notifyActiveLesson();
    }
  }

  void _openLesson(String? lessonId) {
    if (lessonId == null) return;
    final category = LessonService.categoryOfLesson(_lessons, lessonId);
    if (category == null) return;
    final index = _lessons[category]!.indexWhere((l) => l.id == lessonId);
    if (index == -1) return;
    setState(() {
      _activeCategory = category;
      _activeLessonIndex = index;
    });
    _notifyActiveLesson();
  }

  void _notifyActiveLesson() {
    final lesson = _activeLesson;
    if (lesson != null) widget.onActiveLessonChanged?.call(lesson);
  }

  List<Lesson> get _activeLessons => _lessons[_activeCategory] ?? [];

  Lesson? get _activeLesson {
    if (_activeLessons.isEmpty) return null;
    final index = _activeLessonIndex.clamp(0, _activeLessons.length - 1);
    return _activeLessons[index];
  }

  Future<void> _handleContinueLearning() async {
    final lesson = _activeLesson;
    if (lesson == null) return;

    final total = ProgressService.totalLessonCount(_lessons);
    final updated = await ProgressService.markLessonComplete(
      current: _progress,
      lessonId: lesson.id,
      totalLessons: total,
    );

    if (!mounted) return;
    setState(() {
      _progress = updated;
      // Load the next lesson in this category, if there is one.
      if (_activeLessonIndex < _activeLessons.length - 1) {
        _activeLessonIndex += 1;
      }
    });
    _notifyActiveLesson();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${lesson.title}" marked complete!'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.onPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final lesson = _activeLesson;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Appspacing.lg,
          Appspacing.lg,
          Appspacing.lg,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('開始 Kaishi', style: textTheme.headlineSmall),
                const Icon(
                  Icons.menu_book_rounded,
                  color: AppTheme.onSurface,
                ),
              ],
            ),
            const SizedBox(height: Appspacing.lg),
            Text('Daily Lessons', style: textTheme.titleMedium),
            const SizedBox(height: Appspacing.md),
            Container(
              padding: const EdgeInsets.all(Appspacing.xs / 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: LessonCategory.values.map((category) {
                  return LessonTab(
                    label: category.label,
                    selected: category == _activeCategory,
                    onTap: () {
                      setState(() {
                        _activeCategory = category;
                        _activeLessonIndex = 0;
                      });
                      _notifyActiveLesson();
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: Appspacing.md),
            Expanded(
              child: ListView(
                children: [
                  if (lesson != null)
                    LessonCard(
                      lessonTitle: lesson.title,
                      description: lesson.description,
                      characters: lesson.characters,
                      vocabulary: lesson.vocabulary,
                    ),
                  const SizedBox(height: Appspacing.md),
                  PrimaryButton(
                    label: 'Continue Learning',
                    onPressed: lesson == null
                        ? null
                        : _handleContinueLearning,
                  ),
                  const SizedBox(height: Appspacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
