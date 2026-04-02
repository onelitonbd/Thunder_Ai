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
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          // AI Avatar with gradient
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColorsDark.primary, AppColorsDark.accent]
                    : [AppColorsLight.primary, AppColorsLight.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? AppColorsDark.primary : AppColorsLight.primary)
                      .withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Colors.white,
              size: 22,
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
