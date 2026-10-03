import 'dart:async';

import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/user_progress.dart';
import '../services/gemini_service.dart';
import '../services/lesson_service.dart';
import '../services/progress_service.dart';
import '../services/word_of_the_day_service.dart';
import '../theme/app_theme.dart';
import '../theme/app_spacing.dart';
import '../widgets/app_header.dart';
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
  final GeminiService _gemini = GeminiService();

  UserProgress _progress = const UserProgress();
  Map<LessonCategory, List<Lesson>> _lessons = {};
  WordOfTheDay? _wordOfTheDay;
  bool _loading = true;
  bool _wordLoading = false;
  final List<String> _shownWords = [];

  @override
  void initState() {
    super.initState();
    _load();
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
    unawaited(_loadWordOfTheDay());
  }

  // Tries a fresh word live from Gemini first, and only falls back
  // to the bundled local list (no API key, no connection, bad
  // response) instead of showing an error on the Home Screen.
  Future<void> _loadWordOfTheDay() async {
    setState(() => _wordLoading = true);
    WordOfTheDay? word;
    try {
      word = await _gemini.fetchRandomWordOfTheDay(
        avoidWords: _shownWords.length > 10
            ? _shownWords.sublist(_shownWords.length - 10)
            : _shownWords,
      );
    } catch (_) {
      word = await WordOfTheDayService.loadTodaysWord(
        excludeWord: _wordOfTheDay?.word,
      );
    }
    if (word != null) _shownWords.add(word.word);
    if (!mounted) return;
    setState(() {
      _wordOfTheDay = word;
      _wordLoading = false;
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

    return Column(
      children: [
        const AppHeader(title: '開始 Kaishi', icon: Icons.home_rounded),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _load,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Appspacing.lg,
                Appspacing.md,
                Appspacing.lg,
                Appspacing.lg,
              ),
              children: [
                Text('Kon\'nichiwa, Jaz!', style: textTheme.titleMedium),
                const SizedBox(height: Appspacing.xs / 2),
                Text(
                  'Ready to find your flow today?',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondary,
                  ),
                ),
                const SizedBox(height: Appspacing.md),
                ProgressCard(
                  progressValue: _progress.progressPercentage,
                  lessonTitle: _currentLessonTitle,
                  onContinuePressed: _handleContinueLearning,
                ),
                if (_wordOfTheDay != null || _wordLoading) ...[
                  const SizedBox(height: Appspacing.md),
                  _wordOfTheDay == null
                      ? const Card(
                          child: Padding(
                            padding: EdgeInsets.all(Appspacing.md),
                            child: SizedBox(
                              height: 48,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                        )
                      : WordOfTheDayCard(
                          word: _wordOfTheDay!.word,
                          pronunciation: _wordOfTheDay!.pronunciation,
                          meaning: _wordOfTheDay!.meaning,
                          isRefreshing: _wordLoading,
                          onRefresh: _loadWordOfTheDay,
                        ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
