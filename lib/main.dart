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
import 'screens/auth/register_screen.dart';

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

  runApp(const FivondronanaApp());
}

class FivondronanaApp extends StatelessWidget {
  const FivondronanaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fivondronana',
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
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

    return Obx(() {
      if (authController.isAuthenticated.value) {
        return const HomeScreen();
      } else {
        return const LoginScreen();
      }
    });
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fivondronana'), elevation: 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 80, color: Color(0xFF1a4d7e)),
            const SizedBox(height: 20),
            Text(
              'Bienvenue à Fivondronana',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Digitalisation du Scout Protestant',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to login or home
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bienvenue! À implémenter...')),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Text('Commencer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
