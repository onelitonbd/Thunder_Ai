import 'package:flutter/material.dart';
import '../../../models/chat.dart';
import '../../../core/utils/date_format_util.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ChatTile extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const ChatTile({
    super.key,
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeText = DateFormatUtil.formatChatListTime(chat.updatedAt);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColorsDark.primary.withOpacity(0.2)
                    : AppColorsLight.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Icon(
                Icons.bolt,
                color: isDark ? AppColorsDark.primary : AppColorsLight.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            
            // Chat Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Chat Title
                      Expanded(
                        child: Text(
                          chat.title,
                          style: AppTextStyles.chatTitle.copyWith(
                            color: isDark
                                ? AppColorsDark.textPrimary
                                : AppColorsLight.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      
                      // Time
                      Text(
                        timeText,
                        style: AppTextStyles.chatTime.copyWith(
                          color: isDark
                              ? AppColorsDark.timestamp
                              : AppColorsLight.timestamp,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  
                  // Last Message Preview
                  Text(
                    chat.lastMessage,
                    style: AppTextStyles.chatSubtitle.copyWith(
                      color: isDark
                          ? AppColorsDark.textSecondary
                          : AppColorsLight.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
