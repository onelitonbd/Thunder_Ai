import 'package:intl/intl.dart';

class DateFormatUtil {
  /// Format time for chat list (e.g., "10:26 PM", "Yesterday", "Mon")
  static String formatChatListTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final chatDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (chatDate.isAtSameMomentAs(today)) {
      // Today: show time (e.g., "10:26 PM")
      return DateFormat('h:mm a').format(dateTime);
    } else if (chatDate.isAtSameMomentAs(yesterday)) {
      // Yesterday: show "Yesterday"
      return 'Yesterday';
    } else if (now.difference(dateTime).inDays < 7) {
      // Last 7 days: show day name (e.g., "Monday")
      return DateFormat('EEEE').format(dateTime);
    } else if (dateTime.year == now.year) {
      // This year: show month and day (e.g., "Jan 15")
      return DateFormat('MMM d').format(dateTime);
    } else {
      // Older: show full date (e.g., "1/15/23")
      return DateFormat('M/d/yy').format(dateTime);
    }
  }

  /// Format time for message bubbles (e.g., "10:26 PM")
  static String formatMessageTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  /// Format date for message grouping in chat (e.g., "Today", "Yesterday", "January 15, 2024")
  static String formatMessageGroupDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final chatDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (chatDate.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (chatDate.isAtSameMomentAs(yesterday)) {
      return 'Yesterday';
    } else if (dateTime.year == now.year) {
      return DateFormat('MMMM d').format(dateTime);
    } else {
      return DateFormat('MMMM d, yyyy').format(dateTime);
    }
  }

  /// Check if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
