import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Theme mode provider
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// Helper to check if dark mode is active
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  
  if (themeMode == ThemeMode.system) {
    // This will be determined by the system
    return false; // Default, will be overridden by system
  }
  
  return themeMode == ThemeMode.dark;
});
