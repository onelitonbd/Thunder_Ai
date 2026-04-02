import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String sender; // "user" or "ai"
  final String text;
  final DateTime timestamp;
  final bool isMarkdown;

  Message({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.isMarkdown = false,
  });

  // Convert Message to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'isMarkdown': isMarkdown,
    };
  }

  // Create Message from Firestore document
  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      sender: data['sender'] ?? 'user',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isMarkdown: data['isMarkdown'] ?? false,
    );
  }

  // Create Message from Map (for local use)
  factory Message.fromMap(String id, Map<String, dynamic> data) {
    return Message(
      id: id,
      sender: data['sender'] ?? 'user',
      text: data['text'] ?? '',
      timestamp: data['timestamp'] is Timestamp
          ? (data['timestamp'] as Timestamp).toDate()
          : data['timestamp'] as DateTime,
      isMarkdown: data['isMarkdown'] ?? false,
    );
  }

  Message copyWith({
    String? id,
    String? sender,
    String? text,
    DateTime? timestamp,
    bool? isMarkdown,
  }) {
    return Message(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isMarkdown: isMarkdown ?? this.isMarkdown,
    );
  }
}
