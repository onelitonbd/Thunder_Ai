# Firebase Authentication Setup Guide

## 🔐 Setting Up Authentication

### Step 1: Enable Firebase Authentication

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click "Authentication" in the left menu
4. Click "Get Started"

### Step 2: Enable Sign-In Methods

#### Email/Password
1. Click "Sign-in method" tab
2. Click "Email/Password"
3. Enable "Email/Password"
4. Click "Save"

#### Google Sign-In
1. Click "Google" in sign-in providers
2. Enable "Google"
3. Enter support email
4. Click "Save"

### Step 3: Configure Google Sign-In for Android

#### Get SHA-1 Fingerprint

**Debug Key:**
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

**Release Key (if you have one):**
```bash
keytool -list -v -keystore /path/to/your/keystore.jks -alias your-alias
```

Copy the SHA-1 fingerprint.

#### Add SHA-1 to Firebase

1. In Firebase Console, go to Project Settings
2. Scroll to "Your apps"
3. Click your Android app
4. Click "Add fingerprint"
5. Paste SHA-1 fingerprint
6. Click "Save"

#### Download google-services.json

1. In Firebase Console, Project Settings
2. Scroll to "Your apps"
3. Click "Download google-services.json"
4. Place file in `android/app/` directory
5. Replace existing file if present

### Step 4: Configure OAuth Consent Screen

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Go to "APIs & Services" → "OAuth consent screen"
4. Fill in required fields:
   - App name: Thunder Ai
   - User support email: your-email@example.com
   - Developer contact: your-email@example.com
5. Click "Save and Continue"
6. Add scopes (optional)
7. Click "Save and Continue"
8. Add test users if in testing mode
9. Click "Save and Continue"

### Step 5: Rebuild the App

```bash
flutter clean
flutter pub get
flutter build apk --release
```

## ✅ Testing Authentication

### Test Email/Password
1. Open app
2. Click "Get Started"
3. Click "Sign Up"
4. Enter name, email, password
5. Click "Sign Up"
6. Should sign in successfully

### Test Google Sign-In
1. Open app
2. Click "Get Started"
3. Click "Continue with Google"
4. Select Google account
5. Should sign in successfully

### Test Sign Out
1. Go to Settings
2. Click "Sign Out"
3. Confirm sign out
4. Should return to welcome screen

## 🐛 Troubleshooting

### Google Sign-In Not Working

**Problem:** "Sign in failed" or "Developer error"

**Solution:**
1. Check SHA-1 fingerprint is added to Firebase
2. Download latest google-services.json
3. Rebuild app completely
4. Check OAuth consent screen is configured

### Email Sign-In Not Working

**Problem:** "Email already in use" or "Invalid email"

**Solution:**
1. Check email format is correct
2. Check password is at least 6 characters
3. Try different email
4. Check Firebase Authentication is enabled

### App Crashes on Sign In

**Problem:** App closes when signing in

**Solution:**
1. Check Firebase is initialized in main.dart
2. Check google-services.json is in android/app/
3. Check internet permissions in AndroidManifest.xml
4. Rebuild app from scratch

## 📱 Firebase Console Checklist

- [ ] Firebase project created
- [ ] Authentication enabled
- [ ] Email/Password provider enabled
- [ ] Google provider enabled
- [ ] SHA-1 fingerprint added
- [ ] google-services.json downloaded
- [ ] google-services.json placed in android/app/
- [ ] OAuth consent screen configured
- [ ] App rebuilt

## 🔒 Security Rules

Update Firestore security rules to use authentication:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Chats - users can only access their own chats
    match /chats/{chatId} {
      allow read, write: if request.auth != null && 
                           resource.data.userId == request.auth.uid;
      allow create: if request.auth != null;
      
      // Messages - same user as chat owner
      match /messages/{messageId} {
        allow read, write: if request.auth != null;
      }
    }
  }
}
```

## 📚 Additional Resources

- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [Google Sign-In for Android](https://developers.google.com/identity/sign-in/android/start)
- [Flutter Firebase Auth](https://firebase.flutter.dev/docs/auth/overview)

## 💡 Tips

- Use debug SHA-1 for development
- Add release SHA-1 before publishing
- Test both sign-in methods
- Configure proper security rules
- Add error handling in production

---

**Need help?** Open an issue on GitHub!
