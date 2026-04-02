import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final String userId;
  final String title;
  final String lastMessage;
  final DateTime updatedAt;

  Chat({
    required this.id,
    required this.userId,
    required this.title,
    required this.lastMessage,
    required this.updatedAt,
  });

  // Convert Chat to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'lastMessage': lastMessage,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create Chat from Firestore document
  factory Chat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Chat(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? 'New Chat',
      lastMessage: data['lastMessage'] ?? '',
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Create Chat from Map (for local use)
  factory Chat.fromMap(String id, Map<String, dynamic> data) {
    return Chat(
      id: id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? 'New Chat',
      lastMessage: data['lastMessage'] ?? '',
      updatedAt: data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate()
          : data['updatedAt'] as DateTime,
    );
  }

  Chat copyWith({
    String? id,
    String? userId,
    String? title,
    String? lastMessage,
    DateTime? updatedAt,
  }) {
    return Chat(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
