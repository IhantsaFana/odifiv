import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../config/app_theme.dart';
import '../../widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final authController = Get.find<AuthController>();
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }

  Future<void> _handleGoogleLogin() async {
    final success = await authController.loginWithGoogle();
    if (success) {
      Get.offAllNamed('/home');
    } else {
      _showErrorDialog(
        authController.errorMessage.value ?? 'Erreur lors de la connexion Google',
      );
    }
  }

  Future<void> _handleFacebookLogin() async {
    final success = await authController.loginWithFacebook();
    if (success) {
      Get.offAllNamed('/home');
    } else {
      _showErrorDialog(
        authController.errorMessage.value ?? 'Erreur lors de la connexion Facebook',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Image de fond (Full Screen)
          Image.asset(
            'assets/images/banniere_auth.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.topCenter,
          ),

          // 2. Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0.0, 0.5, 0.7],
                colors: [
                  Colors.white,                            // Bas: 100% Blanc
                  Colors.white.withValues(alpha: 0.99),    // Milieu
                  Colors.white.withValues(alpha: 0.0),     // Haut
                ],
              ),
            ),
          ),

          // 3. Contenu (Boutons Sociaux uniquement)
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: SlideTransition(
                  position: _slideController.drive(
                    Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ),
                  ),
                  child: FadeTransition(
                    opacity: _fadeController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header avec Logo + Textes
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Logo
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/logo.png',
                                height: 64, // Taille ajustée pour l'équilibre
                                width: 64,
                              ),
                            ),
                            const SizedBox(width: 16),
                            
                            // Textes
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Harambato',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: AppTheme.sampanaPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tonga soa ise ! Miankina amin\'ise ny herin\'ny Fivondronantsika',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[800],
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),

                        // Google Sign In
                        Obx(() => SocialLoginButton(
                          label: 'Se connecter avec Google',
                          imagePath: 'assets/images/google_logo.webp',
                          onPressed: _handleGoogleLogin,
                          isLoading: authController.isLoading.value,
                        )),
                        const SizedBox(height: 16),

                        // Facebook Sign In
                        Obx(() => SocialLoginButton(
                          label: 'Se connecter avec Facebook',
                          imagePath: 'assets/images/facebook_logo.png',
                          backgroundColor: const Color(0xFF1877F2),
                          textColor: Colors.white,
                          onPressed: _handleFacebookLogin,
                          isLoading: authController.isLoading.value,
                        )),
                        
                        const SizedBox(height: 24),
                        // Note informative
                        Text(
                          "Natao ho an'ny Mpiandraikitra ao amin'ny fivondronana Harambato faha 420 ity application ity. Mifandraisa amin'i Ihantsa RAKOTONDRANAIVO (OEKA Mikofo) raha tsy mbola manana kaonty ise. Mankasitraka !",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
