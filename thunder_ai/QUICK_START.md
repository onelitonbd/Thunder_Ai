# Thunder Ai - Quick Start Guide ⚡

## 3-Minute Setup

### Step 1: Get Gemini API Key (1 minute)
1. Go to https://makersuite.google.com/app/apikey
2. Click "Create API Key"
3. Copy the key

### Step 2: Add API Key (30 seconds)
Open `lib/core/constants/app_config.dart`:
```dart
static const String geminiApiKey = 'PASTE_YOUR_KEY_HERE';
```

### Step 3: Setup Firebase (1 minute)
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
- Select or create Firebase project
- Choose Android platform
- Enable Firestore (test mode)

### Step 4: Run! (30 seconds)
```bash
flutter pub get
flutter run
```

---

## That's It! 🎉

Your app is now running with:
- ✅ Real Gemini AI responses
- ✅ Firebase real-time sync
- ✅ Beautiful Telegram UI
- ✅ Auto-generated chat titles

---

## First Use

1. **Tap the + button** to create a new chat
2. **Type a message** and send
3. **Watch the AI respond** in real-time
4. **Go back** to see your chat in the list with an AI-generated title

---

## Troubleshooting

**"API key not configured"**
→ Make sure you pasted your key in `app_config.dart`

**"Firebase error"**
→ Run `flutterfire configure` again

**"Permission denied"**
→ Enable Firestore in Firebase Console (test mode)

---

## Need Help?

See `FIREBASE_GEMINI_SETUP.md` for detailed instructions.

---

**Happy chatting!** 🚀
