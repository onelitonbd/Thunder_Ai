# Firebase Database Structure v1.2.0

## 📊 New User-Based Hierarchy

The database is now properly structured with user-based organization.

## Structure

```
Firestore
└── users/
    └── {userId}/
        ├── email: string
        ├── displayName: string
        ├── photoUrl: string (optional)
        ├── createdAt: timestamp
        ├── updatedAt: timestamp
        │
        ├── chats/
        │   └── {chatId}/
        │       ├── userId: string
        │       ├── title: string
        │       ├── lastMessage: string
        │       ├── createdAt: timestamp
        │       ├── updatedAt: timestamp
        │       │
        │       └── messages/
        │           └── {messageId}/
        │               ├── sender: "user" | "ai"
        │               ├── text: string
        │               ├── timestamp: timestamp
        │               └── isMarkdown: boolean
        │
        └── settings/
            └── preferences/
                ├── theme: string
                ├── notifications: boolean
                └── updatedAt: timestamp
```

## Benefits

### 1. User Isolation
- Each user's data is completely separate
- No cross-user data access
- Better privacy and security

### 2. Easy Data Management
- All user data in one place
- Easy to backup user data
- Easy to delete user account

### 3. Better Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // User's chats
      match /chats/{chatId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
        
        // Chat messages
        match /messages/{messageId} {
          allow read, write: if request.auth != null && request.auth.uid == userId;
        }
      }
      
      // User's settings
      match /settings/{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

### 4. Scalability
- Better query performance
- No need for userId filters
- Efficient data retrieval

### 5. Data Organization
- Clear hierarchy
- Easy to understand
- Maintainable structure

## Migration from Old Structure

If you have data in the old structure (`chats/` collection), you'll need to migrate:

### Old Structure (v1.1.x)
```
chats/
└── {chatId}/
    ├── userId: string
    ├── title: string
    └── messages/
```

### New Structure (v1.2.0)
```
users/
└── {userId}/
    └── chats/
        └── {chatId}/
            └── messages/
```

### Migration Script (Optional)

If you need to migrate existing data, contact support or use Firebase Console to manually move data.

## API Changes

### Old API
```dart
// Old way
firestoreService.createChat(userId: userId, title: title);
firestoreService.getChatMessages(chatId);
firestoreService.addMessage(chatId: chatId, ...);
```

### New API
```dart
// New way - includes userId
firestoreService.createChat(userId: userId, title: title);
firestoreService.getChatMessages(userId, chatId);
firestoreService.addMessage(userId: userId, chatId: chatId, ...);
```

## Features

### User Profile
- Automatically created on sign up/sign in
- Stores email, display name, photo URL
- Timestamps for tracking

### User Settings
- Stored in `settings/preferences` document
- Can store theme, notifications, etc.
- Easy to extend

### User Chats
- All chats under user's document
- Ordered by updatedAt
- Includes messages subcollection

### Data Deletion
- New `deleteUserData()` method
- Deletes all user data
- Useful for account deletion

## Security

### Firestore Rules
- Users can only access their own data
- Authentication required
- No cross-user access

### Privacy
- Each user's data is isolated
- No shared collections
- Better GDPR compliance

## Performance

### Optimized Queries
- No need for `where` clauses on userId
- Direct document access
- Faster reads and writes

### Indexing
- Automatic indexing on subcollections
- Better query performance
- Scalable structure

## Example Usage

### Create User Profile
```dart
await firestoreService.createUserProfile(
  userId: user.uid,
  email: user.email!,
  displayName: user.displayName,
);
```

### Create Chat
```dart
final chatId = await firestoreService.createChat(
  userId: user.uid,
  title: 'New Chat',
);
```

### Send Message
```dart
await firestoreService.addMessage(
  userId: user.uid,
  chatId: chatId,
  sender: 'user',
  text: 'Hello!',
);
```

### Get User Chats
```dart
Stream<List<Chat>> chats = firestoreService.getUserChats(user.uid);
```

### Delete User Data
```dart
await firestoreService.deleteUserData(user.uid);
```

## Summary

✅ User-based hierarchy  
✅ Better security  
✅ Improved performance  
✅ Easy data management  
✅ GDPR compliant  
✅ Scalable structure  

---

**This structure is production-ready and follows Firebase best practices!**
