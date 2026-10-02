import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_spacing.dart';

/// ChatInput — appears on the AI Assistant (Sensei) Screen.
/// The "Ask Sensei..." text field with a send button.
class ChatInput extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onSend;
  final bool enabled;

  const ChatInput({
    super.key,
    required this.hintText,
    required this.onSend,
    this.enabled = true,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Appspacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(999),
            ),
            child: TextField(
              controller: _controller,
              enabled: widget.enabled,
              onSubmitted: (_) => _handleSend(),
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF9A9A9A),
                ),
                border: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        const SizedBox(width: Appspacing.sm),
        IconButton(
          onPressed: widget.enabled ? _handleSend : null,
          icon: const Icon(Icons.arrow_forward_rounded),
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: AppTheme.onPrimary,
            disabledBackgroundColor: AppTheme.primary.withValues(alpha: 0.4),
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(Appspacing.sm),
          ),
        ),
      ],
    );
  }
}
