import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'word_of_the_day_service.dart' show WordOfTheDay;

/// Thrown when the Gemini API key is missing from the local .env
/// file. Kept separate from other failures so the AI Chat Screen
/// can show a clear, specific message.
class MissingApiKeyException implements Exception {
  const MissingApiKeyException();
}

/// Wraps the Gemini API for Kaishi's "Sensei" AI Learning
/// Assistant.
///
/// The API key is read from the .env file at runtime through
/// flutter_dotenv, so it is never hardcoded or committed to the
/// repository.
class GeminiService {
  GenerativeModel? _model;

  static const String _systemInstructionTemplate =
      'You are Sensei, a friendly, encouraging AI assistant inside '
      'Kaishi, an app that teaches beginner Japanese. The user is '
      'currently studying the lesson "{lessonTitle}". Answer their '
      'question about it (or about Hiragana, Katakana, and basic '
      'grammar generally) in simple, beginner-friendly terms, with a '
      'short example where it helps. Keep responses concise.';

  bool get hasApiKey {
    final key = dotenv.env['GEMINI_API_KEY'];
    return key != null && key.trim().isNotEmpty;
  }

  void _ensureModel(String lessonTitle) {
    if (!hasApiKey) {
      throw const MissingApiKeyException();
    }
    // Recreate the model whenever the active lesson changes so the
    // system instruction stays lesson-aware, matching the mockup's
    // greeting ("Ask me anything about today's lesson on ...").
    _model = GenerativeModel(
      model: 'gemini-3.8-flash',
      apiKey: dotenv.env['GEMINI_API_KEY']!,
      systemInstruction: Content.system(
        _systemInstructionTemplate.replaceFirst('{lessonTitle}', lessonTitle),
      ),
    );
  }

  /// Sends the user's question to Gemini and returns Sensei's reply.
  ///
  /// Throws [MissingApiKeyException] if no key is configured, or a
  /// generic [Exception] if the request itself fails (network
  /// error, quota, temporary outage, etc.) both are handled by
  /// the AI Chat Screen, which shows an in-chat error message
  /// instead of crashing .
  Future<String> askSensei({
    required String question,
    required String lessonTitle,
  }) async {
    _ensureModel(lessonTitle);
    final response = await _model!.generateContent([Content.text(question)]);
    final text = response.text?.trim();
    if (text == null || text.isEmpty) {
      throw Exception('Sensei had no response. Please try again.');
    }
    return text;
  }

  /// Asks Gemini for a random, beginner-friendly Japanese word or
  /// short phrase, for the Home Screen's Word of the Day card.
  /// Pass [avoidWords] (recently shown words this session) so
  /// re-shuffling doesn't just repeat itself. Throws
  /// [MissingApiKeyException] if no key is configured, or an
  /// [Exception] if the request/parsing fails — both are handled by
  /// the Home Screen, which falls back to a random pick from the
  /// bundled local word list.
  Future<WordOfTheDay> fetchRandomWordOfTheDay({
    List<String> avoidWords = const [],
  }) async {
    if (!hasApiKey) {
      throw const MissingApiKeyException();
    }

    final model = GenerativeModel(
      model: 'gemini-3.8-flash',
      apiKey: dotenv.env['GEMINI_API_KEY']!,
      generationConfig: GenerationConfig(temperature: 1.4, topP: 0.98),
    );

    // A random nonce plus an explicit avoid-list gives the model
    // something to actually vary its pick against.
    final nonce = Random().nextInt(1000000);
    final avoidClause = avoidWords.isEmpty
        ? ''
        : ' Do not repeat any of these words already shown this '
              'session: ${avoidWords.join(", ")}.';

    final prompt =
        'Pick one random, beginner-friendly (JLPT N5-ish) Japanese word or '
        'short expression — ideally something evocative, fun, or useful for '
        'a beginner to learn today.$avoidClause '
        '(random seed: $nonce — use it to help you pick something '
        'different each time, but never mention the seed in your answer) '
        'Respond with ONLY raw JSON in exactly this shape, no markdown '
        'fences, no extra commentary before or after it: '
        '{"word": "<word in Japanese script>", '
        '"pronunciation": "<romaji reading>", '
        '"meaning": "<short one-sentence English meaning>"}';

    final response = await model.generateContent([Content.text(prompt)]);
    final raw = response.text?.trim() ?? '';
    if (raw.isEmpty) {
      throw Exception('Gemini returned an empty Word of the Day response.');
    }

    final match = RegExp(r'\{[\s\S]*\}').firstMatch(raw);
    final cleaned = (match?.group(0) ?? raw)
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    final Map<String, dynamic> data =
        jsonDecode(cleaned) as Map<String, dynamic>;
    return WordOfTheDay.fromJson(data);
  }
}
