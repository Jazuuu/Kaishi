import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/lesson.dart';

/// Loads Kaishi's structured lesson content from the local JSON
class LessonService {
  static Map<LessonCategory, List<Lesson>>? _cache;

  /// Loads and parses assets/data/lessons.json once, then reuses
  /// the parsed result for subsequent calls.
  static Future<Map<LessonCategory, List<Lesson>>> loadLessons() async {
    if (_cache != null) return _cache!;

    final raw = await rootBundle.loadString('assets/data/lessons.json');
    final Map<String, dynamic> data = jsonDecode(raw) as Map<String, dynamic>;

    final Map<LessonCategory, List<Lesson>> result = {};
    for (final category in LessonCategory.values) {
      final list = (data[category.jsonKey] as List<dynamic>? ?? [])
          .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList();
      result[category] = list;
    }

    _cache = result;
    return result;
  }

  /// Finds a lesson by its id across every category, used when the
  /// Home Screen's "Continue Learning" button needs to jump to the last lesson the user viewed.
  static Lesson? findLessonById(
    Map<LessonCategory, List<Lesson>> lessons,
    String? id,
  ) {
    if (id == null) return null;
    for (final list in lessons.values) {
      for (final lesson in list) {
        if (lesson.id == id) return lesson;
      }
    }
    return null;
  }

  static LessonCategory? categoryOfLesson(
    Map<LessonCategory, List<Lesson>> lessons,
    String? id,
  ) {
    if (id == null) return null;
    for (final entry in lessons.entries) {
      if (entry.value.any((l) => l.id == id)) return entry.key;
    }
    return null;
  }
}
