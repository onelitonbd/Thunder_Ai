import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onMenuPressed;

  const ChatAppBar({
    super.key,
    this.onBackPressed,
    this.onMenuPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          // AI Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColorsDark.primary.withOpacity(0.2)
                  : AppColorsLight.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bolt,
              color: isDark ? AppColorsDark.primary : AppColorsLight.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Thunder Ai',
                  style: AppTextStyles.appBarTitle.copyWith(
                    fontSize: 16,
                    color: isDark
                        ? AppColorsDark.textPrimary
                        : AppColorsLight.textPrimary,
                  ),
                ),
                Text(
                  'bot',
                  style: AppTextStyles.botSubtitle.copyWith(
                    color: isDark
                        ? AppColorsDark.textSecondary
                        : AppColorsLight.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: onMenuPressed ??
              () {
                // TODO: Show chat menu
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat menu - Coming soon!')),
                );
              },
        ),
      ],
    );
  }
}
