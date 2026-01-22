import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../config/app_theme.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
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
    _emailController.dispose();
    _passwordController.dispose();
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

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await authController.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success) {
      Get.offAllNamed('/home');
    } else {
      _showErrorDialog(
        authController.errorMessage.value ?? 'Erreur de connexion',
      );
    }
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // Important pour garder l'image fixe
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Image de fond (Full Screen)
          Image.asset(
            'assets/images/banniere_auth.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.topCenter, // Focus sur le haut (les enfants)
          ),

          // 2. Gradient Overlay (Bas vers Haut) pour lisibilité
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0.0, 0.7, 1.0],
                colors: [
                  Colors.white.withValues(alpha: 1.0),     // Bas: Blanc opaque pour le formulaire
                  Colors.white.withValues(alpha: 0.8),     // Milieu: Blanc semi-transparent
                  Colors.white.withValues(alpha: 0.0),     // Haut: Transparent pour voir l'image
                ],
              ),
            ),
          ),

          // 3. Contenu du Formulaire (En bas)
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: SlideTransition(
                    position: _slideController.drive(
                      Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ),
                    ),
                    child: FadeTransition(
                      opacity: _fadeController,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Prend juste la place nécessaire
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Titre Harambato
                            Text(
                              'Harambato',
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: AppTheme.sampanaPrimaryColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bienvenue ! Connectez-vous pour continuer',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Email
                            CustomInputField(
                              label: 'Adresse Email',
                              hintText: 'votre.email@example.com',
                              prefixIcon: Icons.email_outlined,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value?.isEmpty ?? true) return 'Email requis';
                                if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value!)) {
                                  return 'Email invalide';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password
                            CustomInputField(
                              label: 'Mot de passe',
                              hintText: '••••••••',
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              obscureText: _obscurePassword,
                              controller: _passwordController,
                              onSuffixIconPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              validator: (value) {
                                if (value?.isEmpty ?? true) return 'Mot de passe requis';
                                return null;
                              },
                            ),
                            
                            // Mot de passe oublié
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {}, // TODO
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Mot de passe oublié?',
                                  style: TextStyle(
                                    color: AppTheme.sampanaPrimaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Bouton Connexion
                            Obx(() => CustomButton(
                              label: 'Se connecter',
                              onPressed: _handleLogin,
                              isLoading: authController.isLoading.value,
                              backgroundColor: AppTheme.sampanaPrimaryColor,
                              height: 56,
                            )),
                            const SizedBox(height: 16),

                            // "Ou" Divider
                            Row(
                              children: [
                                Expanded(child: Divider(color: Colors.grey[300])),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('ou', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                ),
                                Expanded(child: Divider(color: Colors.grey[300])),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Google Sign In
                            Obx(() => SocialLoginButton(
                              label: 'Se connecter avec Google',
                              icon: Icons.g_mobiledata,
                              onPressed: _handleGoogleLogin,
                              isLoading: authController.isLoading.value,
                            )),
                            const SizedBox(height: 24),

                            // Lien Inscription
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Pas encore de compte? ',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                GestureDetector(
                                  onTap: () => Get.toNamed('/register'),
                                  child: Text(
                                    'Créer un compte',
                                    style: TextStyle(
                                      color: AppTheme.sampanaPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
