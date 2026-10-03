import 'dart:convert';
import 'dart:math';
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
 
// Local, bundled fallback for Word of the Day — used whenever the
// live Gemini pick (GeminiService.fetchRandomWordOfTheDay) isn't
// available. Picks a genuinely random entry each call (not a fixed
// pick-per-day) so re-shuffling still visibly changes the word even
// when Gemini can't be reached.
class WordOfTheDayService {
  static List<WordOfTheDay>? _cache;
  static final Random _random = Random();
 
  static Future<List<WordOfTheDay>> _loadAll() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString(
      'assets/data/word_of_the_day.json',
    );
    final List<dynamic> data = jsonDecode(raw) as List<dynamic>;
    _cache = data
        .map((e) => WordOfTheDay.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cache!;
  }
 
  static Future<WordOfTheDay?> loadTodaysWord({String? excludeWord}) async {
    final words = await _loadAll();
    if (words.isEmpty) return null;
    if (words.length == 1) return words.first;
 
    WordOfTheDay pick;
    do {
      pick = words[_random.nextInt(words.length)];
    } while (pick.word == excludeWord);
    return pick;
  }
}
