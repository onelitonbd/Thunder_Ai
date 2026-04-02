# Thunder Ai ⚡

A modern, beautiful AI chat application built with Flutter, Firebase, and Google's Gemini AI.

![Flutter](https://img.shields.io/badge/Flutter-3.24.5-blue)
![Firebase](https://img.shields.io/badge/Firebase-Integrated-orange)
![Gemini AI](https://img.shields.io/badge/Gemini-1.5%20Flash-green)

## ✨ Features

- 🤖 **Real AI Conversations** - Powered by Google's Gemini 1.5 Flash
- 💬 **Real-time Chat** - Firebase Firestore for instant message sync
- 🎨 **Beautiful UI** - Telegram-inspired design with Light/Dark themes
- 📱 **Modern Interface** - Material 3 design with smooth animations
- 🔥 **Auto-generated Titles** - AI creates chat titles automatically
- 📊 **Time-grouped Chats** - Organized by Today, Yesterday, Last 7 Days, etc.
- 💾 **Cloud Storage** - All chats saved to Firebase
- 🎯 **Markdown Support** - Code blocks, bold text, and formatting

## 🚀 Quick Start

### Prerequisites
- Flutter 3.24.5 or higher
- Android SDK
- Gemini API key
- Firebase project

### Setup (3 minutes)

1. **Clone the repository**
```bash
git clone https://github.com/YOUR_USERNAME/Thunder_Ai.git
cd Thunder_Ai/thunder_ai
```

2. **Get Gemini API Key**
- Visit https://makersuite.google.com/app/apikey
- Create API key
- Add to `lib/core/constants/app_config.dart`:
```dart
static const String geminiApiKey = 'YOUR_KEY_HERE';
```

3. **Setup Firebase**
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

4. **Run the app**
```bash
flutter pub get
flutter run
```

## 📱 Screenshots

### Home Screen
- Time-grouped chat list
- Beautiful Telegram-style UI
- Light and Dark themes

### Chat Screen
- Message bubbles (user/AI)
- Markdown rendering
- Real-time updates

### Settings
- Theme switcher
- About dialog

## 🏗️ Architecture

```
lib/
├── core/
│   ├── theme/          # App themes and colors
│   ├── constants/      # Configuration
│   └── utils/          # Utilities
├── features/
│   ├── home/           # Chat list screen
│   ├── chat/           # Conversation screen
│   ├── profile/        # User profile
│   └── settings/       # App settings
├── models/             # Data models
├── services/           # Firebase & Gemini services
└── providers/          # Riverpod state management
```

## 🛠️ Tech Stack

- **Frontend**: Flutter 3.24.5
- **State Management**: Riverpod
- **Backend**: Firebase (Firestore)
- **AI**: Google Gemini 1.5 Flash
- **UI**: Material 3, Custom Telegram-inspired design

## 📚 Documentation

Detailed documentation available in `thunder_ai/`:
- `QUICK_START.md` - 3-minute setup guide
- `FIREBASE_GEMINI_SETUP.md` - Detailed setup instructions
- `PROJECT_COMPLETE.md` - Complete feature list
- `COMPLETE_SUMMARY.md` - Full overview

## 🔐 Security Notes

**Current Setup (Development)**:
- Firestore in test mode
- API key in code

**For Production**:
- Implement Firebase Authentication
- Secure Firestore rules
- Use environment variables for API keys
- Add rate limiting

## 💰 Costs

### Gemini API
- Free: 15 requests/minute
- Pricing: https://ai.google.dev/pricing

### Firebase
- Free tier: 50K reads/day, 20K writes/day
- Pricing: https://firebase.google.com/pricing

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- Telegram for UI inspiration
- Google for Gemini AI
- Firebase for backend services
- Flutter team for the amazing framework

## 📞 Support

For issues and questions:
- Open an issue on GitHub
- Check documentation in `thunder_ai/` folder

---

**Built with ❤️ using Flutter**
