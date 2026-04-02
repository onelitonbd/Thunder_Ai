import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

class EmptyChatsState extends StatelessWidget {
  const EmptyChatsState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'No chats yet',
            style: AppTextStyles.chatTitle.copyWith(
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to start a new chat',
            style: AppTextStyles.chatSubtitle.copyWith(
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
