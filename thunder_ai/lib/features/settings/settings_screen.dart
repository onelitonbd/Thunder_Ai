import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Theme'),
            subtitle: Text(
              themeMode == ThemeMode.system
                  ? 'System'
                  : themeMode == ThemeMode.dark
                      ? 'Dark'
                      : 'Light',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showThemeDialog(context, ref);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('About'),
            subtitle: const Text('Thunder Ai v1.0.0'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Thunder Ai',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.bolt, size: 48),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.read(themeModeProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: currentTheme,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).state = value!;
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: currentTheme,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).state = value!;
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: currentTheme,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).state = value!;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
