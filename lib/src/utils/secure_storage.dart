import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._internal();
  static SecureStorage _instance = SecureStorage._internal();
  static SecureStorage get instance => _instance;

  final _secureStorage = FlutterSecureStorage();

  Future<void> addNewItem(String value, String key) async {
    await _secureStorage.write(
      key: key,
      value: value,
    );
  }

  Future<String?> readItem(String key) async {
    final item = await _secureStorage.read(
      key: key,
    );
    return item;
  }
}
