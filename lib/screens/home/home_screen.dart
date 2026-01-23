import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../members/members_screen.dart';
import '../calendar/calendar_screen.dart';
import '../profile/profile_screen.dart';
import '../dashboard/dashboard_screen.dart'; // Import manquant ajouté

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
        preferredSize: const Size.fromHeight(70),
        child: Obx(() => CustomHeader(
          title: controller.currentTitle,
          showLogo: true,
          // Pas de bouton trailing (logout déplacé dans Profil/Paramètres)
        )),
      ),
      body: Obx(() {
        switch (controller.currentIndex.value) {
          case 0:
            return const DashboardScreen();
          case 1:
            return const CalendarScreen();
          case 2:
            return const MembersScreen();
          case 3:
            return const ProfileScreen();
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
