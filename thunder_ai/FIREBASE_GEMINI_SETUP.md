# Firebase & Gemini AI Setup Guide

## Step 1: Get Gemini API Key

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy your API key

## Step 2: Configure Gemini API Key

Open `lib/core/constants/app_config.dart` and replace:

```dart
static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
```

With your actual API key:

```dart
static const String geminiApiKey = 'AIzaSy...your-actual-key';
```

**Note**: The model is already set to `gemini-1.5-flash-latest` (the latest fast model)

## Step 3: Setup Firebase

### Option A: Using FlutterFire CLI (Recommended)

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

This will:
- Create a Firebase project (or select existing)
- Register your Android/iOS apps
- Generate `firebase_options.dart` automatically
- Download `google-services.json` for Android

### Option B: Manual Setup

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Click "Add project"
   - Follow the setup wizard

2. **Add Android App**
   - Click "Add app" → Android
   - Package name: `com.example.thunder_ai`
   - Download `google-services.json`
   - Place it in `android/app/`

3. **Enable Firestore**
   - In Firebase Console, go to "Firestore Database"
   - Click "Create database"
   - Start in **test mode** (for development)
   - Choose a location

4. **Update firebase_options.dart**
   - Copy your Firebase config from console
   - Update `lib/firebase_options.dart` with your credentials

## Step 4: Firestore Security Rules

In Firebase Console → Firestore Database → Rules, use these rules for development:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read/write for all chats (development only)
    match /chats/{chatId} {
      allow read, write: if true;
      
      match /messages/{messageId} {
        allow read, write: if true;
      }
    }
  }
}
```

**⚠️ Important**: These rules are for development only. For production, implement proper authentication and user-based rules.

## Step 5: Run the App

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run
```

## Step 6: Test the Integration

1. **Create New Chat**
   - Tap the FAB (+) button
   - A new chat will be created in Firestore

2. **Send Message**
   - Type a message and send
   - Message saves to Firestore
   - Gemini AI generates response
   - Response saves to Firestore
   - Chat title auto-generates

3. **View Chat List**
   - Go back to home screen
   - See your chat with AI-generated title
   - Chats are grouped by time

4. **Real-time Sync**
   - Messages sync in real-time
   - Open same chat on another device to see sync

## Troubleshooting

### "Gemini API key not configured"
- Make sure you updated `app_config.dart` with your actual API key
- Remove quotes around the key
- Restart the app

### "Firebase initialization error"
- Run `flutterfire configure` again
- Check that `google-services.json` is in `android/app/`
- Verify package name matches: `com.example.thunder_ai`

### "Permission denied" in Firestore
- Check Firestore security rules
- Make sure rules allow read/write
- Rules may take a minute to propagate

### "Failed to generate response"
- Check your internet connection
- Verify Gemini API key is correct
- Check API quota in Google AI Studio
- Try a different model if needed

## Production Checklist

Before deploying to production:

- [ ] Implement Firebase Authentication
- [ ] Update Firestore security rules
- [ ] Store API keys securely (use environment variables)
- [ ] Add error handling and retry logic
- [ ] Implement rate limiting
- [ ] Add user profiles
- [ ] Enable Firebase Analytics
- [ ] Set up crash reporting
- [ ] Test on multiple devices
- [ ] Optimize Firestore queries

## API Costs

### Gemini API
- **Free tier**: 15 requests per minute
- **Paid tier**: Pay per token
- Check [pricing](https://ai.google.dev/pricing)

### Firebase
- **Spark (Free)**:
  - 1 GB storage
  - 10 GB/month transfer
  - 50K reads/day, 20K writes/day
- **Blaze (Pay as you go)**: See [pricing](https://firebase.google.com/pricing)

## Support

- Gemini API: https://ai.google.dev/docs
- Firebase: https://firebase.google.com/docs
- Flutter: https://flutter.dev/docs

---

**You're all set!** 🚀 Your Thunder Ai app is now connected to Firebase and Gemini AI.
