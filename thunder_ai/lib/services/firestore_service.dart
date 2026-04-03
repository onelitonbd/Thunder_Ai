import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat.dart';
import '../models/message.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references - NEW STRUCTURE
  CollectionReference get _usersCollection => _firestore.collection('users');

  // Get user's chats subcollection
  CollectionReference _userChatsCollection(String userId) {
    return _usersCollection.doc(userId).collection('chats');
  }

  // Get user's settings document
  DocumentReference _userSettingsDoc(String userId) {
    return _usersCollection.doc(userId).collection('settings').doc('preferences');
  }

  // Get user's profile document
  DocumentReference _userProfileDoc(String userId) {
    return _usersCollection.doc(userId);
  }

  // ==================== USER OPERATIONS ====================

  /// Create or update user profile
  Future<void> createUserProfile({
    required String userId,
    required String email,
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      await _userProfileDoc(userId).set({
        'email': email,
        'displayName': displayName ?? email.split('@')[0],
        'photoUrl': photoUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  /// Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _userProfileDoc(userId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _userProfileDoc(userId).update(data);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  // ==================== SETTINGS OPERATIONS ====================

  /// Save user settings
  Future<void> saveUserSettings(String userId, Map<String, dynamic> settings) async {
    try {
      settings['updatedAt'] = FieldValue.serverTimestamp();
      await _userSettingsDoc(userId).set(settings, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save settings: $e');
    }
  }

  /// Get user settings
  Future<Map<String, dynamic>?> getUserSettings(String userId) async {
    try {
      final doc = await _userSettingsDoc(userId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get settings: $e');
    }
  }

  // ==================== CHAT OPERATIONS ====================

  /// Create a new chat for a user
  Future<String> createChat({
    required String userId,
    required String title,
    String lastMessage = '',
  }) async {
    try {
      final docRef = await _userChatsCollection(userId).add({
        'userId': userId,
        'title': title,
        'lastMessage': lastMessage,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create chat: $e');
    }
  }

  /// Get all chats for a user (ordered by most recent)
  Stream<List<Chat>> getUserChats(String userId) {
    return _userChatsCollection(userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Chat.fromFirestore(doc)).toList();
    });
  }

  /// Get a single chat by ID
  Future<Chat?> getChatById(String userId, String chatId) async {
    try {
      final doc = await _userChatsCollection(userId).doc(chatId).get();
      if (doc.exists) {
        return Chat.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get chat: $e');
    }
  }

  /// Update chat title
  Future<void> updateChatTitle(String userId, String chatId, String newTitle) async {
    try {
      await _userChatsCollection(userId).doc(chatId).update({
        'title': newTitle,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update chat title: $e');
    }
  }

  /// Update last message and timestamp
  Future<void> updateLastMessage(String userId, String chatId, String lastMessage) async {
    try {
      await _userChatsCollection(userId).doc(chatId).update({
        'lastMessage': lastMessage,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update last message: $e');
    }
  }

  /// Delete a chat and all its messages
  Future<void> deleteChat(String userId, String chatId) async {
    try {
      // Delete all messages in the chat
      final messagesSnapshot = await _userChatsCollection(userId)
          .doc(chatId)
          .collection('messages')
          .get();

      for (final doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete the chat document
      await _userChatsCollection(userId).doc(chatId).delete();
    } catch (e) {
      throw Exception('Failed to delete chat: $e');
    }
  }

  // ==================== MESSAGE OPERATIONS ====================

  /// Add a message to a chat
  Future<String> addMessage({
    required String userId,
    required String chatId,
    required String sender,
    required String text,
    bool isMarkdown = false,
  }) async {
    try {
      final docRef = await _userChatsCollection(userId)
          .doc(chatId)
          .collection('messages')
          .add({
        'sender': sender,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
        'isMarkdown': isMarkdown,
      });

      // Update the chat's last message
      await updateLastMessage(userId, chatId, text);

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add message: $e');
    }
  }

  /// Get all messages for a chat (ordered by timestamp)
  Stream<List<Message>> getChatMessages(String userId, String chatId) {
    return _userChatsCollection(userId)
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList();
    });
  }

  /// Delete a specific message
  Future<void> deleteMessage(String userId, String chatId, String messageId) async {
    try {
      await _userChatsCollection(userId)
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

  /// Delete all user data (for account deletion)
  Future<void> deleteUserData(String userId) async {
    try {
      // Delete all chats and their messages
      final chatsSnapshot = await _userChatsCollection(userId).get();
      for (final chatDoc in chatsSnapshot.docs) {
        // Delete messages
        final messagesSnapshot = await chatDoc.reference.collection('messages').get();
        for (final messageDoc in messagesSnapshot.docs) {
          await messageDoc.reference.delete();
        }
        // Delete chat
        await chatDoc.reference.delete();
      }

      // Delete settings
      await _userSettingsDoc(userId).delete();

      // Delete user profile
      await _userProfileDoc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user data: $e');
    }
  }
}
