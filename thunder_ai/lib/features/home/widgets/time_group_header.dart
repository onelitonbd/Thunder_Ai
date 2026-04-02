import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TimeGroupHeader extends StatelessWidget {
  final String label;

  const TimeGroupHeader({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isDark
          ? AppColorsDark.backgroundSecondary
          : AppColorsLight.backgroundSecondary,
      child: Text(
        label,
        style: AppTextStyles.timeGroupHeader.copyWith(
          color: isDark
              ? AppColorsDark.textSecondary
              : AppColorsLight.textSecondary,
        ),
      ),
    );
  }
}
