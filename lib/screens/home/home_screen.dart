import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../dashboard/dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject dependencies
    final controller = Get.put(HomeController());
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.grey[50], // Background léger
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Obx(() => CustomHeader(
          title: controller.currentTitle,
          showLogo: true, // Montrer logo uniquement si besoin
          trailing: IconButton(
            onPressed: () {
              // Action rapide ou Menu
              // Pour l'instant Logout via dialog
              _showLogoutDialog(context, authController);
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded, size: 20, color: Colors.black87),
            ),
          ),
        )),
      ),
      body: Obx(() {
        switch (controller.currentIndex.value) {
          case 0:
            return const DashboardScreen();
          case 1:
            return const Center(child: Text('Calendrier - Coming Soon'));
          case 2:
            return const Center(child: Text('Membres - Coming Soon'));
          case 3:
            return const Center(child: Text('Profil - Coming Soon'));
          default:
            return const DashboardScreen();
        }
      }),
      bottomNavigationBar: Obx(() => CustomBottomNav(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changeTab,
      )),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthController authController) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hivoaka'),
        content: const Text('Te hivoaka tokoa ve ise ?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tsia'),
          ),
          TextButton(
            onPressed: () async {
              await authController.logout();
              Get.offAllNamed('/login');
            },
            child: const Text('Eny', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
