import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';
import '../theme/app_theme.dart';
import '../theme/app_spacing.dart';
import '../widgets/ai_chat_bubble.dart';
import '../widgets/app_header.dart';
import '../widgets/chat_input.dart';

///  AI Chat Screen — ask Sensei questions about the lesson
/// powered by the Gemini API, without leaving the app.
class AIAssistantScreen extends StatefulWidget {
  /// The title of the lesson the user is currently studying, used
  /// both in the greeting and as context for Gemini.
  final String currentLessonTitle;

  const AIAssistantScreen({super.key, required this.currentLessonTitle});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final GeminiService _gemini = GeminiService();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        text:
            'Hajimemashite! I\'m your AI Sensei. Ask me anything about '
            'today\'s lesson on ${widget.currentLessonTitle}.',
        sender: 'sensei',
      ),
    );
  }

  @override
  void didUpdateWidget(covariant AIAssistantScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-greet if the user switched lessons since opening this
    // screen, so Sensei's context stays lesson-aware.
    if (widget.currentLessonTitle != oldWidget.currentLessonTitle &&
        _messages.length == 1) {
      setState(() {
        _messages[0] = ChatMessage(
          text:
              'Hajimemashite! I\'m your AI Sensei. Ask me anything about '
              'today\'s lesson on ${widget.currentLessonTitle}.',
          sender: 'sensei',
        );
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _handleSend(String question) async {
    setState(() {
      _messages.add(ChatMessage(text: question, sender: 'user'));
      _isSending = true;
    });
    _scrollToBottom();

    try {
      final reply = await _gemini.askSensei(
        question: question,
        lessonTitle: widget.currentLessonTitle,
      );
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: reply, sender: 'sensei'));
      });
    } on MissingApiKeyException {
      if (!mounted) return;
      setState(() {
        _messages.add(
          const ChatMessage(
            text:
                'Sensei is only available when the app runs locally with a '
                'Gemini API key. Add one to assets/.env (see .env.example), '
                'then try again.',
            sender: 'sensei',
            isError: true,
          ),
        );
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          const ChatMessage(
            text:
                'Sensei couldn\'t reach Gemini just now. Check your '
                'connection and try again.',
            sender: 'sensei',
            isError: true,
          ),
        );
      });
    } finally {
      if (mounted) setState(() => _isSending = false);
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Appspacing.lg,
          Appspacing.lg,
          Appspacing.lg,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('開始 Kaishi', style: textTheme.headlineSmall),
                const Icon(
                  Icons.emoji_people_rounded,
                  color: AppTheme.onSurface,
                ),
              ],
            ),
            const SizedBox(height: Appspacing.md),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length + (_isSending ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    return const _TypingIndicator();
                  }
                  final message = _messages[index];
                  return AIChatBubble(
                    message: message.text,
                    sender: message.sender,
                    isError: message.isError,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Appspacing.sm),
              child: ChatInput(
                hintText: 'Ask Sensei...',
                onSend: _handleSend,
                enabled: !_isSending,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: Appspacing.xs),
        padding: const EdgeInsets.symmetric(
          horizontal: Appspacing.md,
          vertical: Appspacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFECECEC)),
        ),
        child: const SizedBox(
          width: 24,
          height: 14,
          child: Center(
            child: SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      ),
    );
  }
}
