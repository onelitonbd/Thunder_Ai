import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: AppColorsLight.primary,
      secondary: AppColorsLight.primary,
      surface: AppColorsLight.surface,
      error: Color(0xFFE53935),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColorsLight.textPrimary,
    ),
    
    // Scaffold
    scaffoldBackgroundColor: AppColorsLight.background,
    
    // App Bar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsLight.surface,
      foregroundColor: AppColorsLight.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColorsLight.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      iconTheme: IconThemeData(
        color: AppColorsLight.iconPrimary,
        size: 24,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    
    // Bottom Navigation Bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColorsLight.surface,
      selectedItemColor: AppColorsLight.iconActive,
      unselectedItemColor: AppColorsLight.iconPrimary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: AppTextStyles.navLabel,
      unselectedLabelStyle: AppTextStyles.navLabel,
    ),
    
    // Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColorsLight.fab,
      foregroundColor: AppColorsLight.fabIcon,
      elevation: 4,
    ),
    
    // Card
    cardTheme: CardTheme(
      color: AppColorsLight.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColorsLight.divider,
      thickness: 0.5,
      space: 0,
    ),
    
    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColorsLight.inputBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(
          color: AppColorsLight.primary,
          width: 1,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      hintStyle: AppTextStyles.inputHint.copyWith(
        color: AppColorsLight.textSecondary,
      ),
    ),
    
    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColorsLight.iconPrimary,
      size: 24,
    ),
    
    // Text Theme
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.appBarTitle,
      titleLarge: AppTextStyles.chatTitle,
      titleMedium: AppTextStyles.chatSubtitle,
      bodyLarge: AppTextStyles.messageText,
      bodyMedium: AppTextStyles.inputText,
      labelSmall: AppTextStyles.messageTime,
    ).apply(
      bodyColor: AppColorsLight.textPrimary,
      displayColor: AppColorsLight.textPrimary,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: AppColorsDark.primary,
      secondary: AppColorsDark.primary,
      surface: AppColorsDark.surface,
      error: Color(0xFFEF5350),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColorsDark.textPrimary,
    ),
    
    // Scaffold
    scaffoldBackgroundColor: AppColorsDark.background,
    
    // App Bar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsDark.surface,
      foregroundColor: AppColorsDark.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColorsDark.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      iconTheme: IconThemeData(
        color: AppColorsDark.iconPrimary,
        size: 24,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    
    // Bottom Navigation Bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColorsDark.surface,
      selectedItemColor: AppColorsDark.iconActive,
      unselectedItemColor: AppColorsDark.iconPrimary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: AppTextStyles.navLabel,
      unselectedLabelStyle: AppTextStyles.navLabel,
    ),
    
    // Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColorsDark.fab,
      foregroundColor: AppColorsDark.fabIcon,
      elevation: 4,
    ),
    
    // Card
    cardTheme: CardTheme(
      color: AppColorsDark.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColorsDark.divider,
      thickness: 0.5,
      space: 0,
    ),
    
    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColorsDark.inputBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(
          color: AppColorsDark.primary,
          width: 1,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      hintStyle: AppTextStyles.inputHint.copyWith(
        color: AppColorsDark.textSecondary,
      ),
    ),
    
    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColorsDark.iconPrimary,
      size: 24,
    ),
    
    // Text Theme
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.appBarTitle,
      titleLarge: AppTextStyles.chatTitle,
      titleMedium: AppTextStyles.chatSubtitle,
      bodyLarge: AppTextStyles.messageText,
      bodyMedium: AppTextStyles.inputText,
      labelSmall: AppTextStyles.messageTime,
    ).apply(
      bodyColor: AppColorsDark.textPrimary,
      displayColor: AppColorsDark.textPrimary,
    ),
  );
}
