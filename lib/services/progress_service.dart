import 'package:shared_preferences/shared_preferences.dart';
import '../models/lesson.dart';
import '../models/user_progress.dart';

/// Reads and writes the user's local progress.
/// - storage choice: shared_preferences (no accounts, no sync,
///   no cloud backend needed)
/// - storage key: "user_progress"
/// - what's saved: completed lesson IDs, last lesson ID, and an
///   overall progress percentage — each user's progress stays on
///   their own device and is never shared.
class ProgressService {
  static const String _storageKey = 'user_progress';

  /// Total number of lessons across all three categories, used to
  /// compute the overall progress percentage shown on the Home Screen's ProgressCard.
  static int totalLessonCount(Map<LessonCategory, List<Lesson>> lessons) {
    return lessons.values.fold(0, (sum, list) => sum + list.length);
  }

  static Future<UserProgress> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_storageKey);
    if (stored == null) return const UserProgress();
    try {
      return UserProgress.decode(stored);
    } catch (_) {
      // Corrupted or unrecognized data: fall back to a fresh start instead of crashing.
      return const UserProgress();
    }
  }

  static Future<void> save(UserProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, progress.encode());
  }

  /// Marks a lesson complete, updates the last-viewed lesson, and recalculates 
  /// the overall progress percentage. Called from the  Lessons Screen's "Continue Learning" button.
  static Future<UserProgress> markLessonComplete({
    required UserProgress current,
    required String lessonId,
    required int totalLessons,
  }) async {
    final completed = {...current.completedLessonIds, lessonId}.toList();
    final percentage =
        totalLessons == 0 ? 0.0 : completed.length / totalLessons;

    final updated = current.copyWith(
      completedLessonIds: completed,
      lastLessonId: lessonId,
      progressPercentage: percentage,
    );
    await save(updated);
    return updated;
  }
}
