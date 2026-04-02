import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/chat_provider.dart';
import '../../core/utils/time_grouping_util.dart';
import '../../core/theme/app_colors.dart';
import '../chat/chat_screen.dart';
import 'widgets/main_scaffold.dart';
import 'widgets/chat_tile.dart';
import 'widgets/time_group_header.dart';
import 'widgets/empty_chats_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch real Firebase data with error handling
    final chatsAsync = ref.watch(userChatsProvider);

    return MainScaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).brightness == Brightness.dark
                  ? AppColorsDark.primary
                  : AppColorsLight.primary,
              Theme.of(context).brightness == Brightness.dark
                  ? AppColorsDark.accent
                  : AppColorsLight.accent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (Theme.of(context).brightness == Brightness.dark
                      ? AppColorsDark.primary
                      : AppColorsLight.primary)
                  .withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              // Create new chat with error handling
              try {
                final firestoreService = ref.read(firestoreServiceProvider);
                final userId = ref.read(currentUserIdProvider);
                
                final chatId = await firestoreService.createChat(
                  userId: userId,
                  title: 'New Chat',
                  lastMessage: '',
                );
                
                // Navigate to new chat
                if (context.mounted) {
                  ref.read(selectedChatIdProvider.notifier).state = chatId;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(chatId: chatId),
                    ),
                  );
                }
              } catch (e) {
                debugPrint('Error creating chat: $e');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thunder Ai'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Search - Coming soon!')),
                );
              },
            ),
          ],
        ),
        body: chatsAsync.when(
          data: (chats) {
            if (chats.isEmpty) {
              return const EmptyChatsState();
            }
            
            final groupedChats = TimeGroupingUtil.groupChatsByTime(chats);
            
            return RefreshIndicator(
              onRefresh: () async {
                // Refresh is automatic with Firestore streams
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView.builder(
                itemCount: _calculateItemCount(groupedChats),
                itemBuilder: (context, index) {
                  return _buildListItem(context, ref, groupedChats, index);
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(userChatsProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _calculateItemCount(groupedChats) {
    int count = 0;
    for (final group in groupedChats) {
      count++; // Header
      count += group.chats.length as int; // Chats
    }
    return count;
  }

  Widget _buildListItem(
    BuildContext context,
    WidgetRef ref,
    groupedChats,
    int index,
  ) {
    int currentIndex = 0;

    for (final group in groupedChats) {
      // Check if this is the header
      if (currentIndex == index) {
        return TimeGroupHeader(label: group.label);
      }
      currentIndex++;

      // Check if this is one of the chats in this group
      for (final chat in group.chats) {
        if (currentIndex == index) {
          return ChatTile(
            chat: chat,
            onTap: () {
              // Navigate to chat screen
              ref.read(selectedChatIdProvider.notifier).state = chat.id;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatScreen(chatId: chat.id),
                ),
              );
            },
          );
        }
        currentIndex++;
      }
    }

    return const SizedBox.shrink();
  }
}
