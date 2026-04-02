import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class MessageInputField extends StatefulWidget {
  final Function(String) onSendMessage;

  const MessageInputField({
    super.key,
    required this.onSendMessage,
  });

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surface : AppColorsLight.surface,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment button
            IconButton(
              icon: Icon(
                Icons.attach_file,
                color: isDark
                    ? AppColorsDark.iconPrimary
                    : AppColorsLight.iconPrimary,
              ),
              onPressed: () {
                // TODO: Implement attachment
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Attachments - Coming soon!')),
                );
              },
            ),
            
            // Text input field
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? AppColorsDark.inputBackground
                      : AppColorsLight.inputBackground,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Send button
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: _hasText
                  ? Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  AppColorsDark.primary,
                                  AppColorsDark.accent,
                                ]
                              : [
                                  AppColorsLight.primary,
                                  AppColorsLight.accent,
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: (isDark
                                    ? AppColorsDark.primary
                                    : AppColorsLight.primary)
                                .withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _sendMessage,
                      ),
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.mic,
                        color: isDark
                            ? AppColorsDark.iconPrimary
                            : AppColorsLight.iconPrimary,
                      ),
                      onPressed: () {
                        // TODO: Implement voice input
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Voice input - Coming soon!')),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
