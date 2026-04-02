import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat.dart';
import '../models/message.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _chatsCollection => _firestore.collection('chats');

  // ==================== CHAT OPERATIONS ====================

  /// Create a new chat
  Future<String> createChat({
    required String userId,
    required String title,
    String lastMessage = '',
  }) async {
    try {
      final docRef = await _chatsCollection.add({
        'userId': userId,
        'title': title,
        'lastMessage': lastMessage,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create chat: $e');
    }
  }

  /// Get all chats for a user (ordered by most recent)
  Stream<List<Chat>> getUserChats(String userId) {
    return _chatsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Chat.fromFirestore(doc)).toList();
    });
  }

  /// Get a single chat by ID
  Future<Chat?> getChatById(String chatId) async {
    try {
      final doc = await _chatsCollection.doc(chatId).get();
      if (doc.exists) {
        return Chat.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get chat: $e');
    }
  }

  /// Update chat title
  Future<void> updateChatTitle(String chatId, String newTitle) async {
    try {
      await _chatsCollection.doc(chatId).update({
        'title': newTitle,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update chat title: $e');
    }
  }

  /// Update last message and timestamp
  Future<void> updateLastMessage(String chatId, String lastMessage) async {
    try {
      await _chatsCollection.doc(chatId).update({
        'lastMessage': lastMessage,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update last message: $e');
    }
  }

  /// Delete a chat and all its messages
  Future<void> deleteChat(String chatId) async {
    try {
      // Delete all messages in the chat
      final messagesSnapshot = await _chatsCollection
          .doc(chatId)
          .collection('messages')
          .get();

      for (final doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete the chat document
      await _chatsCollection.doc(chatId).delete();
    } catch (e) {
      throw Exception('Failed to delete chat: $e');
    }
  }

  // ==================== MESSAGE OPERATIONS ====================

  /// Add a message to a chat
  Future<String> addMessage({
    required String chatId,
    required String sender,
    required String text,
    bool isMarkdown = false,
  }) async {
    try {
      final docRef = await _chatsCollection
          .doc(chatId)
          .collection('messages')
          .add({
        'sender': sender,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
        'isMarkdown': isMarkdown,
      });

      // Update the chat's last message
      await updateLastMessage(chatId, text);

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add message: $e');
    }
  }

  /// Get all messages for a chat (ordered by timestamp)
  Stream<List<Message>> getChatMessages(String chatId) {
    return _chatsCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList();
    });
  }

  /// Delete a specific message
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await _chatsCollection
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Generate a chat title from the first user message
  String generateChatTitle(String firstMessage) {
    // Take first 50 characters or until first newline
    final title = firstMessage.split('\n').first;
    if (title.length > 50) {
      return '${title.substring(0, 47)}...';
    }
    return title;
  }
}
