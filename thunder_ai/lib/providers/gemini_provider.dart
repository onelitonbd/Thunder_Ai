import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/gemini_service.dart';

// Gemini service provider
final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

// Loading state for AI responses
final aiLoadingProvider = StateProvider<bool>((ref) => false);
