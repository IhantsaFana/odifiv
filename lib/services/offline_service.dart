import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class OfflineService {
  static final OfflineService _instance = OfflineService._internal();
  late Box<dynamic> _localDB;
  final logger = Logger();

  OfflineService._internal();

  factory OfflineService() {
    return _instance;
  }

  Future<void> initialize() async {
    try {
      await Hive.initFlutter();
      _localDB = await Hive.openBox('fivondronana_db');
      logger.i('Offline storage initialized');
    } catch (e) {
      logger.e('Failed to initialize offline storage: $e');
      rethrow;
    }
  }

  Future<void> saveData(String key, dynamic value) async {
    try {
      await _localDB.put(key, value);
      logger.d('Data saved: $key');
    } catch (e) {
      logger.e('Failed to save data: $e');
      rethrow;
    }
  }

  dynamic getData(String key) {
    try {
      return _localDB.get(key);
    } catch (e) {
      logger.e('Failed to get data: $e');
      return null;
    }
  }

  Future<void> deleteData(String key) async {
    try {
      await _localDB.delete(key);
      logger.d('Data deleted: $key');
    } catch (e) {
      logger.e('Failed to delete data: $e');
      rethrow;
    }
  }

  Future<void> clearAll() async {
    try {
      await _localDB.clear();
      logger.i('All data cleared');
    } catch (e) {
      logger.e('Failed to clear data: $e');
      rethrow;
    }
  }
}
