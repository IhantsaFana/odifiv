import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../config/app_theme.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
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
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
        authController.errorMessage.value ??
            'Erreur lors de la connexion Google',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Decorative header background
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1a4d7e).withValues(alpha: 0.08),
                      const Color(0xFFFF6B35).withValues(alpha: 0.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 40, 24, 60),
                  child: FadeTransition(
                    opacity: _fadeController.drive(
                      Tween<double>(begin: 0, end: 1),
                    ),
                    child: const AuthHeader(
                      title: 'Connexion',
                      subtitle: 'Accédez à votre compte Fivondronana',
                      icon: Icons.login_rounded,
                    ),
                  ),
                ),
              ),

              // Form section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: SlideTransition(
                  position: _slideController.drive(
                    Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email input
                        CustomInputField(
                          label: 'Adresse Email',
                          hintText: 'votre.email@example.com',
                          prefixIcon: Icons.email_outlined,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Email requis';
                            }
                            if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            ).hasMatch(value!)) {
                              return 'Email invalide';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Password input
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
                            if (value?.isEmpty ?? true) {
                              return 'Mot de passe requis';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        // Forgot password link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Implement forgot password screen
                            },
                            child: Text(
                              'Mot de passe oublié?',
                              style: TextStyle(
                                color: AppTheme.sampanaPrimaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Login button
                        Obx(
                          () => CustomButton(
                            label: 'Se connecter',
                            onPressed: _handleLogin,
                            isLoading: authController.isLoading.value,
                            backgroundColor: AppTheme.sampanaPrimaryColor,
                            height: 56,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Google Sign-In Button
                        Obx(
                          () => SocialLoginButton(
                            label: 'Se connecter avec Google',
                            icon: Icons.g_mobiledata,
                            onPressed: _handleGoogleLogin,
                            isLoading: authController.isLoading.value,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey[300],
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                'ou',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey[300],
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Register section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF1a4d7e,
                            ).withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(
                                0xFF1a4d7e,
                              ).withValues(alpha: 0.1),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Pas encore de compte?',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: () => Get.toNamed('/register'),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: AppTheme.sampanaPrimaryColor,
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Créer un compte',
                                    style: TextStyle(
                                      color: AppTheme.sampanaPrimaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Info message
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[400],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Connexion requise pour le premier accès',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
