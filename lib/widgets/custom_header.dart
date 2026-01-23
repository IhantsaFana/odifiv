import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? trailing;
  final bool showLogo;

  const CustomHeader({
    super.key,
    required this.title,
    this.trailing,
    this.showLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12, // Très compact en haut
        left: 24,
        right: 24,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[100]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (showLogo) ...[
                Image.asset(
                  'assets/images/logo.png',
                  height: 38, // Taille restaurée et bien visible
                  width: 38,
                ),
                const SizedBox(width: 12),
              ],
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.sampanaPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ],
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70); // Réduit de 80 à 70
}
