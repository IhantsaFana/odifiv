import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../config/app_theme.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/social_login_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  final authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;
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
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog('Les mots de passe ne correspondent pas');
      return;
    }

    if (!_agreedToTerms) {
      _showErrorDialog('Veuillez accepter les conditions d\'utilisation');
      return;
    }

    final success = await authController.register(
      displayName: _displayNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success) {
      Get.offAllNamed('/home');
    } else {
      _showErrorDialog(
        authController.errorMessage.value ?? 'Erreur lors de l\'inscription',
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

          // 2. Gradient Overlay (Bas vers Haut) plus prononcé pour Register car formulaire plus long
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0.0, 0.8, 1.0],
                colors: [
                  Colors.white.withValues(alpha: 1.0),
                  Colors.white.withValues(alpha: 0.95),
                  Colors.white.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),

          // 3. Contenu Formulaire
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
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
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
                              'Rejoignez la communauté !',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Nom complet
                            CustomInputField(
                              label: 'Nom complet',
                              hintText: 'Jean Dupont',
                              prefixIcon: Icons.person_outline,
                              controller: _displayNameController,
                              validator: (value) => (value?.isEmpty ?? true) ? 'Nom requis' : null,
                            ),
                            const SizedBox(height: 16),

                            // Email
                            CustomInputField(
                              label: 'Email',
                              hintText: 'votre.email@example.com',
                              prefixIcon: Icons.email_outlined,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) => (value?.isEmpty ?? true) ? 'Email requis' : null,
                            ),
                            const SizedBox(height: 16),

                            // Password
                            CustomInputField(
                              label: 'Mot de passe',
                              hintText: '••••••••',
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              obscureText: _obscurePassword,
                              controller: _passwordController,
                              onSuffixIconPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              validator: (value) => (value?.isEmpty ?? true) ? 'Requis' : (value!.length < 8 ? 'Min 8 chars' : null),
                            ),
                            const SizedBox(height: 16),

                            // Confirm Password
                            CustomInputField(
                              label: 'Confirmer',
                              hintText: '••••••••',
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              obscureText: _obscureConfirmPassword,
                              controller: _confirmPasswordController,
                              onSuffixIconPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                              validator: (value) => (value?.isEmpty ?? true) ? 'Requis' : null,
                            ),
                            const SizedBox(height: 12),

                            // Terms
                            Row(
                              children: [
                                Checkbox(
                                  value: _agreedToTerms,
                                  onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                                  activeColor: AppTheme.sampanaPrimaryColor,
                                  visualDensity: VisualDensity.compact,
                                ),
                                Expanded(
                                  child: Text(
                                    'J\'accepte les conditions d\'utilisation',
                                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            Obx(() => CustomButton(
                              label: 'Créer mon compte',
                              onPressed: _handleRegister,
                              isLoading: authController.isLoading.value,
                              backgroundColor: AppTheme.sampanaPrimaryColor,
                              height: 56,
                            )),
                            const SizedBox(height: 16),
                            
                            // Lien connexion
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Déjà un compte? ', style: TextStyle(color: Colors.grey[700])),
                                GestureDetector(
                                  onTap: () => Get.back(),
                                  child: Text('Se connecter', style: TextStyle(color: AppTheme.sampanaPrimaryColor, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            // Ajout d'espace safe pour le bottom
                            const SizedBox(height: 16),
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
