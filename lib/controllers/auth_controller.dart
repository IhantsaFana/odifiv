import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rxn<User> currentUser = Rxn<User>();
  final RxBool isAuthenticated = false.obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  
  // État pour savoir si le profil scout existe
  final RxBool hasProfile = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Monitor auth state changes
    currentUser.bindStream(_authService.authStateChanges);
    
    // À chaque changement d'utilisateur, on vérifie son profil
    ever(currentUser, (user) async {
      isAuthenticated.value = user != null;
      if (user != null) {
        await checkProfileExists(user.uid);
      } else {
        hasProfile.value = false;
      }
    });
  }

  // Vérifie si un document valide existe dans /members/UID
  Future<void> checkProfileExists(String uid) async {
    try {
      final doc = await _firestore.collection('members').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        // Un profil est considéré complet s'il a une branche et une fonction
        final bool isComplete = data.containsKey('branch') && 
                                data['branch'].toString().isNotEmpty &&
                                data.containsKey('function') && 
                                data['function'].toString().isNotEmpty;
        
        hasProfile.value = isComplete;
      } else {
        hasProfile.value = false;
      }
    } catch (e) {
      _authService.logger.e('Error checking profile: $e');
      hasProfile.value = false;
    }
  }

  // Vérifie si l'email est autorisé dans la whitelist
  Future<bool> _isEmailAllowed(String email) async {
    try {
      final doc = await _firestore
          .collection('allowed_emails')
          .doc(email.toLowerCase().trim())
          .get();
      return doc.exists;
    } catch (e) {
      _authService.logger.e('Error checking whitelist: $e');
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final user = await _authService.loginWithGoogle();
      if (user != null) {
        // 1. Vérifier la Whitelist
        final isAllowed = await _isEmailAllowed(user.email ?? '');
        if (!isAllowed) {
          await logout();
          errorMessage.value = "Tsy nekena ny idiran'ise. Mifandraisa amin'i Ihantsa RAKOTONDRANAIVO (OEKA Mikofo).";
          isLoading.value = false;
          return false;
        }

        // 2. Vérifier le profil
        await checkProfileExists(user.uid);
        isLoading.value = false;
        return true;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
    isLoading.value = false;
    return false;
  }

  Future<bool> loginWithFacebook() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final user = await _authService.loginWithFacebook();
      if (user != null) {
        // 1. Vérifier la Whitelist
        final isAllowed = await _isEmailAllowed(user.email ?? '');
        if (!isAllowed) {
          await logout();
          errorMessage.value = "Tsy nekena ny idiran'ise. Mifandraisa amin'i Ihantsa RAKOTONDRANAIVO (OEKA Mikofo).";
          isLoading.value = false;
          return false;
        }

        // 2. Vérifier le profil
        await checkProfileExists(user.uid);
        isLoading.value = false;
        return true;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
    isLoading.value = false;
    return false;
  }

  Future<void> logout() async {
    await _authService.logout();
    isAuthenticated.value = false;
    hasProfile.value = false;
  }
}
