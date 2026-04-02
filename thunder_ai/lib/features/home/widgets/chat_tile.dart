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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.card : AppColorsLight.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AI Avatar with gradient
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              AppColorsDark.primary,
                              AppColorsDark.accent,
                            ]
                          : [
                              AppColorsLight.primary,
                              AppColorsLight.accent,
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (isDark
                                ? AppColorsDark.primary
                                : AppColorsLight.primary)
                            .withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                
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
                          const SizedBox(width: 12),
                          
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
                      const SizedBox(height: 6),
                      
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
        ),
      ),
    );
  }
}
