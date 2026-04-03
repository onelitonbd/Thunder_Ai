import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirestoreService _firestoreService = FirestoreService();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with Email and Password
  Future<UserCredential?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('✅ Signed in: ${credential.user?.email}');
      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Sign in error: ${e.code}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('❌ Sign in error: $e');
      throw 'An error occurred. Please try again.';
    }
  }

  // Sign up with Email and Password
  Future<UserCredential?> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
      
      // Create user profile in Firestore
      if (credential.user != null) {
        await _firestoreService.createUserProfile(
          userId: credential.user!.uid,
          email: email,
          displayName: name,
        );
      }
      
      debugPrint('✅ Signed up: ${credential.user?.email}');
      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Sign up error: ${e.code}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('❌ Sign up error: $e');
      throw 'An error occurred. Please try again.';
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        debugPrint('⚠️ Google sign in cancelled');
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);
      
      // Create or update user profile in Firestore
      if (userCredential.user != null) {
        await _firestoreService.createUserProfile(
          userId: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          displayName: userCredential.user!.displayName,
          photoUrl: userCredential.user!.photoURL,
        );
      }
      
      debugPrint('✅ Google sign in: ${userCredential.user?.email}');
      return userCredential;
    } catch (e) {
      debugPrint('❌ Google sign in error: $e');
      throw 'Google sign in failed. Please try again.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      debugPrint('✅ Signed out');
    } catch (e) {
      debugPrint('❌ Sign out error: $e');
      throw 'Sign out failed. Please try again.';
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint('✅ Password reset email sent to $email');
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Password reset error: ${e.code}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('❌ Password reset error: $e');
      throw 'Failed to send reset email. Please try again.';
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}
