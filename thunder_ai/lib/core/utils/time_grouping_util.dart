import '../../models/chat.dart';
import '../../models/grouped_chats.dart';

class TimeGroupingUtil {
  /// Group chats by time periods (Today, Yesterday, Last 7 Days, etc.)
  static List<GroupedChats> groupChatsByTime(List<Chat> chats) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final sevenDaysAgo = today.subtract(const Duration(days: 7));
    final thirtyDaysAgo = today.subtract(const Duration(days: 30));

    // Separate chats into groups
    final Map<TimeGroup, List<Chat>> groupedMap = {
      TimeGroup.today: [],
      TimeGroup.yesterday: [],
      TimeGroup.lastSevenDays: [],
      TimeGroup.previousThirtyDays: [],
      TimeGroup.older: [],
    };

    for (final chat in chats) {
      final chatDate = DateTime(
        chat.updatedAt.year,
        chat.updatedAt.month,
        chat.updatedAt.day,
      );

      if (chatDate.isAtSameMomentAs(today)) {
        groupedMap[TimeGroup.today]!.add(chat);
      } else if (chatDate.isAtSameMomentAs(yesterday)) {
        groupedMap[TimeGroup.yesterday]!.add(chat);
      } else if (chatDate.isAfter(sevenDaysAgo) && chatDate.isBefore(yesterday)) {
        groupedMap[TimeGroup.lastSevenDays]!.add(chat);
      } else if (chatDate.isAfter(thirtyDaysAgo) && chatDate.isBefore(sevenDaysAgo)) {
        groupedMap[TimeGroup.previousThirtyDays]!.add(chat);
      } else {
        groupedMap[TimeGroup.older]!.add(chat);
      }
    }

    // Convert to list of GroupedChats, excluding empty groups
    final List<GroupedChats> result = [];
    for (final entry in groupedMap.entries) {
      if (entry.value.isNotEmpty) {
        result.add(GroupedChats(
          group: entry.key,
          label: GroupedChats.getLabelForGroup(entry.key),
          chats: entry.value,
        ));
      }
    }

    return result;
  }

  /// Determine which time group a specific date belongs to
  static TimeGroup getTimeGroup(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final sevenDaysAgo = today.subtract(const Duration(days: 7));
    final thirtyDaysAgo = today.subtract(const Duration(days: 30));

    final chatDate = DateTime(date.year, date.month, date.day);

    if (chatDate.isAtSameMomentAs(today)) {
      return TimeGroup.today;
    } else if (chatDate.isAtSameMomentAs(yesterday)) {
      return TimeGroup.yesterday;
    } else if (chatDate.isAfter(sevenDaysAgo) && chatDate.isBefore(yesterday)) {
      return TimeGroup.lastSevenDays;
    } else if (chatDate.isAfter(thirtyDaysAgo) && chatDate.isBefore(sevenDaysAgo)) {
      return TimeGroup.previousThirtyDays;
    } else {
      return TimeGroup.older;
    }
  }
}
