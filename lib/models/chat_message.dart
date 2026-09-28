// A single message in the AI Chat Screen conversation.
// the current AI conversation is temporary, in-memory state only — it is never written to shared_preferences.

class ChatMessage {
  final String text;
  final String sender; // "user" or "ai"
  final bool isError;

  const ChatMessage({
    required this.text,
    required this.sender,
    this.isError = false,
  });

  bool get isUser => sender == 'user';
}
