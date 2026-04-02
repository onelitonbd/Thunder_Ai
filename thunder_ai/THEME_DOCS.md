# Thunder Ai - Theme System Documentation

## Step 2 Complete ✓

### Theme Files Created

1. **app_colors.dart** - Telegram-inspired color palettes
2. **app_text_styles.dart** - Typography matching Telegram
3. **app_theme.dart** - Complete ThemeData for Light & Dark modes
4. **theme_provider.dart** - Riverpod provider for theme switching

---

## Color Palette

### Light Mode Colors
- **Primary Blue**: `#3390EC` (Telegram signature blue)
- **Background**: `#FFFFFF` (Pure white)
- **Secondary Background**: `#F4F4F5` (Light grey)
- **User Message Bubble**: `#3390EC` (Blue)
- **AI Message Bubble**: `#F4F4F5` (Light grey)
- **Text Primary**: `#000000` (Black)
- **Text Secondary**: `#707579` (Grey)
- **Dividers**: `#E5E5EA` (Light grey)

### Dark Mode Colors
- **Primary Blue**: `#3390EC` (Same Telegram blue)
- **Background**: `#0E1621` (Deep dark blue-grey)
- **Secondary Background**: `#17212B` (Slightly lighter)
- **User Message Bubble**: `#3390EC` (Blue)
- **AI Message Bubble**: `#182533` (Dark grey-blue)
- **Text Primary**: `#FFFFFF` (White)
- **Text Secondary**: `#8E8E93` (Grey)
- **Dividers**: `#2B3640` (Dark grey)

---

## Typography

All text styles match Telegram's typography:

- **App Bar Title**: 20px, Semi-bold
- **Chat Title**: 16px, Semi-bold
- **Chat Subtitle**: 15px, Regular
- **Message Text**: 16px, Regular, 1.4 line height
- **Time Stamps**: 12-14px, Regular
- **Input Text**: 16px, Regular

---

## Theme Features

✅ **Material 3** design system
✅ **System theme detection** (auto light/dark)
✅ **Manual theme toggle** support
✅ **Telegram-accurate colors** for both modes
✅ **Consistent spacing** and borders
✅ **Rounded corners** matching Telegram (12-24px)
✅ **Proper elevation** and shadows

---

## Usage in Code

### Access Theme Colors

```dart
// In any widget with BuildContext
final isDark = Theme.of(context).brightness == Brightness.dark;
final primaryColor = Theme.of(context).colorScheme.primary;
final textColor = Theme.of(context).textTheme.bodyLarge?.color;
```

### Access Custom Colors

```dart
import 'package:thunder_ai/core/theme/app_colors.dart';

// Light mode colors
AppColorsLight.userBubble
AppColorsLight.aiBubble
AppColorsLight.textSecondary

// Dark mode colors
AppColorsDark.userBubble
AppColorsDark.aiBubble
AppColorsDark.textSecondary
```

### Toggle Theme (Riverpod)

```dart
// In a ConsumerWidget
ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
ref.read(themeModeProvider.notifier).state = ThemeMode.light;
ref.read(themeModeProvider.notifier).state = ThemeMode.system;
```

---

## Testing the Theme

Run the app to see the placeholder screen with theme toggle:

```bash
flutter run
```

Tap the sun/moon icon in the app bar to switch between light and dark modes.

---

## Next Steps

**Step 3**: Implement Firebase Firestore service layer
- Chat model
- Message model
- Time grouping logic (Today, Yesterday, Last 7 Days, etc.)
- CRUD operations for chats and messages
