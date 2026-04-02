import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/constants/app_config.dart';

class GeminiService {
  late final GenerativeModel _model;
  
  GeminiService() {
    if (!AppConfig.isGeminiConfigured) {
      throw Exception(
        'Gemini API key not configured. Please add your API key in lib/core/constants/app_config.dart',
      );
    }
    
    _model = GenerativeModel(
      model: AppConfig.geminiModel,
      apiKey: AppConfig.geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: AppConfig.temperature,
        maxOutputTokens: AppConfig.maxTokens,
      ),
    );
  }

  /// Generate a response from Gemini AI
  Future<String> generateResponse(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Empty response from Gemini');
      }
      
      return response.text!;
    } catch (e) {
      throw Exception('Failed to generate response: $e');
    }
  }

  /// Generate a streaming response from Gemini AI
  Stream<String> generateStreamResponse(String prompt) async* {
    try {
      final content = [Content.text(prompt)];
      final response = _model.generateContentStream(content);
      
      await for (final chunk in response) {
        if (chunk.text != null && chunk.text!.isNotEmpty) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      throw Exception('Failed to generate streaming response: $e');
    }
  }

  /// Generate a chat response with conversation history
  Future<String> generateChatResponse(
    List<Map<String, String>> conversationHistory,
    String newMessage,
  ) async {
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
      throw Exception('Failed to generate chat response: $e');
    }
  }

  /// Generate a title for a chat based on the first message
  Future<String> generateChatTitle(String firstMessage) async {
    try {
      final prompt = '''
Generate a short, concise title (maximum 6 words) for a chat conversation that starts with this message:

"$firstMessage"

Return ONLY the title, nothing else. No quotes, no punctuation at the end.
''';
      
      final response = await generateResponse(prompt);
      return response.trim();
    } catch (e) {
      // Fallback to simple title generation
      return firstMessage.split('\n').first.substring(
            0,
            firstMessage.length > 50 ? 50 : firstMessage.length,
          );
    }
  }
}
