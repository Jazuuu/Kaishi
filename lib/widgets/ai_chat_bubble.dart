import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_spacing.dart';

/// AIChatBubble — appears on the AI Assistant (Sensei) Screen.
/// Renders differently depending on who sent the message.
class AIChatBubble extends StatelessWidget {
  final String message;
  final String sender; // "user" or "AI"
  final bool isError;

  const AIChatBubble({
    super.key,
    required this.message,
    required this.sender,
    this.isError = false,
  });

  bool get _isUser => sender == 'user';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final Color bubbleColor = isError
        ? AppTheme.error.withValues(alpha: 0.12)
        : _isUser
        ? AppTheme.onPrimary
        : AppTheme.surface;

    final Color textColor = isError
        ? AppTheme.error
        : _isUser
        ? Colors.white
        : AppTheme.onSurface;

    return Align(
      alignment: _isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: Appspacing.xs),
        padding: const EdgeInsets.symmetric(
          horizontal: Appspacing.md,
          vertical: Appspacing.sm,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(_isUser ? 16 : 4),
            bottomRight: Radius.circular(_isUser ? 4 : 16),
          ),
          border: !_isUser && !isError
              ? Border.all(color: const Color(0xFFECECEC))
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isError)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 14, color: textColor),
                  const SizedBox(width: Appspacing.xs),
                  Text(
                    'Sensei couldn\'t respond',
                    style: textTheme.labelSmall?.copyWith(color: textColor),
                  ),
                ],
              ),
            if (isError) const SizedBox(height: Appspacing.xs / 2),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
