import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';
import '../core/constants/app_config.dart';

class GeminiService {
  GenerativeModel? _model;
  bool _isConfigured = false;
  
  GeminiService() {
    try {
      if (AppConfig.isGeminiConfigured) {
        _model = GenerativeModel(
          model: AppConfig.geminiModel,
          apiKey: AppConfig.geminiApiKey,
          generationConfig: GenerationConfig(
            temperature: AppConfig.temperature,
            maxOutputTokens: AppConfig.maxTokens,
          ),
        );
        _isConfigured = true;
        debugPrint('✅ Gemini AI configured successfully');
      } else {
        debugPrint('⚠️ Gemini API key not configured');
      }
    } catch (e) {
      debugPrint('❌ Gemini initialization error: $e');
    }
  }

  /// Generate a response from Gemini AI
  Future<String> generateResponse(String prompt) async {
    if (!_isConfigured || _model == null) {
      return 'Gemini AI is not configured. Please add your API key in lib/core/constants/app_config.dart';
    }
    
    try {
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      
      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Empty response from Gemini');
      }
      
      return response.text!;
    } catch (e) {
      debugPrint('Gemini error: $e');
      return 'Error generating response: ${e.toString()}\n\nPlease check your API key and internet connection.';
    }
  }

  /// Generate a streaming response from Gemini AI
  Stream<String> generateStreamResponse(String prompt) async* {
    if (!_isConfigured || _model == null) {
      yield 'Gemini AI is not configured.';
      return;
    }
    
    try {
      final content = [Content.text(prompt)];
      final response = _model!.generateContentStream(content);
      
      await for (final chunk in response) {
        if (chunk.text != null && chunk.text!.isNotEmpty) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      debugPrint('Gemini streaming error: $e');
      yield 'Error: ${e.toString()}';
    }
  }

  /// Generate a chat response with conversation history
  Future<String> generateChatResponse(
    List<Map<String, String>> conversationHistory,
    String newMessage,
  ) async {
    if (!_isConfigured || _model == null) {
      return 'Gemini AI is not configured. Please add your API key.';
    }
    
    try {
      // Build conversation context
      final contextPrompt = StringBuffer();
      
      for (final message in conversationHistory) {
        final role = message['role'] == 'user' ? 'User' : 'Assistant';
        final text = message['text'];
        contextPrompt.writeln('$role: $text');
      }
      
      contextPrompt.writeln('User: $newMessage');
      contextPrompt.writeln('Assistant:');
      
      return await generateResponse(contextPrompt.toString());
    } catch (e) {
      debugPrint('Chat response error: $e');
      return 'Error: ${e.toString()}';
    }
  }

  /// Generate a title for a chat based on the first message
  Future<String> generateChatTitle(String firstMessage) async {
    if (!_isConfigured || _model == null) {
      // Fallback to simple title generation
      return firstMessage.split('\n').first.substring(
            0,
            firstMessage.length > 50 ? 50 : firstMessage.length,
          );
    }
    
    try {
      final prompt = '''
Generate a short, concise title (maximum 6 words) for a chat conversation that starts with this message:

"$firstMessage"

Return ONLY the title, nothing else. No quotes, no punctuation at the end.
''';
      
      final response = await generateResponse(prompt);
      return response.trim();
    } catch (e) {
      debugPrint('Title generation error: $e');
      // Fallback to simple title generation
      return firstMessage.split('\n').first.substring(
            0,
            firstMessage.length > 50 ? 50 : firstMessage.length,
          );
    }
  }
}
