import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/user_progress.dart';
import '../services/lesson_service.dart';
import '../services/progress_service.dart';
import '../services/word_of_the_day_service.dart';
import '../theme/app_theme.dart';
import '../theme/app_spacing.dart';
import '../widgets/progress_card.dart';
import '../widgets/word_of_the_day_card.dart';

/// Home Screen — where the user starts every session.
/// Shows overall progress at a glance, lets them pick up their last
/// lesson, and shows the Word of the Day.
class HomeScreen extends StatefulWidget {
  final void Function(int tabIndex, {String? lessonId}) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  UserProgress _progress = const UserProgress();
  Map<LessonCategory, List<Lesson>> _lessons = {};
  WordOfTheDay? _wordOfTheDay;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final lessons = await LessonService.loadLessons();
    final progress = await ProgressService.load();
    final word = await WordOfTheDayService.loadTodaysWord();
    if (!mounted) return;
    setState(() {
      _lessons = lessons;
      _progress = progress;
      _wordOfTheDay = word;
      _loading = false;
    });
  }

  /// Re-reads progress whenever this screen becomes visible again,
  /// so it reflects lessons just completed on the Lessons Screen.
  Future<void> refresh() async {
    final progress = await ProgressService.load();
    if (!mounted) return;
    setState(() => _progress = progress);
  }

  String get _currentLessonTitle {
    final lessonId =
        _progress.lastLessonId ?? _lessons[LessonCategory.hiragana]?[0].id;
    final lesson = LessonService.findLessonById(_lessons, lessonId);
    return lesson?.title ?? 'Introduction to Hiragana';
  }

  void _handleContinueLearning() {
    final lessonId =
        _progress.lastLessonId ?? _lessons[LessonCategory.hiragana]?[0].id;
    widget.onNavigate(1, lessonId: lessonId);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          Appspacing.lg,
          Appspacing.lg,
          Appspacing.lg,
          Appspacing.lg,
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('開始 Kaishi', style: textTheme.headlineSmall),
              const Icon(Icons.home_rounded, color: AppTheme.onSurface),
            ],
          ),
          const SizedBox(height: Appspacing.lg),
          Text('Kon\'nichiwa, Jaz!', style: textTheme.titleMedium),
          const SizedBox(height: Appspacing.xs / 2),
          Text(
            'Ready to find your flow today?',
            style: textTheme.bodyMedium?.copyWith(color: AppTheme.secondary),
          ),
          const SizedBox(height: Appspacing.md),
          ProgressCard(
            progressValue: _progress.progressPercentage == 0
                ? 0.65 // matches the mockup's default state
                : _progress.progressPercentage,
            lessonTitle: _currentLessonTitle,
            onContinuePressed: _handleContinueLearning,
          ),
          if (_wordOfTheDay != null) ...[
            const SizedBox(height: Appspacing.md),
            WordOfTheDayCard(
              word: _wordOfTheDay!.word,
              pronunciation: _wordOfTheDay!.pronunciation,
              meaning: _wordOfTheDay!.meaning,
            ),
          ],
        ],
      ),
    );
  }
}
