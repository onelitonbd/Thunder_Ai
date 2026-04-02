import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class DateSeparator extends StatelessWidget {
  final String dateText;

  const DateSeparator({
    super.key,
    required this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? AppColorsDark.surfaceVariant.withOpacity(0.5)
              : AppColorsLight.surfaceVariant.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          dateText,
          style: AppTextStyles.messageTime.copyWith(
            color: isDark
                ? AppColorsDark.textSecondary
                : AppColorsLight.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
