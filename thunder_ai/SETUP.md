# Thunder Ai - Setup Instructions

## Step 1: Dependencies Installed ✓

All required dependencies have been added to `pubspec.yaml`:

### Firebase
- `firebase_core` - Core Firebase functionality
- `firebase_auth` - User authentication
- `cloud_firestore` - Cloud database

### State Management
- `flutter_riverpod` - Modern state management

### Routing
- `go_router` - Declarative routing

### UI & Utilities
- `flutter_markdown` - Render markdown in AI messages
- `intl` - Date/time formatting
- `timeago` - Relative time formatting (e.g., "2 hours ago")

## Step 2: Firebase Configuration (Required)

You need to configure Firebase for your project:

### Option 1: Using FlutterFire CLI (Recommended)
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase (this will auto-generate firebase_options.dart)
flutterfire configure
```

### Option 2: Manual Configuration
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use existing one
3. Add Android app with package name: `com.example.thunder_ai`
4. Download `google-services.json` and place it in `android/app/`
5. Update `lib/firebase_options.dart` with your Firebase credentials

## Step 3: Project Structure

```
lib/
├── core/
│   ├── theme/          # Theme data (Step 2)
│   ├── constants/      # App constants
│   └── utils/          # Utility functions
├── features/
│   ├── home/           # Home screen (chat list)
│   ├── chat/           # Chat screen
│   ├── profile/        # Profile screen
│   └── settings/       # Settings screen
├── services/           # Firebase services
├── models/             # Data models
├── providers/          # Riverpod providers
├── firebase_options.dart
└── main.dart
```

## Next Steps

- **Step 2**: Implement Telegram-style Light/Dark themes
- **Step 3**: Create Firebase service layer
- **Step 4**: Build Home Screen UI
- **Step 5**: Build Chat Screen UI
- **Step 6**: Connect Firebase to UI

## Running the App

```bash
flutter run
```

---

**Note**: Firebase configuration is required before the app can run properly. Make sure to complete Step 2 above.
