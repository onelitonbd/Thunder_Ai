import 'package:flutter/material.dart';

class AppTextStyles {
  // App Bar Title - Bold and prominent
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  // Chat List - Chat Title
  static const TextStyle chatTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );

  // Chat List - Last Message Preview
  static const TextStyle chatSubtitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.2,
    height: 1.4,
  );

  // Chat List - Time Stamp
  static const TextStyle chatTime = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.1,
  );

  // Time Group Headers
  static const TextStyle timeGroupHeader = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Message Bubble - User/AI Text
  static const TextStyle messageText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.2,
    height: 1.5,
  );

  // Message Bubble - Time Stamp
  static const TextStyle messageTime = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
  );

  // Input Field
  static const TextStyle inputText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.2,
  );

  // Input Field - Hint
  static const TextStyle inputHint = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.2,
  );

  // Bottom Navigation Label
  static const TextStyle navLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  // Bot Subtitle in Chat Screen
  static const TextStyle botSubtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  // Section Headers
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );
  
  // Large Title
  static const TextStyle largeTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
  );
}
