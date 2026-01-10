import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../config/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Succès'),
        content: const Text(
          'Compte créé avec succès! Vous êtes maintenant connecté.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed('/home');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreedToTerms) {
      _showErrorDialog('Vous devez accepter les conditions d\'utilisation');
      return;
    }

    final success = await authController.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _displayNameController.text.trim(),
    );

    if (success) {
      _showSuccessDialog();
    } else {
      _showErrorDialog(
        authController.errorMessage.value ?? 'Erreur lors de l\'inscription',
      );
    }
  }

  String? _validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Mot de passe requis';
    }
    if (value!.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une lettre minuscule';
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une lettre majuscule';
    }
    if (!RegExp(r'(?=.*[0-9])').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins un chiffre';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Créer un compte',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Bienvenue à Fivondronana',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.sampanaPrimaryColor,
                    ),
              ),

              const SizedBox(height: 12),

              Text(
                'Créez votre compte pour digitaliser votre Scout',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),

              const SizedBox(height: 32),

              // Registration form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Display name field
                    TextFormField(
                      controller: _displayNameController,
                      decoration: InputDecoration(
                        labelText: 'Nom complet',
                        hintText: 'Jean Dupont',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Nom requis';
                        }
                        if (value!.length < 3) {
                          return 'Le nom doit contenir au moins 3 caractères';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'votre.email@example.com',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Email requis';
                        }
                        if (!RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                            .hasMatch(value!)) {
                          return 'Email invalide';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: _validatePassword,
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: 8),

                    // Password strength indicator
                    if (_passwordController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Critères du mot de passe:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _PasswordCriteria(
                              text: 'Au moins 6 caractères',
                              isValid:
                                  _passwordController.text.length >= 6,
                            ),
                            _PasswordCriteria(
                              text: 'Au moins une lettre majuscule',
                              isValid: RegExp(r'(?=.*[A-Z])')
                                  .hasMatch(_passwordController.text),
                            ),
                            _PasswordCriteria(
                              text: 'Au moins une lettre minuscule',
                              isValid: RegExp(r'(?=.*[a-z])')
                                  .hasMatch(_passwordController.text),
                            ),
                            _PasswordCriteria(
                              text: 'Au moins un chiffre',
                              isValid: RegExp(r'(?=.*[0-9])')
                                  .hasMatch(_passwordController.text),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Confirm password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirmer le mot de passe',
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Confirmer le mot de passe';
                        }
                        if (value != _passwordController.text) {
                          return 'Les mots de passe ne correspondent pas';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Terms and conditions checkbox
                    CheckboxListTile(
                      value: _agreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreedToTerms = value ?? false;
                        });
                      },
                      title: RichText(
                        text: TextSpan(
                          text: 'J\'accepte les ',
                          style: const TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(
                              text: 'conditions d\'utilisation',
                              style: TextStyle(
                                color: AppTheme.sampanaPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),

                    const SizedBox(height: 24),

                    // Register button
                    Obx(
                      () => ElevatedButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.sampanaPrimaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: authController.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Créer un compte',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Vous avez déjà un compte? '),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Text(
                            'Connectez-vous',
                            style: TextStyle(
                              color: AppTheme.sampanaPrimaryColor,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper widget for password criteria
class _PasswordCriteria extends StatelessWidget {
  final String text;
  final bool isValid;

  const _PasswordCriteria({
    required this.text,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isValid ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isValid ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
