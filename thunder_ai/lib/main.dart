import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'features/home/home_screen.dart';
import 'features/home/widgets/main_scaffold.dart';
import 'features/profile/profile_screen.dart';
import 'features/settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('⚠️ Firebase initialization error: $e');
    // App will continue without Firebase for now
  }
  
  runApp(const ProviderScope(child: ThunderAiApp()));
}

class ThunderAiApp extends ConsumerWidget {
  const ThunderAiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Thunder Ai',
      debugShowCheckedModeBanner: false,
      
      // Telegram-inspired themes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      
      home: const MainNavigator(),
    );
  }
}

// Main navigator that switches between screens based on bottom nav
class MainNavigator extends ConsumerWidget {
  const MainNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    // Switch between screens based on navigation index
    switch (currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const ProfileScreen();
      case 2:
        return const SettingsScreen();
      default:
        return const HomeScreen();
    }
  }
}
