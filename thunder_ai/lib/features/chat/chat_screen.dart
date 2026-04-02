import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/message.dart';
import '../../core/utils/mock_data.dart';
import '../../core/utils/date_format_util.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/gemini_provider.dart';
import '../../providers/chat_provider.dart';
import 'widgets/chat_app_bar.dart';
import 'widgets/message_bubble.dart';
import 'widgets/message_input_field.dart';
import 'widgets/date_separator.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;

  const ChatScreen({
    super.key,
    required this.chatId,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];
  bool _isLoadingMessages = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    // Try to load from Firebase first
    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      firestoreService.getChatMessages(widget.chatId).listen(
        (messages) {
          if (mounted) {
            setState(() {
              _messages = messages;
              _isLoadingMessages = false;
            });
            
            // Scroll to bottom after loading
            Future.delayed(const Duration(milliseconds: 100), () {
              _scrollToBottom();
            });
          }
        },
        onError: (error) {
          debugPrint('Error loading messages: $error');
          if (mounted) {
            setState(() {
              _messages = MockData.getMockMessages(widget.chatId);
              _isLoadingMessages = false;
            });
          }
        },
      );
    } catch (e) {
      debugPrint('Firebase error: $e');
      // Fallback to mock data if Firebase fails
      if (mounted) {
        setState(() {
          _messages = MockData.getMockMessages(widget.chatId);
          _isLoadingMessages = false;
        });
        
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollToBottom();
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSendMessage(String text) async {
    final firestoreService = ref.read(firestoreServiceProvider);
    
    try {
      // Save user message to Firebase
      await firestoreService.addMessage(
        chatId: widget.chatId,
        sender: 'user',
        text: text,
        isMarkdown: false,
      );

      // Scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom();
      });

      // Get AI response using Gemini
      final geminiService = ref.read(geminiServiceProvider);
      
      // Build conversation history (last 10 messages for context)
      final conversationHistory = _messages
          .skip(_messages.length > 10 ? _messages.length - 10 : 0)
          .map((m) => {
                'role': m.sender,
                'text': m.text,
              })
          .toList();
      
      // Generate AI response
      final aiResponseText = await geminiService.generateChatResponse(
        conversationHistory,
        text,
      );
      
      // Save AI message to Firebase
      await firestoreService.addMessage(
        chatId: widget.chatId,
        sender: 'ai',
        text: aiResponseText,
        isMarkdown: true,
      );
      
      // Update chat title if this is the first message
      if (_messages.length <= 2) {
        try {
          final title = await geminiService.generateChatTitle(text);
          await firestoreService.updateChatTitle(widget.chatId, title);
        } catch (e) {
          // Ignore title generation errors
        }
      }

      // Scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom();
      });
    } catch (e) {
      // Show error in chat
      await firestoreService.addMessage(
        chatId: widget.chatId,
        sender: 'ai',
        text: 'Sorry, I encountered an error: ${e.toString()}\n\nPlease check:\n1. Your Gemini API key in `app_config.dart`\n2. Your Firebase configuration\n3. Your internet connection',
        isMarkdown: true,
      );

      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const ChatAppBar(),
      backgroundColor: isDark
          ? AppColorsDark.chatBackground
          : AppColorsLight.chatBackground,
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: _isLoadingMessages
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? Center(
                        child: Text(
                          'No messages yet\nSend a message to start the conversation',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark
                                ? AppColorsDark.textSecondary
                                : AppColorsLight.textSecondary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 16,
                        ),
                        itemCount: _buildMessageListItemCount(),
                        itemBuilder: (context, index) {
                          return _buildMessageListItem(index);
                        },
                      ),
          ),
          
          // Message input
          MessageInputField(
            onSendMessage: _handleSendMessage,
          ),
        ],
      ),
    );
  }

  int _buildMessageListItemCount() {
    int count = 0;
    DateTime? lastDate;

    for (final message in _messages) {
      final messageDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );

      if (lastDate == null || !DateFormatUtil.isSameDay(lastDate, messageDate)) {
        count++; // Date separator
        lastDate = messageDate;
      }
      count++; // Message
    }

    return count;
  }

  Widget _buildMessageListItem(int index) {
    int currentIndex = 0;
    DateTime? lastDate;

    for (final message in _messages) {
      final messageDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );

      // Check if we need a date separator
      if (lastDate == null || !DateFormatUtil.isSameDay(lastDate, messageDate)) {
        if (currentIndex == index) {
          return DateSeparator(
            dateText: DateFormatUtil.formatMessageGroupDate(message.timestamp),
          );
        }
        currentIndex++;
        lastDate = messageDate;
      }

      // Check if this is the message
      if (currentIndex == index) {
        return MessageBubble(message: message);
      }
      currentIndex++;
    }

    return const SizedBox.shrink();
  }
}
