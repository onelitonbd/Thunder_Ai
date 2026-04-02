# Thunder Ai v1.0.0 - Initial Release ⚡

## 🎉 First Release

Thunder Ai is a modern, beautiful AI chat application built with Flutter, Firebase, and Google's Gemini AI.

## ✨ Features

- 🤖 **Real AI Conversations** - Powered by Google's Gemini 1.5 Flash
- 💬 **Real-time Chat** - Firebase Firestore for instant message sync
- 🎨 **Beautiful UI** - Telegram-inspired design with Light/Dark themes
- 📱 **Modern Interface** - Material 3 design with smooth animations
- 🔥 **Auto-generated Titles** - AI creates chat titles automatically
- 📊 **Time-grouped Chats** - Organized by Today, Yesterday, Last 7 Days, etc.
- 💾 **Cloud Storage** - All chats saved to Firebase
- 🎯 **Markdown Support** - Code blocks, bold text, and formatting

## 📱 Download

Download the APK file below and install on your Android device.

**Minimum Android Version:** Android 6.0 (API 23) or higher

## 🚀 Setup Required

Before using the app, you need to:

1. **Get Gemini API Key**
   - Visit https://makersuite.google.com/app/apikey
   - Create API key
   - Add to `lib/core/constants/app_config.dart`

2. **Setup Firebase**
   - Run `flutterfire configure`
   - Enable Firestore in test mode

See `QUICK_START.md` for detailed instructions.

## 🛠️ Tech Stack

- **Frontend**: Flutter 3.24.5
- **State Management**: Riverpod
- **Backend**: Firebase (Firestore)
- **AI**: Google Gemini 1.5 Flash
- **UI**: Material 3, Custom Telegram-inspired design

## 📚 Documentation

- `QUICK_START.md` - 3-minute setup guide
- `FIREBASE_GEMINI_SETUP.md` - Detailed setup instructions
- `PROJECT_COMPLETE.md` - Complete feature list
- `COMPLETE_SUMMARY.md` - Full overview

## 🔐 Security Notes

This is a development release. For production use:
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

## 🐛 Known Issues

None at this time.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- Telegram for UI inspiration
- Google for Gemini AI
- Firebase for backend services
- Flutter team for the amazing framework

---

**Built with ❤️ using Flutter**

For issues and questions, please open an issue on GitHub.
