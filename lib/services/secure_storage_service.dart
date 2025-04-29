import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final _storage = const FlutterSecureStorage();

  static Future<void> saveUsername(String username) async {
    await _storage.write(key: 'username', value: username);
  }

  static Future<void> savePassword(String password) async {
    await _storage.write(key: 'password', value: password);
  }

  static Future<String?> getUsername() async {
    return await _storage.read(key: 'username');
  }

  static Future<String?> getPassword() async {
    return await _storage.read(key: 'password');
  }

  static Future<void> clearCredentials() async {
    await _storage.delete(key: 'username');
    await _storage.delete(key: 'password');
  }

  
}
