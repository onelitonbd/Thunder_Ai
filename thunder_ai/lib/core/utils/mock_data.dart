import '../../models/chat.dart';
import '../../models/message.dart';

class MockData {
  /// Generate mock chats for testing
  static List<Chat> getMockChats() {
    final now = DateTime.now();
    
    return [
      // Today
      Chat(
        id: '1',
        userId: 'demo_user',
        title: 'How to build a Flutter app?',
        lastMessage: 'Great! Let me help you with that...',
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      Chat(
        id: '2',
        userId: 'demo_user',
        title: 'Explain quantum computing',
        lastMessage: 'Quantum computing uses quantum bits...',
        updatedAt: now.subtract(const Duration(hours: 5)),
      ),
      
      // Yesterday
      Chat(
        id: '3',
        userId: 'demo_user',
        title: 'Best practices for REST APIs',
        lastMessage: 'Here are the key principles...',
        updatedAt: now.subtract(const Duration(days: 1, hours: 3)),
      ),
      Chat(
        id: '4',
        userId: 'demo_user',
        title: 'Recipe for chocolate cake',
        lastMessage: 'You will need flour, sugar, cocoa...',
        updatedAt: now.subtract(const Duration(days: 1, hours: 8)),
      ),
      
      // Last 7 Days
      Chat(
        id: '5',
        userId: 'demo_user',
        title: 'Machine learning basics',
        lastMessage: 'Machine learning is a subset of AI...',
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      Chat(
        id: '6',
        userId: 'demo_user',
        title: 'Travel tips for Japan',
        lastMessage: 'Japan is an amazing destination...',
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      
      // Previous 30 Days
      Chat(
        id: '7',
        userId: 'demo_user',
        title: 'Understanding blockchain',
        lastMessage: 'Blockchain is a distributed ledger...',
        updatedAt: now.subtract(const Duration(days: 15)),
      ),
      Chat(
        id: '8',
        userId: 'demo_user',
        title: 'Healthy meal planning',
        lastMessage: 'Start with a balanced diet...',
        updatedAt: now.subtract(const Duration(days: 25)),
      ),
      
      // Older
      Chat(
        id: '9',
        userId: 'demo_user',
        title: 'History of the Roman Empire',
        lastMessage: 'The Roman Empire was one of...',
        updatedAt: now.subtract(const Duration(days: 45)),
      ),
      Chat(
        id: '10',
        userId: 'demo_user',
        title: 'Photography composition tips',
        lastMessage: 'The rule of thirds is essential...',
        updatedAt: now.subtract(const Duration(days: 90)),
      ),
    ];
  }

  /// Generate mock messages for a chat
  static List<Message> getMockMessages(String chatId) {
    final now = DateTime.now();
    
    return [
      Message(
        id: '1',
        sender: 'user',
        text: 'Hello! Can you help me with Flutter?',
        timestamp: now.subtract(const Duration(minutes: 30)),
        isMarkdown: false,
      ),
      Message(
        id: '2',
        sender: 'ai',
        text: 'Of course! I\'d be happy to help you with Flutter. Flutter is Google\'s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.\n\nWhat specific aspect of Flutter would you like to learn about?',
        timestamp: now.subtract(const Duration(minutes: 29)),
        isMarkdown: true,
      ),
      Message(
        id: '3',
        sender: 'user',
        text: 'How do I create a simple button?',
        timestamp: now.subtract(const Duration(minutes: 25)),
        isMarkdown: false,
      ),
      Message(
        id: '4',
        sender: 'ai',
        text: 'Here\'s how to create a simple button in Flutter:\n\n```dart\nElevatedButton(\n  onPressed: () {\n    print(\'Button pressed!\');\n  },\n  child: Text(\'Click Me\'),\n)\n```\n\nYou can also use:\n- **TextButton** for flat buttons\n- **OutlinedButton** for outlined buttons\n- **IconButton** for icon-only buttons',
        timestamp: now.subtract(const Duration(minutes: 24)),
        isMarkdown: true,
      ),
      Message(
        id: '5',
        sender: 'user',
        text: 'Perfect! Thank you!',
        timestamp: now.subtract(const Duration(minutes: 20)),
        isMarkdown: false,
      ),
      Message(
        id: '6',
        sender: 'ai',
        text: 'You\'re welcome! Feel free to ask if you have more questions about Flutter. Happy coding! 🚀',
        timestamp: now.subtract(const Duration(minutes: 19)),
        isMarkdown: true,
      ),
    ];
  }
}
