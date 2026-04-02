import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../models/message.dart';
import '../../../core/utils/date_format_util.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUser = message.sender == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isUser ? 64 : 8,
          right: isUser ? 8 : 64,
          top: 4,
          bottom: 4,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isUser
              ? (isDark ? AppColorsDark.userBubble : AppColorsLight.userBubble)
              : (isDark ? AppColorsDark.aiBubble : AppColorsLight.aiBubble),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message content
            if (message.isMarkdown && !isUser)
              MarkdownBody(
                data: message.text,
                styleSheet: MarkdownStyleSheet(
                  p: AppTextStyles.messageText.copyWith(
                    color: isDark
                        ? AppColorsDark.aiBubbleText
                        : AppColorsLight.aiBubbleText,
                  ),
                  code: AppTextStyles.messageText.copyWith(
                    fontFamily: 'monospace',
                    backgroundColor: isDark
                        ? Colors.black26
                        : Colors.black12,
                    color: isDark
                        ? AppColorsDark.aiBubbleText
                        : AppColorsLight.aiBubbleText,
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: isDark ? Colors.black26 : Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  strong: AppTextStyles.messageText.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColorsDark.aiBubbleText
                        : AppColorsLight.aiBubbleText,
                  ),
                ),
              )
            else
              Text(
                message.text,
                style: AppTextStyles.messageText.copyWith(
                  color: isUser
                      ? (isDark
                          ? AppColorsDark.userBubbleText
                          : AppColorsLight.userBubbleText)
                      : (isDark
                          ? AppColorsDark.aiBubbleText
                          : AppColorsLight.aiBubbleText),
                ),
              ),
            const SizedBox(height: 4),
            
            // Timestamp
            Text(
              DateFormatUtil.formatMessageTime(message.timestamp),
              style: AppTextStyles.messageTime.copyWith(
                color: isUser
                    ? (isDark
                        ? AppColorsDark.userBubbleText.withOpacity(0.7)
                        : AppColorsLight.userBubbleText.withOpacity(0.7))
                    : (isDark
                        ? AppColorsDark.timestamp
                        : AppColorsLight.timestamp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
