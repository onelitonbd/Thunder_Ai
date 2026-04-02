import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_service.dart';
import '../models/chat.dart';
import '../models/grouped_chats.dart';
import '../models/message.dart';
import '../core/utils/time_grouping_util.dart';

// Firestore service provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Current user ID provider (temporary - will be replaced with Firebase Auth)
final currentUserIdProvider = StateProvider<String>((ref) {
  return 'demo_user'; // Placeholder until we implement auth
});

// Stream of all user chats
final userChatsProvider = StreamProvider<List<Chat>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUserChats(userId);
});

// Grouped chats provider (groups chats by time)
final groupedChatsProvider = Provider<List<GroupedChats>>((ref) {
  final chatsAsync = ref.watch(userChatsProvider);
  
  return chatsAsync.when(
    data: (chats) => TimeGroupingUtil.groupChatsByTime(chats),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Stream of messages for a specific chat
final chatMessagesProvider = StreamProvider.family<List<Message>, String>((ref, chatId) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getChatMessages(chatId);
});

// Selected chat ID provider
final selectedChatIdProvider = StateProvider<String?>((ref) => null);

// Current chat provider
final currentChatProvider = Provider<Chat?>((ref) {
  final selectedChatId = ref.watch(selectedChatIdProvider);
  if (selectedChatId == null) return null;

  final chatsAsync = ref.watch(userChatsProvider);
  return chatsAsync.whenData((chats) {
    try {
      return chats.firstWhere((chat) => chat.id == selectedChatId);
    } catch (e) {
      return null;
    }
  }).value;
});
