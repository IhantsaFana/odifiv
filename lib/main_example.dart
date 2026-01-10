import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'config/firebase_config.dart';
import 'config/app_theme.dart';
import 'services/offline_service.dart';
import 'services/connectivity_service.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    logger.i('Initializing Firebase...');
    await FirebaseConfig.initialize();

    // Initialize Offline Service (Hive)
    logger.i('Initializing offline storage...');
    await OfflineService().initialize();

    // Register GetX Services
    logger.i('Registering GetX services...');
    Get.put<ConnectivityService>(ConnectivityService());

    logger.i('App initialization complete');
  } catch (e) {
    logger.e('Error during app initialization: $e');
    rethrow;
  }

  runApp(const FivondronanaApp());
}

class FivondronanaApp extends StatelessWidget {
  const FivondronanaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fivondronana',
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      // TODO: Configure routes with GetX
      // getPages: AppRoutes.pages,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fivondronana'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.scout_outlined,
              size: 80,
              color: Color(0xFF1a4d7e),
            ),
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
