import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../services/auth_service.dart';
import '../services/offline_service.dart';

class AuthController extends GetxController {
  final authService = AuthService();
  final offlineService = Get.find<OfflineService>();
  final logger = Logger();

  // Observables
  final Rxn<User?> currentUser = Rxn<User?>();
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();
  final isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    ever(currentUser, (User? user) {
      isAuthenticated.value = user != null;
      if (user != null) {
        _cacheUserData(user);
      } else {
        _clearUserData();
      }
    });

    // Set initial auth state
    currentUser.value = authService.currentUser;

    // Listen to Firebase auth state changes
    authService.authStateChanges.listen((User? user) {
      currentUser.value = user;
    });
  }

  // Registration method removed as per requirements (admin only)

  /// Login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      // Validate inputs
      if (!_isValidEmail(email)) {
        throw Exception('Email invalide');
      }
      if (password.isEmpty) {
        throw Exception('Le mot de passe ne peut pas être vide');
      }

      final user = await authService.loginWithEmail(
        email: email,
        password: password,
      );

      if (user != null) {
        currentUser.value = user;
        logger.i('User logged in: ${user.email}');
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      final message = _getFirebaseErrorMessage(e.code);
      errorMessage.value = message;
      logger.e('Login error: $message');
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      logger.e('Unexpected error during login: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await authService.logout();
      currentUser.value = null;
      logger.i('User logged out');
    } catch (e) {
      errorMessage.value = 'Erreur lors de la déconnexion';
      logger.e('Logout error: $e');
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      if (!_isValidEmail(email)) {
        throw Exception('Email invalide');
      }

      await authService.resetPassword(email: email);
      logger.i('Password reset email sent');
      return true;
    } on FirebaseAuthException catch (e) {
      final message = _getFirebaseErrorMessage(e.code);
      errorMessage.value = message;
      logger.e('Password reset error: $message');
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      logger.e('Error sending reset email: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Login with Google
  Future<bool> loginWithGoogle() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final user = await authService.loginWithGoogle();

      if (user != null) {
        if (await _checkIfUserIsAllowed(user)) {
          currentUser.value = user;
          logger.i('User logged in with Google: ${user.email}');
          return true;
        } else {
          // User not allowed (new account), logout and show error
          await authService.logout();
          errorMessage.value = "Compte non reconnu. Inscription fermée au public.";
          return false;
        }
      }
      return false;
    } on FirebaseAuthException catch (e) {
      final message = _getFirebaseErrorMessage(e.code);
      errorMessage.value = message;
      logger.e('Google login error: $message');
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      logger.e('Error during Google Sign-In: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Login with Facebook
  Future<bool> loginWithFacebook() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final user = await authService.loginWithFacebook();

      if (user != null) {
        if (await _checkIfUserIsAllowed(user)) {
          currentUser.value = user;
          logger.i('User logged in with Facebook: ${user.email}');
          return true;
        } else {
          // User not allowed, logout
          await authService.logout();
          errorMessage.value = "Compte non reconnu. Inscription fermée au public.";
          return false;
        }
      }
      return false;
    } on FirebaseAuthException catch (e) {
      final message = _getFirebaseErrorMessage(e.code);
      errorMessage.value = message;
      logger.e('Facebook login error: $message');
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      logger.e('Error during Facebook Sign-In: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear error message
  void clearError() {
    errorMessage.value = null;
  }

  // Private methods

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Map Firebase error codes to French messages
  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Utilisateur non trouvé';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé';
      case 'invalid-email':
        return 'Email invalide';
      case 'weak-password':
        return 'Le mot de passe est trop faible';
      case 'operation-not-allowed':
        return 'Opération non autorisée';
      case 'user-disabled':
        return 'Compte utilisateur désactivé';
      case 'too-many-requests':
        return 'Trop de tentatives de connexion. Réessayez plus tard';
      case 'network-request-failed':
        return 'Erreur réseau. Vérifiez votre connexion';
      default:
        return 'Erreur d\'authentification: $code';
    }
  }

  /// Cache user data locally
  void _cacheUserData(User user) {
    offlineService.saveData('currentUser_email', user.email);
    offlineService.saveData('currentUser_name', user.displayName);
    offlineService.saveData('currentUser_id', user.uid);
  }

  /// Clear cached user data
  void _clearUserData() {
    offlineService.deleteData('currentUser_email');
    offlineService.deleteData('currentUser_name');
    offlineService.deleteData('currentUser_id');
  }

  /// Check if user is allowed (prevent new signups)
  Future<bool> _checkIfUserIsAllowed(User user) async {
    // Check metadata to see if it's a new account
    final metadata = user.metadata;
    if (metadata.creationTime == null || metadata.lastSignInTime == null) {
      return true; // No metadata, assume ok? Or fail safe.
    }

    // If creation time is very close to last sign in time, it's a new user
    // We allow a small buffer (e.g. 1 minute)
    final diff = metadata.lastSignInTime!.difference(metadata.creationTime!).inSeconds.abs();
    
    // NOTE: This logic assumes that for existing users, creationTime will be strictly < lastSignInTime
    // by a significant margin. For a BRAND NEW signup, they are almost identical.
    
    if (diff < 60) {
      logger.w('New user registration attempt blocked: ${user.email}');
      // Optional: Delete the user to keep auth clean
      try {
         await user.delete();
      } catch (e) {
        logger.e('Failed to delete unauthorized user: $e');
      }
      return false;
    }
    
    return true;
  }
}
