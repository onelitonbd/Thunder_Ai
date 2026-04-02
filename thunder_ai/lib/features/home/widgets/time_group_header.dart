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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.timeGroupHeader.copyWith(
          color: isDark
              ? AppColorsDark.textTertiary
              : AppColorsLight.textTertiary,
        ),
      ),
    );
  }
}
