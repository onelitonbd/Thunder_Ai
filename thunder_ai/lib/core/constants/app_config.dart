class AppConfig {
  // Gemini API Configuration
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
  static const String geminiModel = 'gemini-1.5-flash-latest';
  
  // Firebase Configuration
  // Note: Firebase config is in firebase_options.dart
  
  // App Configuration
  static const String appName = 'Thunder Ai';
  static const String appVersion = '1.0.0';
  
  // Gemini Settings
  static const double temperature = 0.7;
  static const int maxTokens = 2048;
  
  // Validation
  static bool get isGeminiConfigured => geminiApiKey != 'YOUR_GEMINI_API_KEY_HERE';
}
