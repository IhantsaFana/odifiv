import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'config/app_theme.dart';
import 'services/offline_service.dart';
import 'services/connectivity_service.dart';
import 'controllers/auth_controller.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/complete_profile_screen.dart';
import 'screens/home/home_screen.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    logger.i('Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Offline Service (Hive)
    logger.i('Initializing offline storage...');
    await OfflineService().initialize();

    // Register GetX Services
    logger.i('Registering GetX services...');
    Get.put<OfflineService>(OfflineService());
    Get.put<ConnectivityService>(ConnectivityService());
    Get.put<AuthController>(AuthController());

    logger.i('App initialization complete');
  } catch (e) {
    logger.e('Error during app initialization: $e');
    rethrow;
  }

  runApp(const HarambatoApp());
}

class HarambatoApp extends StatelessWidget {
  const HarambatoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Harambato',
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/complete-profile', page: () => const CompleteProfileScreen()),
      ],
      home: const AuthWrapper(),
    );
  }
}

// Wrapper to handle auth state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    // Check auth state + profile state
    return Obx(() {
      if (!authController.isAuthenticated.value) {
        return const LoginScreen();
      } else if (!authController.hasProfile.value) {
        return const CompleteProfileScreen();
      } else {
        return const HomeScreen();
      }
    });
  }
}
