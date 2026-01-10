import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final logger = Logger();
  
  final RxBool isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final isConnected = !results.contains(ConnectivityResult.none);
      isOnline.value = isConnected;
      logger.i('Connectivity changed: ${isOnline.value ? "Online" : "Offline"}');
    });
  }

  Future<bool> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }
}
