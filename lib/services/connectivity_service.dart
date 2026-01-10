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
    _connectivity.onConnectivityChanged.listen((result) {
      isOnline.value = result != ConnectivityResult.none;
      logger.i('Connectivity changed: ${isOnline.value ? "Online" : "Offline"}');
    });
  }

  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
