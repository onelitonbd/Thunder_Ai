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
          left: isUser ? 80 : 12,
          right: isUser ? 12 : 80,
          top: 6,
          bottom: 6,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isUser
              ? LinearGradient(
                  colors: isDark
                      ? [
                          AppColorsDark.userBubbleStart,
                          AppColorsDark.userBubbleEnd,
                        ]
                      : [
                          AppColorsLight.userBubbleStart,
                          AppColorsLight.userBubbleEnd,
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isUser
              ? null
              : (isDark ? AppColorsDark.aiBubble : AppColorsLight.aiBubble),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
