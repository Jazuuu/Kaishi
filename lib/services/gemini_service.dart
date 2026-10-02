import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

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
      model: 'gemini-1.5-flash',
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
  /// error, quota, temporary outage, etc.) — both are handled by
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
}
