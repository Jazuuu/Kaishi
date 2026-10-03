import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/// A single Word of the Day entry
class WordOfTheDay {
  final String word;
  final String pronunciation;
  final String meaning;

  const WordOfTheDay({
    required this.word,
    required this.pronunciation,
    required this.meaning,
  });

  factory WordOfTheDay.fromJson(Map<String, dynamic> json) {
    return WordOfTheDay(
      word: json['word'] as String,
      pronunciation: json['pronunciation'] as String,
      meaning: json['meaning'] as String,
    );
  }
}

///picks one entry per calendar day so it stays stable all day but changes daily.
class WordOfTheDayService {
  static List<WordOfTheDay>? _cache;

  static Future<WordOfTheDay?> loadTodaysWord() async {
    final raw = await rootBundle.loadString(
      'assets/data/word_of_the_day.json',
    );
    final List<dynamic> data = jsonDecode(raw) as List<dynamic>;
    _cache ??= data
        .map((e) => WordOfTheDay.fromJson(e as Map<String, dynamic>))
        .toList();

    if (_cache!.isEmpty) return null;

    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    return _cache![dayOfYear % _cache!.length];
  }
}
