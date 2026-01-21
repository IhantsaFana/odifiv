import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../config/app_theme.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/social_login_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
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
                      title: 'Créer un compte',
                      subtitle: 'Rejoignez la communauté Fivondronana',
                      icon: Icons.person_add_rounded,
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
                        // Display name input
                        CustomInputField(
                          label: 'Nom complet',
                          hintText: 'Jean Dupont',
                          prefixIcon: Icons.person_outline,
                          controller: _displayNameController,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Nom requis';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

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
                            if (value!.length < 8) {
                              return 'Minimum 8 caractères';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        // Password strength indicator
                        Obx(() {
                          final password = _passwordController.text;
                          final hasLength = password.length >= 8;
                          final hasUpperCase = password.contains(
                            RegExp(r'[A-Z]'),
                          );
                          final hasNumber = password.contains(RegExp(r'[0-9]'));

                          return Column(
                            children: [
                              if (password.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _PasswordCriterion(
                                  label: 'Au moins 8 caractères',
                                  isMet: hasLength,
                                ),
                                _PasswordCriterion(
                                  label: 'Une lettre majuscule',
                                  isMet: hasUpperCase,
                                ),
                                _PasswordCriterion(
                                  label: 'Un chiffre',
                                  isMet: hasNumber,
                                ),
                              ],
                            ],
                          );
                        }),

                        const SizedBox(height: 20),

                        // Confirm password input
                        CustomInputField(
                          label: 'Confirmer le mot de passe',
                          hintText: '••••••••',
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          obscureText: _obscureConfirmPassword,
                          controller: _confirmPasswordController,
                          onSuffixIconPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Confirmation requise';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Terms checkbox
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: _agreedToTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _agreedToTerms = value ?? false;
                                  });
                                },
                                activeColor: AppTheme.sampanaPrimaryColor,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _agreedToTerms = !_agreedToTerms;
                                    });
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'J\'accepte les ',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 13,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'conditions d\'utilisation',
                                          style: TextStyle(
                                            color: AppTheme.sampanaPrimaryColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            decoration:
                                                TextDecoration.underline,
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

                        const SizedBox(height: 24),

                        // Register button
                        Obx(
                          () => CustomButton(
                            label: 'Créer mon compte',
                            onPressed: _handleRegister,
                            isLoading: authController.isLoading.value,
                            backgroundColor: AppTheme.sampanaPrimaryColor,
                            height: 56,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Google Sign-In Button
                        Obx(
                          () => SocialLoginButton(
                            label: 'S\'inscrire avec Google',
                            icon: Icons.g_mobiledata,
                            onPressed: _handleGoogleLogin,
                            isLoading: authController.isLoading.value,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Login link
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Vous avez un compte? ',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: Text(
                                  'Se connecter',
                                  style: TextStyle(
                                    color: AppTheme.sampanaPrimaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
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

class _PasswordCriterion extends StatelessWidget {
  final String label;
  final bool isMet;

  const _PasswordCriterion({required this.label, required this.isMet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isMet ? AppTheme.successColor : Colors.grey[400],
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isMet ? AppTheme.successColor : Colors.grey[500],
              fontWeight: isMet ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
