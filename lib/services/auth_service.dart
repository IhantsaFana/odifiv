import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:logger/logger.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final logger = Logger();

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Get auth state changes stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Register with email and password
  Future<User?> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      logger.i('Registering user with email: $email');

      // Create user account
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user != null) {
        // Update display name
        await user.updateDisplayName(displayName);
        await user.reload();
        logger.i('User registered successfully: ${user.email}');
        return user;
      }
    } on FirebaseAuthException catch (e) {
      logger.e('Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      logger.e('Error during registration: $e');
      rethrow;
    }
    return null;
  }

  /// Login with email and password
  Future<User?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      logger.i('Logging in user: $email');

      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;
      if (user != null) {
        logger.i('User logged in successfully: ${user.email}');
      }
      return user;
    } on FirebaseAuthException catch (e) {
      logger.e('Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      logger.e('Error during login: $e');
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      logger.i('Logging out user');
      await _firebaseAuth.signOut();
      logger.i('User logged out successfully');
    } catch (e) {
      logger.e('Error during logout: $e');
      rethrow;
    }
  }

  /// Reset password
  Future<void> resetPassword({required String email}) async {
    try {
      logger.i('Sending password reset email to: $email');
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      logger.i('Password reset email sent');
    } on FirebaseAuthException catch (e) {
      logger.e('Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      logger.e('Error sending reset email: $e');
      rethrow;
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  /// Get current user email
  String? get userEmail => _firebaseAuth.currentUser?.email;

  /// Get current user display name
  String? get userDisplayName => _firebaseAuth.currentUser?.displayName;

  /// Login with Google
  Future<User?> loginWithGoogle() async {
    try {
      logger.i('Starting Google Sign-In...');

      // Sign out previous session
      await _googleSignIn.signOut();

      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        logger.i('Google Sign-In cancelled by user');
        return null;
      }

      logger.i('Google user signed in: ${googleUser.email}');

      // Get authentication credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create credential for Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credential
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        logger.i('User logged in with Google: ${user.email}');
      }

      return user;
    } on FirebaseAuthException catch (e) {
      logger.e('Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      logger.e('Error during Google Sign-In: $e');
      rethrow;
    }
  }

  /// Login with Facebook
  Future<User?> loginWithFacebook() async {
    try {
      logger.i('Starting Facebook Sign-In...');

      // Trigger Facebook Sign-In flow
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.cancelled) {
        logger.i('Facebook Sign-In cancelled by user');
        return null;
      } else if (result.status == LoginStatus.failed) {
        logger.e('Facebook Sign-In failed: ${result.message}');
        throw Exception('Facebook Sign-In failed: ${result.message}');
      }

      final AccessToken accessToken = result.accessToken!;
      logger.i('Facebook user signed in. Token: ${accessToken.token}');

      // Create credential for Firebase
      final OAuthCredential credential =
          FacebookAuthProvider.credential(accessToken.token);

      // Sign in to Firebase with Facebook credential
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        logger.i('User logged in with Facebook: ${user.email}');
      }

      return user;
    } on FirebaseAuthException catch (e) {
      logger.e('Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      logger.e('Error during Facebook Sign-In: $e');
      rethrow;
    }
  }
}
