import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColorsDark.background,
                    AppColorsDark.primary.withOpacity(0.2),
                    AppColorsDark.background,
                  ]
                : [
                    AppColorsLight.background,
                    AppColorsLight.primary.withOpacity(0.1),
                    AppColorsLight.background,
                  ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // App Icon with Gradient
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [AppColorsDark.primary, AppColorsDark.accent]
                          : [AppColorsLight.primary, AppColorsLight.accent],
                    ),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: (isDark
                                ? AppColorsDark.primary
                                : AppColorsLight.primary)
                            .withOpacity(0.4),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // App Name
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: isDark
                        ? [AppColorsDark.primary, AppColorsDark.accent]
                        : [AppColorsLight.primary, AppColorsLight.accent],
                  ).createShader(bounds),
                  child: Text(
                    'Thunder Ai',
                    style: AppTextStyles.largeTitle.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Tagline
                Text(
                  'Your AI Assistant',
                  style: AppTextStyles.chatSubtitle.copyWith(
                    fontSize: 18,
                    color: isDark
                        ? AppColorsDark.textSecondary
                        : AppColorsLight.textSecondary,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Description
                Text(
                  'Powered by Google Gemini AI\nReal-time conversations, smart responses',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.chatSubtitle.copyWith(
                    color: isDark
                        ? AppColorsDark.textTertiary
                        : AppColorsLight.textTertiary,
                  ),
                ),
                
                const Spacer(),
                
                // Features
                _buildFeature(
                  context,
                  Icons.chat_bubble_rounded,
                  'Smart Conversations',
                  'Chat with advanced AI',
                ),
                const SizedBox(height: 16),
                _buildFeature(
                  context,
                  Icons.cloud_sync_rounded,
                  'Cloud Sync',
                  'Access chats anywhere',
                ),
                const SizedBox(height: 16),
                _buildFeature(
                  context,
                  Icons.security_rounded,
                  'Secure & Private',
                  'Your data is protected',
                ),
                
                const Spacer(),
                
                // Get Started Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [AppColorsDark.primary, AppColorsDark.accent]
                          : [AppColorsLight.primary, AppColorsLight.accent],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (isDark
                                ? AppColorsDark.primary
                                : AppColorsLight.primary)
                            .withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Center(
                        child: Text(
                          'Get Started',
                          style: AppTextStyles.chatTitle.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      AppColorsDark.primary.withOpacity(0.2),
                      AppColorsDark.accent.withOpacity(0.2),
                    ]
                  : [
                      AppColorsLight.primary.withOpacity(0.1),
                      AppColorsLight.accent.withOpacity(0.1),
                    ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isDark ? AppColorsDark.primary : AppColorsLight.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.chatTitle.copyWith(
                  color: isDark
                      ? AppColorsDark.textPrimary
                      : AppColorsLight.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyles.chatSubtitle.copyWith(
                  fontSize: 13,
                  color: isDark
                      ? AppColorsDark.textSecondary
                      : AppColorsLight.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
