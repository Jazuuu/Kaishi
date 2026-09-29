import 'dart:convert';

/// Tracks the user's progress through Kaishi's lessons.
///
/// this stores:
/// - the list of completed lesson IDs
/// - the last lesson ID the user viewed
/// - an overall progress percentage

class UserProgress {
  final List<String> completedLessonIds;
  final String? lastLessonId;
  final double progressPercentage;

  const UserProgress({
    this.completedLessonIds = const [],
    this.lastLessonId,
    this.progressPercentage = 0.0,
  });

  UserProgress copyWith({
    List<String>? completedLessonIds,
    String? lastLessonId,
    double? progressPercentage,
  }) {
    return UserProgress(
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      lastLessonId: lastLessonId ?? this.lastLessonId,
      progressPercentage: progressPercentage ?? this.progressPercentage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completedLessonIds': completedLessonIds,
      'lastLessonId': lastLessonId,
      'progressPercentage': progressPercentage,
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      completedLessonIds:
          (json['completedLessonIds'] as List<dynamic>? ?? [])
              .map((e) => e.toString())
              .toList(),
      lastLessonId: json['lastLessonId'] as String?,
      progressPercentage:
          (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String encode() => jsonEncode(toJson());

  factory UserProgress.decode(String source) =>
      UserProgress.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
