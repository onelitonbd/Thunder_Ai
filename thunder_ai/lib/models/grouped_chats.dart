import 'chat.dart';

enum TimeGroup {
  today,
  yesterday,
  lastSevenDays,
  previousThirtyDays,
  older,
}

class GroupedChats {
  final TimeGroup group;
  final String label;
  final List<Chat> chats;

  GroupedChats({
    required this.group,
    required this.label,
    required this.chats,
  });

  // Get display label for each time group
  static String getLabelForGroup(TimeGroup group) {
    switch (group) {
      case TimeGroup.today:
        return 'Today';
      case TimeGroup.yesterday:
        return 'Yesterday';
      case TimeGroup.lastSevenDays:
        return 'Last 7 Days';
      case TimeGroup.previousThirtyDays:
        return 'Previous 30 Days';
      case TimeGroup.older:
        return 'Older';
    }
  }
}
