import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const AuthHeader({
    required this.title,
    required this.subtitle,
    this.icon = Icons.shield_rounded,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Decorative circles background
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1a4d7e).withOpacity(0.1),
                    const Color(0xFFFF6B35).withOpacity(0.05),
                  ],
                ),
              ),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1a4d7e).withOpacity(0.15),
                    const Color(0xFFFF6B35).withOpacity(0.1),
                  ],
                ),
              ),
            ),
            Icon(icon, size: 60, color: const Color(0xFF1a4d7e)),
          ],
        ),
        const SizedBox(height: 30),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.sampanaPrimaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
